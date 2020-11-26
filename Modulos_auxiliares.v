//Modulos_auxiliares
//Daniel Mundo 19508
//Este arhivo contiene todos los modulos que se utilizan en más de un archivo
//además contiene tambien la memoria RAM.
//*******************************************************************************
module RAM(input [11:0] direccion, input cs, input we, inout[3:0] data );
    reg [3:0] valor;
    reg [3:0] ram[4095:0];
    assign data = (cs & ~we) ? valor : 4'bzzzz;
    always @(direccion, cs, we, data) begin
        if(cs & ~we) valor = ram[direccion];
        else if(cs & we) ram[direccion] = data;
    end
endmodule // Si la "cs" es 1 y "we" entonces se le asigna el valor de dataOut
          //en caso contrario la salida se mantedra en alta impedancia y se pro-
          //cedera a escribir en la localidad descrita por direccion.
//******************************************************************************
module Buffer4bits(input Eneable, input [3:0]I, output wire [3:0]Y);
  assign Y =  Eneable ? I: 4'bz ;
endmodule //El modulo realiza la operecion que mientras "Eneable" sea 0 la sali-
        //da "Y" va a estar en alta impedancia, en caso contrario sera el valor
        //que tenga en ese instante la entrada "I".
//******************************************************************************
module FlipFlopD_4b(input wire eneable2, reset2, clk2, input wire [3:0]D2, output reg [3:0]Q2);
  always @ (posedge clk2, posedge reset2) begin
    if (reset2) Q2 <= 4'b0;
    else if (eneable2) Q2 <= D2;
  end
endmodule //El modulo describe que durante el flanco positivo de "clk" va reali-
        //zar la operacion de comprobar si "reset" esta encendido o no, en caso
       //afirmativo la salida "Q" es igual a 0 sino es igual al valor en ese
      //instante de la entrada "D".
//******************************************************************************
module FlipFlopD(input wire eneable1, reset1, clk1, D1, output reg Q1);
  always @ (posedge clk1, posedge reset1) begin
    if (reset1) Q1 = 1'b0;
    else if (eneable1) Q1 = D1;
  end
endmodule //El funcionamiento de este modulo es similar al modulo "FlipFlopD_4b",
        //de este mismo archivo, a diferencia esta en que este es un FF de un so-
        //lo bit.
