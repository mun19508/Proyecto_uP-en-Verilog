//Control_Intrucciones
//Daniel Mundo 19508
//Este arhivo contiene todos los modulos correspondientes para la distribucion
//de la información contenida en la ROM.
//******************************************************************************
module Fetch(input wire eneable2, reset2, clk2, input wire [7:0]D, output wire [3:0] ins, op);
  FlipFlopD_4b ff1(eneable2, reset2, clk2, D[3:0], op);
  FlipFlopD_4b ff2(eneable2, reset2, clk2, D[7:4], ins);
endmodule //El modulo implementa dos FF tipo D de cuatro bits del archivo "Modulos_auxiliares.v"
          //la explicacion de como funcionan estos FF esta en el archivo antes men-
          //cionados.
//******************************************************************************
module ROM(input wire [11:0]direccion, output wire [7:0]dato);
  reg [7:0] Memoria [0:4095];
  initial
    $readmemh("memory.list", Memoria);
  assign dato = Memoria[direccion];
endmodule //Este modulo extrae la informacion contenida en el archivo ".txt", a
          //partir del valor de entrada.
//******************************************************************************
module counter_12b(input clk, reset, load, eneable, input [11:0] b, output reg [11:0] c);
  always @ (posedge clk, posedge reset) begin
    if (reset)
      c <= 12'b0;
    else if (load)
      c <= b;
    else if (eneable)
      c = c + 1;
  end
endmodule //Este modulo describe el funcionamiento de un contador, que tiene un
          //valor de precargable, un bit para resetear su cuenta, y un bit que
          //la funcion de habilitar el conteo.
//******************************************************************************
module control_intrucciones(input wire [11:0] valor, input wire eneable_fetch, eneable_counter, reset, clk, load,
                            output wire [3:0] instr, oprnd, output wire [7:0] prog_b, output wire [11:0]count);
    wire [11:0] count_w;
    assign count = count_w;
    counter_12b c0(clk, reset, load, eneable_counter, valor, count_w);
    ROM r0(count_w, prog_b);
    Fetch f0(eneable_fetch, reset, clk, prog_b, instr, oprnd);
endmodule //En este modulo se conectan la salida del cotador a la entrada de la
          //memoria ROM que a su ves tiene su salida conectada a la  entrada de
          //los FF tipo D de 4 bits.
