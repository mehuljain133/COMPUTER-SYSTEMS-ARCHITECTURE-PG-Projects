// Unit-I Basic Building Blocks: Boolean logic and Boolean algebra, tri-state logic; flip-flops, counters,shift registers, adders, subtractor, encoders, decoders, multiplexors, de-multiplexors

module all_in_one_system(
    // Inputs
    input CLK, RESET, A, B, C, SHIFT_IN, SEL0, SEL1, D,
    // Outputs
    output AND_out, OR_out, XOR_out, NOT_out, Q, // For boolean logic and flip-flop
    output [3:0] count, SUM, DIFF, shift_out, Y, // For counter, adder, subtractor, shift register
    output CARRY, BORROW, mux_out, decoder_out, demux_out
);

    // --- Boolean Logic ---
    assign AND_out = A & B;
    assign OR_out = A | B;
    assign XOR_out = A ^ B;
    assign NOT_out = ~A;

    // --- D Flip-Flop ---
    reg Q_reg;
    always @(posedge CLK or posedge RESET)
    begin
        if (RESET)
            Q_reg <= 0;
        else
            Q_reg <= A;  // For simplicity, using A as input
    end
    assign Q = Q_reg;

    // --- 4-bit Counter ---
    reg [3:0] count_reg;
    always @(posedge CLK or posedge RESET)
    begin
        if (RESET)
            count_reg <= 4'b0000;
        else
            count_reg <= count_reg + 1;
    end
    assign count = count_reg;

    // --- 4-bit Adder ---
    assign {CARRY, SUM} = A + B;

    // --- 4-bit Subtractor ---
    assign {BORROW, DIFF} = A - B;

    // --- Shift Register ---
    reg [3:0] shift_out_reg;
    always @(posedge CLK or posedge RESET)
    begin
        if (RESET)
            shift_out_reg <= 4'b0000;
        else
            shift_out_reg <= {shift_out_reg[2:0], SHIFT_IN};
    end
    assign shift_out = shift_out_reg;

    // --- 2-to-1 Multiplexer ---
    assign mux_out = (SEL0) ? B : A;

    // --- 2-to-4 Decoder ---
    always @(A or B)
    begin
        case(A)
            2'b00: Y = 4'b0001;
            2'b01: Y = 4'b0010;
            2'b10: Y = 4'b0100;
            2'b11: Y = 4'b1000;
            default: Y = 4'b0000;
        endcase
    end

    // --- 1-to-4 Demultiplexer ---
    always @(D or SEL0 or SEL1)
    begin
        case({SEL1, SEL0})
            2'b00: demux_out = 4'b0001;
            2'b01: demux_out = 4'b0010;
            2'b10: demux_out = 4'b0100;
            2'b11: demux_out = 4'b1000;
            default: demux_out = 4'b0000;
        endcase
    end

endmodule

