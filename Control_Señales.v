//Control_Señales
//Daniel Mundo 19508
//Este arhivo contiene todos los modulos correspondientes para la distribucion
//de la instrucciones que se deben llevar a cabo apartir de la informacion conte
//-nida en la ROM.
//******************************************************************************
module Flags(input wire eneable2, reset2, clk2, Carry, Zero, output reg [1:0]flag);
   always @ (posedge clk2, posedge reset2) begin
      if (reset2) begin
        flag[0] <= 0;
        flag[1] <= 0;
      end
      else if (eneable2) begin
        flag[0] <= Zero;
        flag[1] <= Carry;
      end
    end
endmodule //El funcionamiento de este modulo es similar al modulo "FlipFlopD_4b",
          //del archivo "Modulos_auxiliares.v", la diferencia esta que en este
          //se realiza el procedimiento para dos valores distintos al mismo tiempo.
//******************************************************************************
module Phase(input wire eneable3, reset3, clk3, output wire Q);
    FlipFlopD f0(eneable3, reset3, clk3, ~Q, Q);
endmodule //Este modulo describe que durante cada flanco de reloj la entrada "D"
          //del FlipFlop tipo D es el valor inverso de la salida actual "Q".
//******************************************************************************
module DECODE(input wire [6:0]direccion, output reg [12:0] valor);
    always @ ( direccion ) begin
      casez(direccion)
        7'b??????0 : valor <= 13'b1000000001000;//any
        7'b00001?1 : valor <= 13'b0100000001000;//JC
        7'b00000?1 : valor <= 13'b1000000001000;//JC
        7'b00011?1 : valor <= 13'b1000000001000;//JNC
        7'b00010?1 : valor <= 13'b0100000001000;//JNC
        7'b0010??1 : valor <= 13'b0001001000010;//CMPM
        7'b0011??1 : valor <= 13'b1001001100000;//IN
        7'b0100??1 : valor <= 13'b0011010000010;//LIT
        7'b0101??1 : valor <= 13'b0011010000100;//LD
        7'b0110??1 : valor <= 13'b1011010100000;//ST
        7'b0111??1 : valor <= 13'b1000000111000;//JZ
        7'b1000?11 : valor <= 13'b0100000001000;//JZ
        7'b1000?01 : valor <= 13'b1000000001000;//JNZ
        7'b1001?11 : valor <= 13'b1000000001000;//JNZ
        7'b1001?01 : valor <= 13'b0100000001000;//ADDI
        7'b1010??1 : valor <= 13'b0011011000010;//ADDM
        7'b1011??1 : valor <= 13'b1011011100000;//JMP
        7'b1100??1 : valor <= 13'b0100000001000;//OUT
        7'b1101??1 : valor <= 13'b0000000001001;//NANDI
        7'b1110??1 : valor <= 13'b0011100000010;//NANDM
        7'b1111??1 : valor <= 13'b1011100100000;
        default: valor <= 13'b0;//cualquier valor que no coincida con los anteriores es 0.
      endcase
    end
endmodule //En este modulo se especifica todas las acciones posibles que el proce-
          //sador puede llevar a cabo, el significado de cada bit se explica en el
          //apartado "Habilitar operaciones" de "Asignaciones auxiliares".
//******************************************************************************
module control_signals(input wire eneable, reset, clk, carry, zero, input wire [3:0]instr,
                        output wire p, output wire [12:0]signal, output[1:0]f);
  wire [6:0]control;
  assign control= {instr, f, p};
  Flags f1(eneable, reset, clk, carry, zero, f);
  Phase p0(1'b1, reset, clk, p);
  DECODE d0(control, signal);
endmodule //En este modulo se lleva a cabo la conexion de las entradas del Decode,
          //que son el valor de "instr" (que viene del Fetch), las banderas de
          //carry & zero (que vienen de la ALU) y el valor de "phase" que proviene
          //de un FF tipo T (que ademas sirve como eneable para el "Fetch").
