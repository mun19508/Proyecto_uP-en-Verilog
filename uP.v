//Proyecto 2: uP en Verilog
//Daniel Mundo 19508
//Este arhivo contiene toda las interconecciones necesarias para que un procesador
//de 4 bits funcione.
//******************************************************************************
module uP(input wire reset, clock, input wire [3:0] pushbuttons,  output wire phase, c_flag, z_flag,
          output wire [3:0] instr, oprnd, data_bus, FF_out, accu, output wire [7:0]program_byte,
          output wire [11:0] PC, address_RAM);
  //---------------------Cables auxiliares--------------------------------------
    wire loadOut, oeOprnd, oeIn, oeALU, weRAM, csRAM, loadFlags, loadA, loadPC, incPC;
    wire c,z;
    wire [2:0] s;
    wire [3:0] ALUOut;
    wire [11:0] RAM_adress;
    wire [12:0] signals;
  //-------------------------Asignaciones auxiliares--------------------------
    //---Habilitar operaciones---
    assign loadOut = signals[0]; //Habilita la salida del FF de Out.
    assign oeOprnd = signals[1]; //Habilita la entrada de datos desde el Fetch.
    assign oeIn = signals[2]; //Habilita la entrada de datos desde los push buttons.
    assign oeALU = signals[3]; //Habilita la entrada de datos desde la salida de la ALU.
    assign weRAM = signals[4];//Habilita la escritura en la RAM
    assign csRAM = signals[5];//Habilita la lectura en la RAM
    assign s = signals[8:6]; //Selecciona la operacion a llevar a cabo en la ALU.
    assign loadFlags = signals[9]; //Habilita la entrada de las banderas de carry & zero.
    assign loadA = signals[10]; //Dejar pasar el valor del acumulador a la ALU.
    assign loadPC = signals[11];//Habilita la precarga del contador.
    assign incPC = signals[12];//Habilita el incremento del contador.
    //---------Direccion de la RAM----------
    assign address_RAM = {oprnd, program_byte};
  //--------------------Interconeccion de bloques-----------------------------
    control_intrucciones Control_I0(address_RAM, ~phase, incPC, reset, clock, loadPC, instr, oprnd, program_byte, PC);
    control_signals Control_S1(loadFlags, reset, clock, c, z, instr, phase, signals,{c_flag,z_flag});
    operaciones Op0(data_bus, s, clock, reset, loadA, ALUOut, accu, z, c);
    RAM M0(address_RAM, csRAM, weRAM, data_bus);
    Buffer4bits bus_driver0(oeOprnd, oprnd, data_bus);//Bus driver del Fetch
    Buffer4bits bus_driver1(oeIn, pushbuttons, data_bus);//Bus driver de los push buttons
    Buffer4bits bus_driver2(oeALU, ALUOut, data_bus);//Bus driver de la ALU
    FlipFlopD_4b FF0(loadOut, reset, clock, data_bus, FF_out);//FF de la salida
endmodule //En este modulo se describe las interconecciones entre los modulos finales
          //de cada archivo con el sufijo "Control_".
