import serial

# Configure COM port and baud rate
ser = serial.Serial('COM9', 115200)

print("Listening for CPU Telemetry...")

while True:
    # Read the 11-byte packet
    packet = ser.read(11) 
    
    # Verify the terminator to ensure packet alignment
    if packet[10] != 0xFF:
        # If we are out of sync, flush the garbage and try again
        ser.reset_input_buffer()
        continue
    
    # Extract structural fields
    pc = packet[0]
    instr = (packet[1] << 8) | packet[2]
    alu_a = packet[3]
    alu_b = packet[4]
    alu_opcode = packet[5]
    alu_res = packet[6]
    write_addr = packet[7]
    write_data = packet[8]
    flags = packet[9]
    
    # Format the output string
    # :03b = 3-bit binary, :016b = 16-bit binary, :>3 = right-aligned 3-digit decimal
    output = (
        f"PC: {pc:03b} | "
        f"Inst: {instr:016b} | "
        f"ALU_Op: {alu_opcode:03b} | "
        f"W_Addr: {write_addr:02b} || "
        f"A: {alu_a:>3} | "
        f"B: {alu_b:>3} | "
        f"Res: {alu_res:>3} | "
        f"W_Data: {write_data:>3} | "
        f"Flags: {flags:04b}"
    )
    
    print(output)