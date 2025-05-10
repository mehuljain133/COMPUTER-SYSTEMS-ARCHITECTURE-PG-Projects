// Unit-III Memory Unit: Primary memory, secondary memory, associative memory, sequential access,direct access storage devices.

module memory_unit(
    input CLK, RESET, // Global clock and reset
    input [3:0] ADDR, // Address for primary and secondary memory
    input [7:0] DATA_IN, // Data input for write operations
    input READ, WRITE, // Read/Write control signals
    input [7:0] SEARCH_KEY, // For associative memory search
    output reg [7:0] DATA_OUT, // Data output for memory
    output reg [7:0] SEARCH_RESULT // Result from associative memory search
);

// --- Primary Memory (RAM) ---
reg [7:0] primary_memory [15:0]; // 16 locations, 8-bit wide
always @(posedge CLK or posedge RESET) begin
    if (RESET)
        DATA_OUT <= 8'b00000000; // Reset output to 0
    else if (READ)
        DATA_OUT <= primary_memory[ADDR]; // Read from primary memory
    else if (WRITE)
        primary_memory[ADDR] <= DATA_IN; // Write to primary memory
end

// --- Secondary Memory (Simplified, like HDD/SSD) ---
reg [7:0] secondary_memory [31:0]; // 32 locations, 8-bit wide
always @(posedge CLK or posedge RESET) begin
    if (RESET)
        DATA_OUT <= 8'b00000000; // Reset output to 0
    else if (READ)
        DATA_OUT <= secondary_memory[ADDR]; // Read from secondary memory
    else if (WRITE)
        secondary_memory[ADDR] <= DATA_IN; // Write to secondary memory
end

// --- Associative Memory (Content-Addressable Memory - CAM) ---
reg [7:0] cam_memory [7:0]; // 8 words of 8-bit associative memory
reg [7:0] cam_data [7:0]; // Data associated with each entry
integer i;
always @(posedge CLK or posedge RESET) begin
    if (RESET)
        SEARCH_RESULT <= 8'b00000000; // Reset search result to 0
    else if (READ) begin
        // Associative memory search: compare SEARCH_KEY with stored data
        SEARCH_RESULT <= 8'b00000000; // Default: not found
        for (i = 0; i < 8; i = i + 1) begin
            if (cam_data[i] == SEARCH_KEY) begin
                SEARCH_RESULT <= cam_memory[i]; // Return associated data
            end
        end
    end
    else if (WRITE) begin
        // Write to CAM: store key in cam_memory and data in cam_data
        cam_memory[ADDR] <= DATA_IN;
        cam_data[ADDR] <= SEARCH_KEY;
    end
end

// --- Sequential Access Memory (Simplified Tape-like Memory) ---
reg [7:0] seq_memory [15:0]; // 16 locations, 8-bit wide (simulating a sequential device)
reg [3:0] seq_addr; // Sequential address pointer (simulating tape access)
always @(posedge CLK or posedge RESET) begin
    if (RESET)
        seq_addr <= 4'b0000; // Reset sequential access pointer
    else if (WRITE)
        seq_memory[seq_addr] <= DATA_IN; // Write data in sequential memory
    else if (READ) begin
        DATA_OUT <= seq_memory[seq_addr]; // Read from sequential memory
        seq_addr <= seq_addr + 1; // Move to the next location (simulating tape movement)
    end
end

// --- Direct Access Storage Device (Simulating Hard Disk/SSD) ---
reg [7:0] dasd_memory [31:0]; // 32 locations, 8-bit wide (representing a direct-access disk)
always @(posedge CLK or posedge RESET) begin
    if (RESET)
        DATA_OUT <= 8'b00000000; // Reset output to 0
    else if (READ)
        DATA_OUT <= dasd_memory[ADDR]; // Read from DASD memory
    else if (WRITE)
        dasd_memory[ADDR] <= DATA_IN; // Write to DASD memory
end

endmodule
