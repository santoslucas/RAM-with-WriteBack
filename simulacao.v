module simulacao;

   reg clock;
    
	reg [4:0] address;
	reg [2:0] data;
	reg wren;
   wire [2:0] mem_data;
	wire [2:0] outData;
	wire [8:0] via1;
	wire [8:0] via2;
   wire hit;
   wire write_back_en;
   wire [2:0] write_back_data;
   wire [4:0] mem_address;

    pratica1_parte3 L1 (address, clock, data, wren, outData, via1, via2, hit, write_back_en, write_back_data, mem_address, mem_data);

    initial begin
        clock = 1; 

        //--------------------------- TESTE 1 --------------------------------------
        // 2 ciclos de clock
		  #1
        address = 5'b10000;
        wren = 0;
        clock = ~clock; //0
        #1
        clock = ~clock; //1
        #1
        clock = ~clock; //0
        #1
        clock = ~clock; //1 //250
        #1
  
        $display("1) Read Miss na L1, sobrescreve via[0][0]");
        $display("hit: %b", hit);
        $display("cache[0][0]: %b | cache[0][1]: %b\n", via1, via2);
 
        //--------------------------- TESTE 2 --------------------------------------
        // 2 ciclos de clock

        address = 5'b00001; 
        clock = ~clock; //0
        #1
        clock = ~clock; //1
        #1
        clock = ~clock; //0
        #1
        clock = ~clock; //1 //450
        #1

        $display("2) Read Hit na L1, altera os LRU");
        $display("hit: %b", hit);
        $display("cache[1][0]: %b | cache[1][1]: %b\n", via1, via2);

        //--------------------------- TESTE 3 --------------------------------------
        // 2 ciclos de clock
        
        address = 5'b00001;
        wren = 1;
        data = 3'b101; 
        clock = ~clock; //0
        #1
        clock = ~clock; //1
        #1
        clock = ~clock; //0
        #1
        clock = ~clock; //1 //650
        #1
   
        $display("3) Write Hit na L1 Valor de escrita 101, altera dirty");
        $display("hit: %b", hit);
        $display("cache[1][0]: %b | cache[1][1]: %b\n", via1, via2);

        //--------------------------- TESTE 4 --------------------------------------
        // 2 ciclos de clock

        address = 5'b01001;
        wren = 1;
        data = 3'b100;

        clock = ~clock; //0
        #1
        clock = ~clock; //1
        #1
        clock = ~clock; //0
        #1
        clock = ~clock; //1 // 850
        #1

        $display("4) Write Miss na L1 Valor da escrita 100, altera LRU e dirty");
        $display("hit: %b", hit);
        $display("cache[1][0]: %b | cache[1][1]: %b\n", via1, via2);

        //--------------------------- TESTE 5 --------------------------------------
        // 3 ciclos de clock

        address = 5'b00101;
        wren = 0;
      
        clock = ~clock; //0
        #1
        clock = ~clock; //1
        #1
		  $display("memoria[1]: %b\n", mem_data);
        clock = ~clock; //0
        #1
        clock = ~clock; //1
        #1
        clock = ~clock; //0
        #1
        clock = ~clock; //1 // 1150
        #1
        
        $display("5) Read miss com write back, altera LRU e dirty");
        $display("hit: %b", hit);
        $display("cache[1][0]: %b | cache[1][1]: %b", via1, via2);

        //--------------------------- TESTE 6 --------------------------------------
        // 3 ciclos de clock

        address = 5'b01101;
        wren = 1;
        data = 3'b001;
      
        clock = ~clock; //0
        #1
        clock = ~clock; //1
        #1
		  $display("memoria[9]: %b\n", mem_data);
        clock = ~clock; //0
        #1
        clock = ~clock; //1
        #1
        clock = ~clock; //0
        #1
        clock = ~clock; //1 //1450
        #1
        
        $display("6) Write Miss com Write back valor 001 , altera LRU e dirty");
        $display("hit: %b", hit);
        $display("cache[1][0]: %b | cache[1][1]: %b", via1, via2);
		  
		  //--------------------------- TESTE 7 --------------------------------------
        // 2 ciclos de clock

        address = 5'b00001;
        wren = 0;
        
        clock = ~clock; //0
        #1
        clock = ~clock; //1
        #1
        clock = ~clock; //0
        #1
        clock = ~clock; //1 // 1650
        #1
        
        $display("7) Read Miss 101");
        $display("hit: %b", hit);
        $display("cache[1][0]: %b | cache[1][1]: %b", via1, via2);
		  
		  //--------------------------- TESTE 8 --------------------------------------
        // 3 ciclos de clock

        address = 5'b01001;
        wren = 0;
      
        clock = ~clock; //0
        #1
        clock = ~clock; //1
        #1
        clock = ~clock; //0
        #1
        clock = ~clock; //1
        #1
        clock = ~clock; //0
        #1
        clock = ~clock; //1 //1950
        #1
        
        $display("8) Read Miss com Write back");
        $display("hit: %b", hit);
        $display("cache[1][0]: %b | cache[1][1]: %b", via1, via2);


     end
endmodule
    
