//Lara Gama Santos e Lucas Santos Rodrigues
//Lab. Arquitetura e Organizacao de Computadores
//Pratia 1 - Parte 3
//Cache (L1) - 2 vias

module pratica1_parte3 (
  address,
  clock,
  data,
  wren,
  dataOUT,
  via1,
  via2,
  hit,
  write_back_en,
  write_back_data,
  mem_address,
  mem_data
);

  input [4:0] address;
  input clock;
  input [2:0] data;
  input wren;

  output [2:0] dataOUT;
  output [8:0] via1;
  output [8:0] via2;
  output [2:0] write_back_data;
  output [4:0] mem_address;
  output write_back_en;
  output [2:0] mem_data;
  output hit;

  wire [1:0] index = address[1:0];  //separa os bits do indice
  wire [2:0] tag = address[4:2];  //separa os bits da tag
  wire [2:0] mem_data_out; // saida da Memoria Principal
  
  reg [2:0] aux_dataOUT;
  reg [8:0] aux_via1;
  reg [8:0] aux_via2;
  reg aux_hit;
  reg leuMemoria;
  
  // auxiliares para a memoria principal
  reg [2:0] aux_write_back_data;
  reg [3:0] aux_mem_address;
  reg aux_write_back_en;
  
  reg [8:0] via[3:0][1:0];  //v lru  dirty  tag  data
									 //0  0     0    000  000

  // Instancia memoria
  memoria Memoria(mem_address, clock, write_back_data, write_back_en, mem_data_out);

  initial begin
    via[0][0] = 9'b000100011; via[0][1] = 9'b110101100; // INDEX 0
	 via[1][0] = 9'b100000011; via[1][1] = 9'b110001111; // INDEX 1
	 via[2][0] = 9'bxxxxxxxxx; via[2][1] = 9'bxxxxxxxxx; // INDEX 2
	 via[3][0] = 9'b110xxx011; via[3][1] = 9'bxxxxxxxxx; // INDEX 3

   aux_write_back_en = 0;
   leuMemoria = 0;
  end

  always @(negedge clock) begin
    aux_write_back_en = 0;
    //----------------------------- HIT VIA 1 --------------------------------------
    if(/*tag*/ via[index][0][5:3] == tag && /*bit v*/ via[index][0][8] == 1 ) begin //VIA 1
      aux_hit = 1;
      via[index][0][7] = 1; //LRU1
      via[index][1][7] = 0; //LRU2

      if(wren == 1)begin  //ESCRITA
        via[index][0][2:0] = data;
        via[index][0][8] = 1; // Valido = 1
        via[index][0][6] = 1; // dirty = 1
      end
      
      aux_dataOUT = via[index][0][2:0];
		aux_via1 = via[index][0];
		aux_via2 = via[index][1];

    end

    //--------------------------- HIT VIA 2 ----------------------------------------
    else if(via[index][1][5:3] == tag && via[index][1][8] == 1 ) begin //VIA 2
      aux_hit = 1;
      via[index][0][7] = 0; //LRU1
      via[index][1][7] = 1; //LRU2

      if(wren == 1)begin  //ESCRITA
        via[index][1][2:0] = data;
        via[index][1][8] = 1; // Valido = 1
        via[index][1][6] = 1; // dirty = 1
      end
      
      aux_dataOUT = via[index][1][2:0];
		aux_via1 = via[index][0];
		aux_via2 = via[index][1];
    end

    //------------------------- MISS ---------------------------------------------
    else begin 

      aux_hit = 0;

      if(via[index][0][7] == 0) begin // >>>>>>>>>>>>>>> LRU1 - via1 mais antiga <<<<<<<<<<<<<<<<<<<<
        aux_mem_address = {via[index][0][4:3], index}; //CONCATENA TAG[1:0] + INDEX

        if(via[index][0][6] == 1 && via[index][0][8] == 1)begin // dirty && valido == 1 -> write-back
          // FAZ WRITE-BACK
          aux_write_back_en = 1;
          aux_write_back_data = via[index][0][2:0]; // data antiga com dirty
          via[index][0][6] = 0; // Desabilita o dirty
          via[index][0][8] = 0; // Desabilita o valido
        end

        else begin
          // BUSCA NA MEMORIA
          if (leuMemoria == 0) begin
            via[index][0][8] = 0; // Desabilita o valido
            via[index][0][5:3] = address[4:2]; // TAG
            aux_write_back_en = 0;
            aux_mem_address = address[3:0]; // Passa o endereco pra memoria
            leuMemoria = 1;
          end

          else begin
            via[index][0][8] = 1; // Valido = 1
            via[index][0][6] = 0; // dirty = 0
            via[index][0][7] = 1; //LRU1
            via[index][1][7] = 0; //LRU2
            
            if(wren == 0) begin
              via[index][0][2:0] = mem_data_out[2:0]; // DATA da memoria
            end
            else begin // ESCRITA
              via[index][0][2:0] = data;
              via[index][0][8] = 1; // Valido = 1
              via[index][0][6] = 1; // dirty = 1
            end

            leuMemoria = 0;
          end

          aux_dataOUT = via[index][0][2:0];
			 aux_via1 = via[index][0];
			 aux_via2 = via[index][1];
        end
      end

      else if(via[index][1][7] == 0) begin //>>>>>>>>>>>>>>>>> LRU2 - via2 mais antiga <<<<<<<<<<<<<<<<<<<<<<<
        aux_mem_address = {via[index][1][4:3], index}; //CONCATENA TAG[1:0] + INDEX

        if(via[index][1][6] == 1 && via[index][1][8] == 1)begin // dirty && valido == 1 -> write-back
          // FAZ WRITE-BACK
          aux_write_back_en = 1;
          aux_write_back_data = via[index][1][2:0]; // data antiga com dirty
          via[index][1][6] = 0;
          via[index][1][8] = 0;
        end

        else begin
          // BUSCA NA MEMORIA
          if (leuMemoria == 0) begin
            via[index][1][8] = 0; // Desabilita o valido
            via[index][1][5:3] = address[4:2]; // TAG
            aux_write_back_en = 0;
            aux_mem_address = address[3:0]; // Passa o endereco pra memoria
            leuMemoria = 1;
          end

          else begin
            via[index][1][8] = 1; // Valido = 1
            via[index][1][6] = 0; // dirty = 0
            via[index][0][7] = 0; //LRU1
            via[index][1][7] = 1; //LRU2

            if(wren == 0) begin 
              via[index][1][2:0] = mem_data_out[2:0]; // DATA da memoria
            end

            else begin // ESCRITA
              via[index][1][2:0] = data;
              via[index][1][8] = 1; // Valido = 1
              via[index][1][6] = 1; // dirty = 1
            end

            leuMemoria = 0;
          end

          aux_dataOUT = via[index][1][2:0];
			 aux_via1 = via[index][0];
			 aux_via2 = via[index][1];
        end
      end
    end
	 if(wren == 1)begin
		aux_dataOUT = 3'b000;
	 end
  end
  
  assign dataOUT = aux_dataOUT;
  assign via1 = aux_via1;
  assign via2 = aux_via2;
  assign hit = aux_hit;
  assign write_back_data = aux_write_back_data;
  assign mem_address = {1'b0, aux_mem_address};
  assign write_back_en = aux_write_back_en;
  assign mem_data = mem_data_out;

endmodule