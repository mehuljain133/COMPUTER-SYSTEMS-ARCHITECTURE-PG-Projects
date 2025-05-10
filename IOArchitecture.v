// Unit-IV Input-Output Architecture: Input/Output devices; data transfer schemes - programmed I/O and DMA transfer; data transfer schemes for microprocessors. 

module io_architecture(
    input CLK, RESET, // Clock and reset
    input [7:0] DATA_IN, // Data input from peripheral
    input [7:0] IO_ADDR, // I/O address for device selection
    input [7:0] MEM_ADDR, // Memory address for DMA
    input [7:0] DMA_DATA, // Data for DMA
    input PIO_READ, PIO_WRITE, // Programmed I/O control signals
    input DMA_REQUEST, DMA_ACK, // DMA control signals
    output reg [7:0] DATA_OUT, // Data output to peripheral
    output reg [7:0] MEM_OUT, // Data output to memory for DMA
    output reg PIO_STATUS, // Status of PIO operation
    output reg DMA_STATUS // Status of DMA operation
);

// --- Programmed I/O (PIO) Device ---
reg [7:0] io_device [15:0]; // I/O device with 16 locations
always @(posedge CLK or posedge RESET) begin
    if (RESET) begin
        PIO_STATUS <= 0;
        DATA_OUT <= 8'b00000000;
    end else begin
        if (PIO_WRITE) begin
            io_device[IO_ADDR] <= DATA_IN; // Write to I/O device
            PIO_STATUS <= 1; // Indicate successful write
        end else if (PIO_READ) begin
            DATA_OUT <= io_device[IO_ADDR]; // Read from I/O device
            PIO_STATUS <= 1; // Indicate successful read
        end else begin
            PIO_STATUS <= 0; // Idle state
        end
    end
end

// --- DMA (Direct Memory Access) ---
// DMA Controller (simplified)
reg [7:0] memory [31:0]; // 32 locations of memory (simulating RAM)
reg [7:0] dma_buffer; // DMA buffer for data transfer
always @(posedge CLK or posedge RESET) begin
    if (RESET) begin
        DMA_STATUS <= 0;
        MEM_OUT <= 8'b00000000;
        dma_buffer <= 8'b00000000;
    end else begin
        if (DMA_REQUEST && !DMA_ACK) begin
            // DMA request is initiated, transfer data from peripheral to memory
            dma_buffer <= DMA_DATA; // Store data from peripheral
            memory[MEM_ADDR] <= dma_buffer; // Write to memory
            DMA_STATUS <= 1; // Indicate DMA transfer in progress
        end else if (DMA_ACK) begin
            // DMA acknowledgement, transfer complete
            MEM_OUT <= memory[MEM_ADDR]; // Output memory data
            DMA_STATUS <= 0; // Indicate DMA transfer complete
        end else begin
            DMA_STATUS <= 0; // Idle state
        end
    end
end

endmodule
