module control (
	input clk, rst, start, loadfull, done,
	output reg  validin, validout,	// whether rom is allowed to read
	output reg C1_en, S2_en, C3_en, S4_en, C5_en, F6_en, F7_en, ArgMax_en
	// whether to latch values for S2/C3/S4/C5 (pool/conv/pool/conv)
);

localparam IDLE  = 2'b00;
localparam LOAD  = 2'b01;
localparam EXE   = 2'b11;
localparam DONE  = 2'b10;
reg [1:0] current_state, next_state;
reg [10:0] counter_C1, counter_C1_n;
reg [7:0] counter_C3_start, counter_C3_start_n;
reg [6:0] counter_C3, counter_C3_n, counter_C5_start, counter_C5_start_n;
reg [5:0] counter_C5, counter_C5_n, counter_F6, counter_F6_n;
reg C1_en_n, S2_en_n, C3_en_n, S4_en_n, C5_en_n, F6_en_n;
always @(posedge clk) begin
    current_state <= next_state; 
end

always @(current_state, start, loadfull, rst, done) begin
    case (current_state) 
        IDLE: begin
            if (rst & ~start & loadfull & done) next_state = LOAD;
            else next_state = IDLE;
            end
        LOAD: begin
            if (rst & start & ~loadfull & done) next_state = EXE;
            else if (rst & start & loadfull & done) 
                next_state = LOAD;
            else next_state = IDLE;
            end
        EXE: begin
            if (rst & start & ~loadfull & ~done) next_state = DONE;
            else if (rst & start & ~loadfull & done) next_state = EXE;
            else next_state = IDLE;
            end
        DONE: begin
            next_state = IDLE;
            end
        default: next_state = IDLE;
    endcase
end

