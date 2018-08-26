`timescale 1ns / 1ps

module main(
    input clk,rset,
    input stop,                       
    input [3:0] row,
    output reg [3:0] col,
    output reg RS=0,
    output reg RW=0,
    output reg E=0,
    output reg [7:0] D=255,
    output reg [3:0] led,
    output reg alarm
    );

 /*////////////////////////////////////////////////////
                      INPUTS -
          clk - zybo 125MHz onboard clock
          rset - set button to set the value of the keypad
          stop - Emergency stop the lift
          row  - to get row input for the keypad
                      OUTPUTS -
          col - 4 bit register to send signals to the keypad
          RS  - Register select for the LCD DISPLAY
          RW  - READ/WRITE for the LCD DISPLAY
          E   - Enable line of the LCD DISPLAY
          D   - 8 bit display lines
          led - Register to store the current value of the keypad 
          alarm - if the lift is stopped
 ////////////////////////////////////////////////////*/   

reg [3:0] floor=12;                //floor register maintains the current floor
reg [3:0] nextfloor=0;            //nextfloor register maintains the next floor to be visited
reg [31:0] count_1Hz=0;           //counter to count upto 125000000 for 1Hz clock from the 125MHz board clock
reg clk_1Hz=0;                    //1 Hz clock
reg [15:0] request=0;             //register to maintain remaining request of floors to visit
reg door=0;                       //register to indicate openning or closing of the door of the lift
reg [1:0]ud=0;            //register to maintain the direction in which the lift is travelling(or stationary)
reg flag=0;               //flag register to store the last state of register ud 
reg stopedbefore=0;	//register to store if the lift was stoped before   
   
reg clk_50Hz=0;                   //50Hz derived clock
reg [63:0] count_50Hz=0;          //counter to count upto that 50Hz clock

//Logic for the LCD DISPLAY
//Clock for the LCD DISPLAY
always@(posedge clk)              //Clock changed change to .8ms to refresh the lcd fast
begin
	if(count_50Hz==100000)
        begin
            count_50Hz<=0;
            clk_50Hz<=~clk_50Hz;
        end
        else 
        begin
             count_50Hz<=count_50Hz+1;
        end
end
    
reg [15:0] STATE=3;               //Register to store the value of the state of the LCD
/*//////////////////////////////////////////////////////////////////
			LOGIC TO DISPLAY
	To intialise to display - 
		0x38 is used for 8-bit data initialization.
		0x1H for clearing the LCD.
	Sending Data to the LCD
		E=1; enable pin should be high
		RS=1; Register select should be high for writing the data
		Placing the data on the data registers		ascii value
		R/W=0; Read/Write pin should be low for writing the data.
//////////////////////////////////////////////////////////////////*/        
always@(posedge clk_50Hz)
begin
        if(STATE==0)
        begin
            D<=8'b11110000;
            STATE<=1;
        end
        else if(STATE==1)
        begin
            STATE<=2;
            D<=8'b00000001;                  //clear screen
            RS<=0;
            E<=1;
        end
        else if(STATE==2)
        begin
          STATE<=3;
          E<=0;
        end
        else if(STATE==3)
        begin
            STATE<=4;
            D<=8'b00001100;                 //set screen  8bit communication and 16*2 cursor and blink off
            RS<=0;
            E<=1;
        end
        else if(STATE==4)
        begin
            STATE<=13;
            E<=0;
        end
        else if(STATE==13) 
        begin
          D<=8'b01000110;                   //F
          E<=1;
          RW<=0;
          RS<=1;
          STATE<=14;       
        end
        else if(STATE==14) 
        begin
          D<=8'b01000110;
          E<=0;
          RW<=0;
          RS<=1;
          STATE<=15;       
        end
        else if(STATE==15) 
        begin
          D<=8'b01101100;                   //l
          E<=1;
          RW<=0;
          RS<=1;
          STATE<=16;
        end
        else if(STATE==16) 
        begin
          D<=8'b01101100;
          E<=0;
          RW<=0;
          RS<=1;
          STATE<=17;
        end
        else if(STATE==17) 
        begin
          D<=8'b01101111;                   //o
          E<=1;
          RW<=0;
          RS<=1;
          STATE<=18;
        end
        else if(STATE==18)
        begin
          D<=8'b01101111;
          E<=0;
          RW<=0;
          RS<=1;
          STATE<=19;
        end    
        else if(STATE==19) 
        begin
          D<=8'b01101111;                   //o
          E<=1;
          RW<=0;
          RS<=1;
          STATE<=20;
        end
        else if(STATE==20)
        begin
          D<=8'b01101111;
          E<=0;
          RW<=0;
          RS<=1;
          STATE<=21;
        end 
        else if(STATE==21) 
        begin
          D<=8'b01110010;                   //r
          E<=1;
          RW<=0;
          RS<=1;
          STATE<=22;
        end
        else if(STATE==22)
        begin
          D<=8'b01110010;
          E<=0;
          RW<=0;
          RS<=1;
          STATE<=23;
        end     
        else if(STATE==23) 
        begin
          D<=8'b10100000;                   //space
          E<=1;
          RW<=0;
          RS<=1;
          STATE<=24;
        end
        else if(STATE==24)
        begin
          D<=8'b10100000;
          E<=0;
          RW<=0;
          RS<=1;
          STATE<=30;
        end     
        else if(STATE==30)                          //few STATE intentionally left 
        begin
          D<=48 + (floor - (floor%10))/10 ;                   //floor most significant
          E<=1;
          RW<=0;
          RS<=1;
          STATE<=31;
        end
        else if(STATE==31)
        begin
          E<=0;
          STATE<=32;
        end     
        else if(STATE==32) 
        begin
          D<=48 + (floor%10) ;                             //floor least significant
          E<=1;
          RW<=0;
          RS<=1;
          STATE<=33;
        end
        else if(STATE==33)
        begin
          E<=0;
          STATE<=34;
        end     
        else if(STATE==34) 
        begin
          D<=8'b10100000;                   //space
          E<=1;
          RW<=0;
          RS<=1;
          STATE<=35;
        end
        else if(STATE==35)
        begin
          D<=8'b10100000;
          E<=0;
          RW<=0;
          RS<=1;
          STATE<=36;
        end     
        else if(STATE==36) 
        begin
          D<=8'b01000100;                   //D
          E<=1;
          RW<=0;
          RS<=1;
          STATE<=37;
        end
        else if(STATE==37)
        begin
          D<=8'b01000100;
          E<=0;
          RW<=0;
          RS<=1;
          STATE<=40;
        end     
        else if(STATE==40)                          //few STATE intentionally left
        begin
          if(door==0)                               //door status
            D<=8'b11111111;                   
          else
            D<=8'b11011011;
          E<=1;
          RW<=0;
          RS<=1;
          STATE<=41;
        end
        else if(STATE==41)
        begin
          E<=0;
          STATE<=42;
        end     
        else if(STATE==42)
            STATE<=43;
        else if(STATE==43)
            STATE<=44;
        else if(STATE==44)
            STATE<=1;
        else
          STATE<=41;         
end
    
//Logic for the Keypad
reg [3:0] key_value;                //4 v=bit reg to store the current input
reg [16:0] count_500khz;            //counter to count upto that 500KHz clock
reg [2:0] state;                    //state variable register
reg key_flag;                       // flag variable
reg clk_500khz;                     //derived clock 500KHz
reg [3:0] col_reg;                  //4 bit column reg
reg [3:0] row_reg;                  //4 bit row reg    
  
always @(posedge clk)               //20 ms clock
begin
    if(rset) 
    begin 
        clk_500khz<=0; 
        count_500khz<=0; 
    end
    else
    begin
        if(count_500khz>=250) 
        begin 
            clk_500khz<=~clk_500khz;
            count_500khz<=0;
        end
        else 
            count_500khz<=count_500khz+1;
     end
end 
    
always @(posedge clk_500khz)        //Logic to determine the input form the keypad
begin 
    if(rset) 
    begin 
        col<=4'b0000;
        state<=0;
    end
    else 
    begin 
       case (state)
        0:  begin
              col[3:0]<=4'b0000;
              key_flag<=1'b0;
              if(row[3:0]!=4'b1111) 
              begin 
                state<=1;
                col[3:0]<=4'b1110;
              end 
            else 
                state<=0;
            end 
        1:  begin
               if(row[3:0]!=4'b1111) 
               begin 
                state<=5;
               end   
               else  
               begin 
                    state<=2;
                    col[3:0]<=4'b1101;
               end  
            end 
        2:  begin    
              if(row[3:0]!=4'b1111) 
              begin 
                state<=5;
              end    
              else  
              begin 
                state<=3;
                col[3:0]<=4'b1011;
              end  
             end
      3:     begin    
              if(row[3:0]!=4'b1111) 
              begin 
                state<=5;
              end   
              else  
              begin 
                state<=4;
                col[3:0]<=4'b0111;
              end  
             end
      4:     begin    
               if(row[3:0]!=4'b1111) 
               begin 
                    state<=5;
               end  
               else  
                    state<=0;
             end
      5:     begin  
               if(row[3:0]!=4'b1111) 
               begin
                     col_reg<=col;  
                     row_reg<=row;  
                     state<=5;
                     key_flag<=1'b1; 
               end             
               else
               begin 
                    state<=0;
               end
             end    
    endcase 
  end           
end
  

 always @(clk_500khz or col_reg or row_reg)       //Decoding the input from the current input

     begin

        if(key_flag==1'b1) 

                begin

                     case ({col_reg,row_reg})

                      8'b1110_1110:key_value<=0;

                      8'b1110_1101:key_value<=1;

                      8'b1110_1011:key_value<=2;

                      8'b1110_0111:key_value<=3;

                      

                      8'b1101_1110:key_value<=4;

                      8'b1101_1101:key_value<=5;

                      8'b1101_1011:key_value<=6;

                      8'b1101_0111:key_value<=7;

 

                      8'b1011_1110:key_value<=8;

                      8'b1011_1101:key_value<=9;

                      8'b1011_1011:key_value<=10;

                      8'b1011_0111:key_value<=11;

 

                      8'b0111_1110:key_value<=12;

                      8'b0111_1101:key_value<=13;

                      8'b0111_1011:key_value<=14;

                      8'b0111_0111:key_value<=15;     

                     endcase 

              end   

   end       


//To assign the current key value to the register led at the posivite edge   
always@(posedge rset)
begin
   led<=key_value;
end

//Elevator logic 
always@(posedge(clk))
begin
	if(count_1Hz==125000000)                    //1Hz clock
        begin
            count_1Hz<=0;
            clk_1Hz<=~clk_1Hz;
        end
        else
            count_1Hz<=count_1Hz+1;
end

//To determine the next floor based upon input , ud , flag , pending request.    
/*///////////////////////////////////////////////////////////////////////////////////
			LOGIC DETERMINE THE NEXT FLOOR
	->	The lift Continues traveling in the same
		direction while there are remaining
		requests in that same direction.
 	->	If there are no further requests in that
		direction, then stop and become idle,
		or change direction if there are
		requests in the opposite direction.
///////////////////////////////////////////////////////////////////////////////////*/        
always@(posedge clk)
begin
        if(request[led]==0 && rset==1)			//if we recive a new request
            request[led]<=1;
        if(door==1)					//if door is opened it implies that the current floor is visited
            request[floor]<=0;
        if(ud==0 && led<nextfloor  && floor<led)	//if lift is going up and the entered floor is b/w nextfloor and current floor 	
            nextfloor<=led;
        else if(ud==1 && led>nextfloor && floor>led)	//if lift is coming down and the entered floor is b/w nextfloor and current floor 
            nextfloor<=led;
        if(ud==2'b11 && flag==1) 			//if the lift is now stationary and was travelling downwards 
        begin 
              if(request[0]==1 && floor==0)
                nextfloor<=0;
              else if(request[1]==1 && floor>1)
                nextfloor<=1;   
              else if(request[2]==1 && floor>2)
                nextfloor<=2; 
              else if(request[3]==1 && floor>3)
                nextfloor<=3;
              else if(request[4]==1 && floor>4)
                nextfloor<=4; 
              else if(request[5]==1 && floor>5)
                nextfloor<=5; 
              else if(request[6]==1 && floor>6)
                nextfloor<=6; 
              else if(request[7]==1 && floor>7)
                nextfloor<=7; 
              else if(request[8]==1 && floor>8)
                nextfloor<=8; 
              else if(request[9]==1 && floor>9)
                nextfloor<=9; 
              else if(request[10]==1 && floor>10)
                nextfloor<=10;
              else if(request[11]==1 && floor>11)
                nextfloor<=11; 
              else if(request[12]==1 && floor>12)
                nextfloor<=12; 
              else if(request[13]==1 && floor>13)
                nextfloor<=13; 
              else if(request[14]==1 && floor>14)
                nextfloor<=14; 
              else if(request[15]==1 && floor>15)
                nextfloor<=15; 
              else if(request[0]==1 && floor==0)
                nextfloor<=0;
              else if(request[1]==1 && floor<1)
                nextfloor<=1;   
              else if(request[2]==1 && floor<2)
                nextfloor<=2; 
              else if(request[3]==1 && floor<3)
                nextfloor<=3;
              else if(request[4]==1 && floor<4)
                nextfloor<=4; 
              else if(request[5]==1 && floor<5)
                nextfloor<=5; 
              else if(request[6]==1 && floor<6)
                nextfloor<=6; 
              else if(request[7]==1 && floor<7)
                nextfloor<=7; 
              else if(request[8]==1 && floor<8)
                nextfloor<=8; 
              else if(request[9]==1 && floor<9)
                nextfloor<=9; 
              else if(request[10]==1 && floor<10)
                nextfloor<=10;
              else if(request[11]==1 && floor<11)
                nextfloor<=11; 
              else if(request[12]==1 && floor<12)
                nextfloor<=12; 
              else if(request[13]==1 && floor<13)
                nextfloor<=13; 
              else if(request[14]==1 && floor<14)
                nextfloor<=14; 
              else if(request[15]==1 && floor<15)
                nextfloor<=15; 
        end
        else if(ud==2'b11 && flag==0) 			//if the lift is now stationary and was travelling upwards
        begin 
              if(request[0]==1 && floor==0)
               nextfloor<=0;
              else if(request[1]==1 && floor<1)
               nextfloor<=1;   
              else if(request[2]==1 && floor<2)
               nextfloor<=2; 
              else if(request[3]==1 && floor<3)
               nextfloor<=3;
              else if(request[4]==1 && floor<4)
               nextfloor<=4; 
              else if(request[5]==1 && floor<5)
               nextfloor<=5; 
              else if(request[6]==1 && floor<6)
               nextfloor<=6; 
              else if(request[7]==1 && floor<7)
               nextfloor<=7; 
              else if(request[8]==1 && floor<8)
               nextfloor<=8; 
              else if(request[9]==1 && floor<9)
               nextfloor<=9; 
              else if(request[10]==1 && floor<10)
               nextfloor<=10;
              else if(request[11]==1 && floor<11)
               nextfloor<=11; 
              else if(request[12]==1 && floor<12)
               nextfloor<=12; 
              else if(request[13]==1 && floor<13)
               nextfloor<=13; 
              else if(request[14]==1 && floor<14)
               nextfloor<=14; 
              else if(request[15]==1 && floor<15)
               nextfloor<=15; 
              else if(request[0]==1 && floor==0)
               nextfloor<=0;
              else if(request[1]==1 && floor>1)
               nextfloor<=1;   
              else if(request[2]==1 && floor>2)
               nextfloor<=2; 
              else if(request[3]==1 && floor>3)
               nextfloor<=3;
              else if(request[4]==1 && floor>4)
               nextfloor<=4; 
              else if(request[5]==1 && floor>5)
               nextfloor<=5; 
              else if(request[6]==1 && floor>6)
               nextfloor<=6; 
              else if(request[7]==1 && floor>7)
               nextfloor<=7; 
              else if(request[8]==1 && floor>8)
               nextfloor<=8; 
              else if(request[9]==1 && floor>9)
               nextfloor<=9; 
              else if(request[10]==1 && floor>10)
               nextfloor<=10;
              else if(request[11]==1 && floor>11)
               nextfloor<=11; 
              else if(request[12]==1 && floor>12)
               nextfloor<=12; 
              else if(request[13]==1 && floor>13)
               nextfloor<=13; 
              else if(request[14]==1 && floor>14)
               nextfloor<=14; 
              else if(request[15]==1 && floor>15)
               nextfloor<=15; 
        end
end

//Lift movement logic   
always@(posedge (clk_1Hz))
begin
        if(nextfloor==floor)
        begin
            door<=1;				//door opened
            ud<=2'b11;				//ud = 11 means lift stationary
        end
        else
        begin
            door<=0;				//door closed
        end
        if(nextfloor>floor && ud!=10)
        begin
            ud<=0;				//ud = 0 means lift travelling upwards
            flag<=0;
            floor<=floor+1;			//incrementing floor
        end
        else if(nextfloor<floor && ud!=10)
        begin
            ud<=1;				//ud = 1 means lift travelling downwards
            flag<=1;
            floor<=floor-1;			//decrementing floor
        end
        if(stop==1)				//Stop the elevator
        begin
        	ud<=10;				//undetermined state
        	stopedbefore<=1;
        	alarm<=1;			//alarm on
        end
        if(stopbefore==1 && stop==0)
        begin
        	ud<=11;				//Stationory
        	stopbefore<=0;
        	alarm<=0;			//alarm off
        end
        
end
endmodule
