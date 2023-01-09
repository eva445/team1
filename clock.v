module clock(output reg [6:0] seg,seg_m1,seg_m0,seg_s1,seg_s0, output reg [3:0] com,output reg buzzer, input clk,clear ,input pause_time);
 //seg_m1,seg_m0,seg_s1,seg_s0 are for segment display
 //com is for select com from com1 to com4
 //when clear == 1 ,clock return to zero
reg [0:0] check_pause;
reg [3:0] c_min1;  /* The most significant minute digit of the temp clock and alarm.*/ 
reg [3:0] c_min0;  /* The least significant minute digit of the temp clock and alarm.*/ 
reg [3:0] c_sec1;  /* The most significant second digit of the temp clock and alarm.*/ 
reg [3:0] c_sec0;  /* The least significant minute digit of the temp clock and alarm.*/ 
reg [1:0] count_com;
reg [3:0] sel_com; 
div_freq F0(clk,clk_div,scr_clk_div);
//define initial state
initial
 begin
  check_pause= 1'b1;
  count_com = 2'b00;
  sel_com = 4'b0111;
  com = 1'b1110;
  c_min1 = 4'b0000;
  c_min0 = 4'b0000;
  c_sec1 = 4'b0000;
  c_sec0 = 4'b0000;
  seg_s0 = 7'b1000000;
  seg_s1 = 7'b1000000;
  seg_m0 = 7'b1000000;
  seg_m1 = 7'b1000000;
 end
 
// // c_sec0 +1 every second and it will count to 60 and carry to minute
// 
always @( posedge clk_div  )//posedge clk_div 
begin
 if (clear)
	begin
  c_min1 = 4'b0000;
  c_min0 = 4'b0000;
  c_sec1 = 4'b0000;
  c_sec0 = 4'b0000;
  end
 if (pause_time)
  begin
  c_sec0 = c_sec0;
  check_pause = ~check_pause; //initial = 1
  buzzer = ~buzzer;
  
  end
 else
  begin
  check_pause = 1;
   buzzer = 0;
  c_sec0 = c_sec0 + 1'b1;
  if (c_sec0 == 4'b1010)
   begin
   c_sec0 <= 4'b0000;
   c_sec1 = c_sec1 + 1'b1;
   if (c_sec1 == 4'b0110)
    begin 
    c_sec1 <= 4'b0000;  
    c_min0 = c_min0 + 1'b1;
    if (c_min0 == 4'b1010)
     begin 
     c_min0 <= 4'b0000;  
     c_min1 = c_min1 + 1'b1;
     if (c_min1 == 4'b0110)
      begin 
      c_min1 <= 4'b0000;  
      end
     end
    end
   end
  end
 end
/*
Seven-segment display 
the data is converted from c_min, c_sec (binary) to seg_min, seg_sec (used to transmit the signal of the seven-segment display)
"com" is for select from com1 ~com4
*/
always @(posedge scr_clk_div )
 begin
 count_com = count_com + 1'b1;
 if (pause_time)
 begin
 if(check_pause==1)
 begin
   case(count_com)
   2'b00 : com = 4'b1110;
   2'b01 : com = 4'b1101;
   2'b10 : com = 4'b1011;
   2'b11 : com = 4'b0111;
   endcase 
   case(com)
   4'b1110 : seg <= seg_m1;
   4'b1101 : seg <= seg_m0;
   4'b1011 : seg <= seg_s1;
   4'b0111 : seg <= seg_s0;
   endcase
  end
 else
   com = 4'b1111;
 end
 else 
 begin
  case(c_sec0)
  4'b0000: seg_s0 <= 7'b1000000;
  4'b0001: seg_s0 <= 7'b1111001;
  4'b0010: seg_s0 <= 7'b0100100;
  4'b0011: seg_s0 <= 7'b0110000;
  4'b0100: seg_s0 <= 7'b0011001;
  4'b0101: seg_s0 <= 7'b0010010;
  4'b0110: seg_s0 <= 7'b0000010;
  4'b0111: seg_s0 <= 7'b1111000;
  4'b1000: seg_s0 <= 7'b0000000;
  4'b1001: seg_s0 <= 7'b0011000;
  endcase
  case(c_sec1)
  4'b0000: seg_s1 <= 7'b1000000;
  4'b0001: seg_s1 <= 7'b1111001;
  4'b0010: seg_s1 <= 7'b0100100;
  4'b0011: seg_s1 <= 7'b0110000;
  4'b0100: seg_s1 <= 7'b0011001;
  4'b0101: seg_s1 <= 7'b0010010;
  endcase
  case(c_min0)
  4'b0000: seg_m0 <= 7'b1000000;
  4'b0001: seg_m0 <= 7'b1111001;
  4'b0010: seg_m0 <= 7'b0100100;
  4'b0011: seg_m0 <= 7'b0110000;
  4'b0100: seg_m0 <= 7'b0011001;
  4'b0101: seg_m0 <= 7'b0010010;
  4'b0110: seg_m0 <= 7'b0000010;
  4'b0111: seg_m0 <= 7'b1111000;
  4'b1000: seg_m0 <= 7'b0000000;
  4'b1001: seg_m0 <= 7'b0011000;
  endcase
  case(c_min1)
  4'b0000: seg_m1 <= 7'b1000000;
  4'b0001: seg_m1 <= 7'b1111001;
  4'b0010: seg_m1 <= 7'b0100100;
  4'b0011: seg_m1 <= 7'b0110000;
  4'b0100: seg_m1 <= 7'b0011001;
  4'b0101: seg_m1 <= 7'b0010010;
  endcase
  
  case(count_com)
  2'b00 : com = 4'b1110;
  2'b01 : com = 4'b1101;
  2'b10 : com = 4'b1011;
  2'b11 : com = 4'b0111;
  endcase
 
  case(com)
  4'b1110 : seg <= seg_m1;
  4'b1101 : seg <= seg_m0;
  4'b1011 : seg <= seg_s1;
  4'b0111 : seg <= seg_s0;
  endcase 
  end

 end

endmodule


 
 

//create 'one second' and '0.0001 second'

module div_freq(input clk ,output reg clk_div,output reg scr_clk_div);
 reg [24:0] count;
 reg [14:0] scr_count;
 always@(posedge clk)
  begin
   count <= count + 1'b1;
   if (count > 2500)
    begin
     count <= 25'b0;
     scr_count = scr_count +1'b1;
     scr_clk_div = ~scr_clk_div;
     if(scr_count > 10000)
      begin
      clk_div = ~clk_div;
      scr_count =15'b0;
      end
    end
  end
endmodule