always @(*) begin
    validin = 1'b1;
    validout = 1'b1;
    C1_en_n = 1'b1;
    C3_en_n = 1'b1;
    C5_en_n = 1'b1;
    F6_en_n = 1'b1;
    //F7_en = 1'b1;
    case (current_state) 
        IDLE: begin
            validin = 1'b1;
            validout = 1'b1;
            C1_en_n = 1'b1;
            C3_en_n = 1'b1;
            C5_en_n = 1'b1;
            F6_en_n = 1'b1;
            counter_C1_n = 0;
            counter_C3_start_n = 0;
            counter_C3_n = 0;
            counter_C5_start_n = 0;
            counter_C5_n = 0;
            counter_F6_n = 0;

            //F7_en = 1'b1;
        end
        LOAD: begin
            validin = 1'b0;
        end
        EXE: begin
            if (counter_C1 <= 11'd1025) begin
                C1_en_n = 1'b0;
                counter_C1_n = counter_C1 + 1;
            end
            else begin 
                C1_en_n = 1'b1;
            end
            if (!S2_en) begin 
                if (counter_C3_start < 8'd130) counter_C3_start_n = counter_C3_start + 1;
                else if (counter_C3 <= 7'd36) begin 
                    counter_C3_n = counter_C3 + 1; 
                    C3_en_n = 1'b1;
                end
                else if (counter_C3 <= 7'd63) begin
                    if (counter_C3 == 7'd63) counter_C3_n = 0;
                    else counter_C3_n = counter_C3 + 1;
                    C3_en_n = ~counter_C3[0];
                end   
                else counter_C3_n = 0;
            end
            else begin 
                C3_en_n = 1'b1;
            end
            if (!S4_en) begin
                if (counter_C5_start < 6'd56) counter_C5_start_n = counter_C5_start + 1;   
                else if (counter_C5 <= 5'd18) begin
                    counter_C5_n = counter_C5 + 1; 
                    C5_en_n = 1'b1;
                end
                else if (counter_C5 <= 5'd27) begin 
                    if (counter_C5 == 5'd27) counter_C5_n = 0;
                    else counter_C5_n = counter_C5 + 1;
                    C5_en_n = ~counter_C5[0];
                end
                else begin 
                    counter_C5_n = 0;
                    counter_C5_start_n = 0;
                end
            end
            else C5_en_n = 1'b1;
            if (!C5_en) begin
                if (counter_F6 <= 5'd24) begin 
                    if (counter_F6 == 5'd24) begin 
                        counter_F6_n = 0;
                        F6_en_n = 1'b0;                        
                        end
                    else begin
                        counter_F6_n = counter_F6 + 1;
                        F6_en_n = 1'b1;
                    end
                end
                else begin 
                    counter_F6_n = 0;
                    //F6_en_n = 1'b1;
                end
                end
            else 
                F6_en_n = 1'b1;      
            end
        
        DONE: begin
            validout = 1'b0;
        end
        default: begin
            validin = 1'b1;
            validout = 1'b1;
            C1_en_n = 1'b1;
            C3_en_n = 1'b1;
            C5_en_n = 1'b1;
            F6_en_n = 1'b1;
            //F7_en = 1'b1;
        end
    endcase
end
always @(posedge clk) begin
    C1_en <= C1_en_n;
    S2_en <= C1_en;
    C3_en <= C3_en_n;
    S4_en <= C3_en;
    C5_en <= C5_en_n;
    F6_en <= F6_en_n;
    F7_en <= F6_en;
    ArgMax_en <= F7_en;
end
always @(posedge clk or negedge rst) begin
    if (~rst) begin 
        counter_C1 <= 0 ;
        counter_C3 <= 0;
        counter_C3_start <= 0;
    end
    else begin
        counter_C1 <= counter_C1_n;
        counter_C3 <= counter_C3_n;
        counter_C3_start <= counter_C3_start_n;
    end
end
always @(posedge clk or negedge rst) begin
    if (~rst) begin
        counter_C5_start <= 0;
        counter_C5 <= 0;
    end
    else if (!S4_en) begin
        counter_C5_start <= counter_C5_start_n;
        counter_C5 <= counter_C5_n;
    end
end
always @(posedge clk or negedge rst) begin
    if (~rst) counter_F6 <= 0;
    else if (!C5_en) counter_F6 <= counter_F6_n;
end
// determine if layer output should be read
//reg[4:0] c1_count = C1_LEN;	// 28, ends at 32 (range: 0 to 31) - skip 4 cycles
//reg[4:0] s2_count = C1_LEN-2;	// counts entire C1 row but takes alternate outputs
//reg s2_dontskip = 1;	// whether to skip reading a row or not

//reg[3:0] c3_count_1 = 0;	// count no. C3 outputs produced thus far (range: 0 to 13 to skip 4 cycles)
//reg[3:0] s4_count = 0;	// count no. C3 outputs encountered thus far (takes alternate outputs)
//reg s4_dontskip = 1;	// whether to skip reading a row or not

//// determine if layer to begin reading input
//reg[7:0] enable_s2_count = 5 + 4*COLS - 1;	// start at 133th clock cycle; count down to 0
//reg s2_begin = 0;

//reg enable_c3_bit = 0, enable_c3_bit2 = 0, enable_c3_bit3 = 0;
//reg c3_begin = 0;

//reg[8:0] enable_s4_count = 431;	// start at 432th clock cycle; count down to 0
//reg s4_begin = 0;

//reg[8:0] enable_c5_count = 499;	// start at 500th clock cycle; count down to 0
//reg c5_begin = 0;
//reg C3_en_1;
//reg first_cycle = 1;
//wire C3_en_row;
//assign read = first_cycle;

//clk_divider #(.DIVISOR(2), .BIT_WIDTH(2)) S2_SIGNAL (
//        .clk_in(clk),
//        .clk_out(C3_en_row)
//    );

//reg [4:0]c3_count = 12;
//reg C3_run;
//assign C3_en = C3_en_row & C3_run;

//always @ (posedge C3_en_row) begin
//    c3_count = c3_count+1;
//    if (c3_count >= 32)
//        c3_count = 0;
//    if (c3_count >= S2_LEN)
//        C3_run = 0;
//    else C3_run = 1  ;      
//end

//always @ (posedge clk) begin
//	// whether to read from rom
//	first_cycle <= 0;

//	// count outputs of layer C1
//	if (c1_count == COLS - 1)
//		c1_count <= 0;	// wrap counter
//	else	c1_count <= c1_count + 1;

//	// check if layer S2 can begin
//	enable_s2_count <= enable_s2_count - 1;
//	s2_begin <= s2_begin | (enable_s2_count == 8'b1);	// calculate condition one cycle before

//	// determine if layer S2 should read inputs of layer C1
//	S2_en = s2_begin & (c1_count < C1_LEN);

//	// count inputs to layer S2
//	if (S2_en) begin
//		if (s2_count == C1_LEN-1) begin
//			s2_count <= 0;
//			s2_dontskip <= ~s2_dontskip;
//		end
//		else	s2_count <= s2_count + 1;
//	end
    
//	// check if layer C3 can begin
//	enable_c3_bit <= enable_c3_bit | S2_en;
//	enable_c3_bit2 <= enable_c3_bit & ~S2_en;	// when it goes low for the first time
//	enable_c3_bit3 <= enable_c3_bit2;	// delay by 1 cycle
//	c3_begin <= c3_begin | (enable_c3_bit3 & S2_en);	// already begun or meets the condition for begin

//	// determine if layer C3 should read inputs of layer S2
//	C3_en_1 = c3_begin & S2_en & (s2_count < C1_LEN-1) & s2_dontskip & ~s2_count[0];

//	// check if layer S4 can begin
//	enable_s4_count <= enable_s4_count - 1;
//	s4_begin <= s4_begin | (enable_s4_count == 8'b1);	// calculate condition one cycle before

//	// count outputs of layer C3
//	if (C3_en_1 & s4_begin) begin	// when C3 should read in value
//		if (c3_count_1 == S2_LEN-1) begin
//			c3_count_1 <= 0;
//		end
//		else	c3_count_1 <= c3_count_1 + 1;
//	end

//	// determine if layer S4 should read inputs of layer C3
//	S4_en = s4_begin & C3_en_1 & (c3_count_1 < C3_LEN);

//	// check if layer C5 can begin
//	enable_c5_count <= enable_c5_count - 1;
//	c5_begin <= c5_begin | (enable_c5_count == 8'b1);	// calculate condition one cycle before

//	// count inputs to layer S4
//	if (S4_en & c5_begin) begin	// when S4 reads in a value
//		if (s4_count == C3_LEN-1) begin
//			s4_count <= 0;
//			s4_dontskip <= ~s4_dontskip;
//		end
//		else	s4_count <= s4_count + 1;
//	end

//	// determine if layer C5 should read inputs of layer S4
//	C5_en = c5_begin & S4_en & s4_dontskip & ~s4_count[0];
//end

endmodule
