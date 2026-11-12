`timescale 1ns/1ps

module tb_ldpc_5g_axi_top;

    reg aclk;
    reg aresetn;

    // AXI4-Stream input
    reg [7:0] s_axis_tdata;
    reg s_axis_tvalid;
    wire s_axis_tready;
    reg s_axis_tlast;

    // AXI4-Stream output
    wire [7:0] m_axis_tdata;
    wire m_axis_tvalid;
    reg m_axis_tready;
    wire m_axis_tlast;

    // AXI4-Lite write address
    reg [7:0] s_axi_awaddr;
    reg s_axi_awvalid;
    wire s_axi_awready;

    // AXI4-Lite write data
    reg [31:0] s_axi_wdata;
    reg [3:0] s_axi_wstrb;
    reg s_axi_wvalid;
    wire s_axi_wready;

    // AXI4-Lite write response
    wire [1:0] s_axi_bresp;
    wire s_axi_bvalid;
    reg s_axi_bready;

    // AXI4-Lite read address
    reg [7:0] s_axi_araddr;
    reg s_axi_arvalid;
    wire s_axi_arready;

    // AXI4-Lite read data
    wire [31:0] s_axi_rdata;
    wire [1:0] s_axi_rresp;
    wire s_axi_rvalid;
    reg s_axi_rready;

    integer i;
    integer output_beats;
    integer error_count;
    integer timeout_count;
    reg [31:0] status_value;

    // ------------------------------------------------
    // DUT
    // ------------------------------------------------

    ldpc_5g_axi_top dut (
        .aclk(aclk),
        .aresetn(aresetn),

        .s_axis_tdata(s_axis_tdata),
        .s_axis_tvalid(s_axis_tvalid),
        .s_axis_tready(s_axis_tready),
        .s_axis_tlast(s_axis_tlast),

        .m_axis_tdata(m_axis_tdata),
        .m_axis_tvalid(m_axis_tvalid),
        .m_axis_tready(m_axis_tready),
        .m_axis_tlast(m_axis_tlast),

        .s_axi_awaddr(s_axi_awaddr),
        .s_axi_awvalid(s_axi_awvalid),
        .s_axi_awready(s_axi_awready),

        .s_axi_wdata(s_axi_wdata),
        .s_axi_wstrb(s_axi_wstrb),
        .s_axi_wvalid(s_axi_wvalid),
        .s_axi_wready(s_axi_wready),

        .s_axi_bresp(s_axi_bresp),
        .s_axi_bvalid(s_axi_bvalid),
        .s_axi_bready(s_axi_bready),

        .s_axi_araddr(s_axi_araddr),
        .s_axi_arvalid(s_axi_arvalid),
        .s_axi_arready(s_axi_arready),

        .s_axi_rdata(s_axi_rdata),
        .s_axi_rresp(s_axi_rresp),
        .s_axi_rvalid(s_axi_rvalid),
        .s_axi_rready(s_axi_rready)
    );

    // ------------------------------------------------
    // Clock
    // ------------------------------------------------

    initial begin
        aclk = 1'b0;
        forever #5 aclk = ~aclk;
    end

    // ------------------------------------------------
    // AXI4-Lite write task
    // AW and W are deliberately sent independently.
    // ------------------------------------------------

    task axi_write;
        input [7:0] address;
        input [31:0] data;
        begin

            // Address channel
            @(negedge aclk);
            s_axi_awaddr = address;
            s_axi_awvalid = 1'b1;

            do @(posedge aclk);
            while (!s_axi_awready);

            @(negedge aclk);
            s_axi_awvalid = 1'b0;

            // Write data channel, sent separately
            repeat (2) @(negedge aclk);

            s_axi_wdata = data;
            s_axi_wstrb = 4'b1111;
            s_axi_wvalid = 1'b1;

            do @(posedge aclk);
            while (!s_axi_wready);

            @(negedge aclk);
            s_axi_wvalid = 1'b0;

            // Write response
            s_axi_bready = 1'b1;

            timeout_count = 0;
            while (!s_axi_bvalid && timeout_count < 20) begin
                @(posedge aclk);
                timeout_count = timeout_count + 1;
            end

            if (!s_axi_bvalid) begin
                $display("FAIL: AXI write response timeout at address %h",
                         address);
                $fatal;
            end

            if (s_axi_bresp != 2'b00) begin
                $display("FAIL: AXI write response error");
                $fatal;
            end

            @(posedge aclk);
            @(negedge aclk);
            s_axi_bready = 1'b0;

        end
    endtask

    // ------------------------------------------------
    // AXI4-Lite read task
    // ------------------------------------------------

    task axi_read;
        input [7:0] address;
        output [31:0] data;
        begin

            @(negedge aclk);
            s_axi_araddr = address;
            s_axi_arvalid = 1'b1;

            do @(posedge aclk);
            while (!s_axi_arready);

            @(negedge aclk);
            s_axi_arvalid = 1'b0;
            s_axi_rready = 1'b1;

            timeout_count = 0;
            while (!s_axi_rvalid && timeout_count < 20) begin
                @(posedge aclk);
                timeout_count = timeout_count + 1;
            end

            if (!s_axi_rvalid) begin
                $display("FAIL: AXI read response timeout at address %h",
                         address);
                $fatal;
            end

            data = s_axi_rdata;

            if (s_axi_rresp != 2'b00) begin
                $display("FAIL: AXI read response error");
                $fatal;
            end

            @(posedge aclk);
            @(negedge aclk);
            s_axi_rready = 1'b0;

        end
    endtask

    // ------------------------------------------------
    // AXI4-Stream input task
    // ------------------------------------------------

    task send_input_beat;
        input [7:0] data;
        input last;
        begin

            @(negedge aclk);

            s_axis_tdata = data;
            s_axis_tlast = last;
            s_axis_tvalid = 1'b1;

            do @(posedge aclk);
            while (!s_axis_tready);

            @(negedge aclk);
            s_axis_tvalid = 1'b0;
            s_axis_tlast = 1'b0;

        end
    endtask

    // ------------------------------------------------
    // Main test
    // ------------------------------------------------

    initial begin

        aresetn = 1'b0;

        s_axis_tdata = 0;
        s_axis_tvalid = 0;
        s_axis_tlast = 0;

        m_axis_tready = 0;

        s_axi_awaddr = 0;
        s_axi_awvalid = 0;

        s_axi_wdata = 0;
        s_axi_wstrb = 0;
        s_axi_wvalid = 0;

        s_axi_bready = 0;

        s_axi_araddr = 0;
        s_axi_arvalid = 0;
        s_axi_rready = 0;

        output_beats = 0;
        error_count = 0;
        timeout_count = 0;
        status_value = 0;

        $display("----------------------------------------");
        $display("BLOCK 21 AXI INTEGRATION TEST");
        $display("----------------------------------------");

        // Reset
        repeat (5) @(posedge aclk);

        @(negedge aclk);
        aresetn = 1'b1;

        repeat (5) @(posedge aclk);

        // Configure BG1
        $display("Configuring BG1...");
        axi_write(8'h08, 32'd0);

        // Configure Zc = 2
        $display("Configuring lifting size Zc=2...");
        axi_write(8'h0C, 32'd2);

        // Configure maximum iterations = 10
        $display("Configuring maximum iterations...");
        axi_write(8'h10, 32'd10);

        // Read configuration back
        axi_read(8'h08, status_value);

        if (status_value[0] !== 1'b0) begin
            $display("FAIL: BG configuration readback");
            $fatal;
        end

        axi_read(8'h0C, status_value);

        if (status_value[9:0] !== 10'd2) begin
            $display("FAIL: Zc configuration readback");
            $fatal;
        end

        $display("AXI-Lite configuration PASS");

        // Start decoder
        $display("Starting decoder...");
        axi_write(8'h00, 32'd1);

        // Send 68 * 2 = 136 LLR values.
        // Positive LLR represents hard bit zero.
        $display("Sending 136 input LLR values...");

        for (i = 0; i < 136; i = i + 1) begin
            send_input_beat(
                8'h14,
                (i == 135)
            );
        end

        $display("All input LLR values transmitted.");

        // Wait for decoder completion.
        timeout_count = 0;

        while (timeout_count < 200000) begin

            axi_read(8'h04, status_value);

            if (status_value[1])
                timeout_count = 200000;
            else
                timeout_count = timeout_count + 1;

        end

        if (!status_value[1]) begin
            $display("FAIL: Decoder completion timeout");
            $fatal;
        end

        $display("Decoder completed.");
        $display("STATUS = %h", status_value);

        if (status_value[3]) begin
            $display("FAIL: Decoder reported an error");
            $fatal;
        end

        if (!status_value[2]) begin
            $display("FAIL: Decoder did not report success");
            $fatal;
        end

        // Read loaded count
        axi_read(8'h14, status_value);

        $display("Loaded LLR count = %0d", status_value);

        if (status_value != 136) begin
            $display("FAIL: Incorrect loaded LLR count");
            $fatal;
        end

        // Enable output with periodic backpressure.
        $display("Receiving decoded output stream...");

        output_beats = 0;
        error_count = 0;

        timeout_count = 0;

        while (output_beats < 136 && timeout_count < 20000) begin

            @(negedge aclk);

            // Introduce output backpressure.
            if ((timeout_count % 7) < 4)
                m_axis_tready = 1'b1;
            else
                m_axis_tready = 1'b0;

            @(posedge aclk);

            if (m_axis_tvalid && m_axis_tready) begin

                if (m_axis_tdata !== 8'h00) begin
                    error_count = error_count + 1;
                    $display(
                        "Unexpected decoded bit at beat %0d: %h",
                        output_beats,
                        m_axis_tdata
                    );
                end

                if (m_axis_tlast !== (output_beats == 135)) begin
                    error_count = error_count + 1;
                    $display(
                        "TLAST error at output beat %0d",
                        output_beats
                    );
                end

                output_beats = output_beats + 1;

            end

            timeout_count = timeout_count + 1;

        end

        @(negedge aclk);
        m_axis_tready = 1'b0;

        if (output_beats != 136) begin
            $display("FAIL: Output timeout. Received %0d beats",
                     output_beats);
            $fatal;
        end

        if (error_count != 0) begin
            $display("FAIL: %0d output errors detected", error_count);
            $fatal;
        end

        // ------------------------------------------------
        // Negative test: premature AXI-Stream TLAST
        // ------------------------------------------------

        $display("Testing premature TLAST rejection...");

        // Start a fresh transaction.
        axi_write(8'h00, 32'd1);

        // BG1, Zc=2 requires 136 beats.
        // Assert TLAST on the first beat deliberately.
        send_input_beat(8'h14, 1'b1);

        // Wait for the decoder to report the loader error.
        timeout_count = 0;
        status_value = 32'd0;

        while (!status_value[1] && timeout_count < 100) begin
            axi_read(8'h04, status_value);
            timeout_count = timeout_count + 1;
        end

        if (!status_value[1]) begin
            $display("FAIL: Early-TLAST transaction did not complete");
            $fatal;
        end

        if (!status_value[3]) begin
            $display("FAIL: Early-TLAST error was not reported");
            $fatal;
        end

        if (status_value[2]) begin
            $display("FAIL: Decoder incorrectly reported success");
            $fatal;
        end

        // Confirm that only the first beat was accepted.
        axi_read(8'h14, status_value);

        if (status_value != 1) begin
            $display("FAIL: Incorrect loaded count after early TLAST: %0d",
                     status_value);
            $fatal;
        end

        // No decoded output must be generated for an invalid input frame.
        repeat (20) begin
            @(posedge aclk);

            if (m_axis_tvalid) begin
                $display("FAIL: Output generated after early TLAST");
                $fatal;
            end
        end

        $display("Early-TLAST rejection : PASS");
        $display("Error status          : PASS");
        $display("No output generated   : PASS");

        // ------------------------------------------------
        $display("----------------------------------------");
        $display("BLOCK 21 AXI TEST SUMMARY");
        $display("----------------------------------------");
        $display("AXI-Lite configuration : PASS");
        $display("AXI-Stream input       : PASS");
        $display("Decoder completion     : PASS");
        $display("AXI-Stream output      : PASS");
        $display("Output beats           : %0d", output_beats);
        $display("Output data errors     : %0d", error_count);
        $display("TLAST                  : PASS");
        $display("----------------------------------------");
        $display("PASS: BLOCK 21 AXI INTEGRATION");
        $display("----------------------------------------");

        $finish;

    end

    // Global watchdog
    initial begin
        #50000000;
        $display("FAIL: Global simulation timeout");
        $fatal;
    end

endmodule
