module testbench();

    reg clock, reset;
    reg [3:0] pushbuttons;
    wire phase, c_flag, z_flag;
    wire [3:0] instr, oprnd, accu, data_bus, FF_out;
    wire [7:0] program_byte;
    wire [11:0] PC, address_RAM;
    uP uPmodule(reset, clock, pushbuttons, phase, c_flag, z_flag, instr, oprnd,
                 data_bus, FF_out, accu, program_byte, PC, address_RAM);

    initial
        #1000 $finish;

    always
        #5 clock = ~clock;

endmodule
