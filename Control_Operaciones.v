//Operaciones
//Daniel Mundo 19508
//Este arhivo contiene todos los modulos correspondientes para llevar a cabo
//todas las operaciones aritmeticas que se espicifica en la información contenida
//en la ROM.
//******************************************************************************
module Accu(input wire [3:0]D4, input wire eneable4, reset4, clk4, output reg [3:0]Q4);
  always @ (posedge clk4, posedge reset4) begin
    if (reset4) Q4 <= 0;
    else if (eneable4) begin
        Q4 <= D4;
    end
  end
endmodule //Es parecido a un FlipFlop tipo D de cuatro bits (descrito en el archi-
          //vo "Modulos_auxiliares.v") de entrada y salida, si el bit eneable esta
          //en uno deja pasar la entrada D y si reset esta en uno limpia la salida.
//******************************************************************************
module ALU_aritmetica(input wire [3:0] A,B, input wire [2:0] Select,
                      output wire Zero, Carry, output wire [3:0]Y); //B corresponde a la
                      //salida del ACU.
  reg [4:0] Oprnd;
  assign Zero = ~(Y[3]|Y[2]|Y[1]|Y[0]); //Solo si todos los bits son cero, Zero esta en 1.
  assign Carry = Oprnd[4]; //Se enciende solo si el quinto bit de Oprnd es 1.
  assign Y = Oprnd[3:0];
  always @ (A, B, Select) begin // siempre que cambie control, A o B.
    case (Select)
      3'b000: Oprnd <= A; //Deja pasar A
      3'b001: Oprnd <= A-B; //Resta A con B, tambien sirve para saber si A > B
      3'b010: Oprnd <= B; //Deja pasar B
      3'b011: Oprnd <= A+B; //Adiciona A con B
      3'b100: Oprnd <= {1'b0, ~(A & B)}; //NAND de A y B
      default: Oprnd <= 0;
    endcase
  end
endmodule
//******************************************************************************
module operaciones(input [3:0]DataIn, input [2:0] Select, input clk, reset, enACU,
                    output wire [3:0] DataOut, Accu, output wire Z, C);
  ALU_aritmetica a0(Accu, DataIn, Select, Z, C, DataOut);
  Accu a1(DataOut, enACU, reset, clk, Accu);
endmodule //En este modulo se conecta tanto la ALU como el acumulador. Teniendo
          //como salida de la ALU, la entrada de tanto un bus driver como del
          //acumulador. Como salida del acumulador esta la entrada A de la ALU.
