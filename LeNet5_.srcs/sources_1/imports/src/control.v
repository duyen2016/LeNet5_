module control (
	input clk, rst, start, loadfull,
	output reg  done, validin, validout,	// whether rom is allowed to read
	output reg ArgMax_en,
	output reg [2:0] C1_en, 
	output reg [1:0] S2_en,
    output reg [3:0] C3_en,
    output reg [3:0] S4_en, 
    output reg [7:0] C5_en,
    output reg [5:0] F6_en,
    output reg [5:0] Fout_en
);
`include "parameter.vh"
localparam IDLE  = 2'b00;
localparam LOAD  = 2'b01;
localparam EXE   = 2'b11;
localparam DONE  = 2'b10;
reg [1:0] current_state, next_state, counter_S2_LOAD, counter_S2_LOAD_n, counter_S4_LOAD, counter_S4_LOAD_n;
reg [2:0] counter_C1_LOAD, counter_C1_LOAD_n, counter_C3_LOAD, counter_C3_LOAD_n, counter_S4_STORE, counter_S4_STORE_n;
reg [3:0] counter_S2_STORE, counter_S2_STORE_n, counter_S4, counter_S4_n, counter_C3_STORE, counter_C3_STORE_n, counter_C5_LOAD, counter_C5_LOAD_n;
reg [4:0] counter_S2, counter_S2_n, counter_C1_STORE, counter_C1_STORE_n, counter_C5, counter_C5_n;
reg [7:0] counter_C1, counter_C1_n;
reg [6:0] counter_C3, counter_C3_n;
reg [5:0] counter_F6, counter_F6_n;
reg [2:0] C1_en_n; 
reg [1:0] S2_en_n;
reg [3:0] C3_en_n;
reg [3:0] S4_en_n; 
reg [7:0] C5_en_n;
reg [5:0] F6_en_n;
reg [5:0] Fout_en_n;
always @(posedge clk) begin
    current_state <= next_state; 
end

always @(current_state, start, loadfull, rst, done) begin
    case (current_state) 
        IDLE: begin
            if (~rst & start & ~loadfull & ~done) next_state = LOAD; // start == 1 --> LOAD
            else next_state = IDLE;
            end
        LOAD: begin
            if (~rst & ~start & loadfull & ~done) next_state = EXE; // after load full pixel ---> EXE
            else if (~rst & ~start & ~loadfull & ~done) 
                next_state = LOAD;
            else next_state = IDLE;
            end
        EXE: begin
            if (~rst & ~start & loadfull & done) next_state = DONE; //get done signal ---> DONE
            else if (~rst & ~start & loadfull & ~done) next_state = EXE;//continue exe
            else next_state = IDLE;
            end
        DONE: begin
            next_state = IDLE;
            end
        default: next_state = IDLE;
    endcase
end

always @(*) begin
    validin = 1'b0;
    validout = 1'b0;
    C1_en_n = 1'b0;
    S2_en_n = 1'b0;
    C3_en_n = 1'b0;
    S4_en_n = 1'b0;
    C5_en_n = 1'b0;
    F6_en_n = 1'b0;
    Fout_en_n = 1'b0;
    //F7_en = 1'b1;
    case (current_state) 
        IDLE: begin
            validin = 1'b0;
            validout = 1'b0;
            C1_en_n = 1'b0;
            S2_en_n = 1'b0;
            C3_en_n = 1'b0;
            S4_en_n = 1'b0;
            C5_en_n = 1'b0;
            F6_en_n = 1'b0;
            Fout_en_n = 1'b0;
            counter_C1_n = 0;
            counter_C1_LOAD_n = 0;
            counter_C1_STORE_n = 0;
            counter_S2_n = 0;
            counter_S2_LOAD_n = 0;
            counter_S2_STORE_n = 0;
            counter_C3_n = 0;
            counter_C3_LOAD_n = 0;
            counter_C3_STORE_n = 0;
            counter_S4_n = 0;
            counter_S4_LOAD_n = 0;
            counter_S4_STORE_n = 0;
            counter_C5_n = 0;
            counter_C5_LOAD_n = 0;
            counter_F6_n = 0;

            //F7_en = 1'b1;
        end
        LOAD: begin
            validin = 1'b1;
        end
        EXE: begin
            if (counter_C1 >= 130) begin // load 32*4 + 2 pixel first (adding 2 cause delay in imagereader)
                if (counter_C1_LOAD >= 5) begin
                    if ((counter_C1_STORE < 28) && ((S2_en == S2_STORE) || (C1_en >= C1_LOAD))) begin 
//                        if (counter_C1_STORE == 0) C1_en_n = C1_LOAD;
                        if (C1_en == C1_STORE) C1_en_n = C1_LOAD; 
                        else if ((C1_en == C1_CAL) && (((C3_en <= C3_CAL_5th) && (C3_en >= C3_CAL_1st)) || ((C5_en <= C5_CAL_160th) && (C5_en >= C5_CAL_1st)) || ((F6_en >= F6_CAL_1st) && (F6_en <= F6_CAL_42nd)) || ((Fout_en >= FOUT_CAL_1st) && (Fout_en <= FOUT_CAL_4th)))) C1_en_n = C1_en; //other layer use multiple so u wait
                        else C1_en_n = C1_en + 1 ;
                        if (C1_en_n == C1_STORE) counter_C1_STORE_n = counter_C1_STORE + 1;  
                    end
                    else begin
                        C1_en_n = 0;
                    end
                end    
                else if (counter_C1_LOAD < 5) begin
                    C1_en_n = C1_LOAD;
                    counter_C1_LOAD_n = counter_C1_LOAD + 1;
                end
                else C1_en_n = 0;
            end
            else begin 
                C1_en_n = C1_LOAD;
                counter_C1_n = counter_C1 + 1;
            end
            ////////////////////////////////////////
            if (counter_S2 >= 28) begin //load 28 value first
                if ((counter_S2_LOAD >= 2) && (S2_en < S2_STORE) && (S2_en >= S2_LOAD)) begin
                    S2_en_n = S2_en + 1;
                    if (S2_en_n == S2_STORE) counter_S2_STORE_n = counter_S2_STORE + 1;
                    end
                else if (counter_S2_LOAD <= 2) begin//load 2 value then maxpooling
                    if (C1_en == C1_STORE) begin //after c1 store, s2 load
                        S2_en_n = S2_LOAD;
                        if (counter_C1_STORE >= 28) begin //after finish 1 row
                            counter_C1_LOAD_n = 0;  
                            counter_C1_STORE_n = 0;
                        end
                        counter_S2_LOAD_n = counter_S2_LOAD + 1;
                    end
                end
                else S2_en_n = 0;
            end 
            else begin
                if (C1_en == C1_STORE) begin
                    S2_en_n = S2_LOAD;
                    if (counter_C1_STORE >= 28) begin 
                        counter_C1_LOAD_n = 0;
                        counter_C1_STORE_n = 0;
                    end
                    counter_S2_n = counter_S2 + 1; 
                end
            end
            ///////////////////////////////////////
            if (counter_C3_n >= 56) begin //load 4*14 value first
                if (counter_C3_LOAD >= 5) begin //load 5
                    if (counter_C3_STORE < 10) begin //cal & store 10 value
                        if (((C3_en == C3_STORE_5th) || (C3_en == 0)) && (S2_en >= S2_STORE)) begin //s2 store then c3 load 
                            C3_en_n = C3_LOAD;
                            counter_S2_LOAD_n = 0;
                            if (counter_S2_STORE >= 14) begin 
                                counter_S2_n = 0;
                                counter_S2_STORE_n = 0;
                            end
                        end
                        else if ((C3_en < C3_STORE_5th) && (C3_en >= C3_LOAD)) begin
                            if (((C3_en >= C3_CAL_1st) && (C3_en <= C3_CAL_5th)) && (((C5_en >= C5_CAL_1st) && (C5_en <= C5_CAL_160th)) || ((F6_en >= F6_CAL_1st) && (F6_en <= F6_CAL_42nd)) || ((Fout_en >= FOUT_CAL_1st) && (Fout_en <= FOUT_CAL_4th)))) C3_en_n = C3_en; //if others are using multiple ---> wait
                            else C3_en_n = C3_en + 1 ;
                            end
                        else C3_en_n = 0;
                        if (C3_en_n == C3_STORE_5th) counter_C3_STORE_n = counter_C3_STORE + 1; 
                    end
                    else begin
                        C3_en_n = 0;
                    end
                end
                else if (counter_C3_LOAD < 5) begin 
                    if (S2_en == S2_STORE) begin
                        C3_en_n = C3_LOAD;
                        counter_S2_LOAD_n = 0;
                        if (counter_S2_STORE >= 14) begin 
                            counter_S2_n = 0;
                            counter_S2_STORE_n = 0;
                        end
                        counter_C3_LOAD_n = counter_C3_LOAD + 1;
                    end
                    else C3_en_n = 0;
                    end
                else C3_en_n = 0;
            end
            else begin
                if (S2_en == S2_STORE) begin
                    C3_en_n = C3_LOAD;
                    counter_S2_LOAD_n = 0;
                    counter_C3_n = counter_C3 + 1;
                    if (counter_S2_STORE >= 14) begin 
                        counter_S2_n = 0;
                        counter_S2_STORE_n = 0;
                    end
                end
            end
            ///////////////////////////////////////////////////////
            if (counter_S4 >= 10) begin //load 10 value first
                if ((counter_S4_LOAD >= 2) && (S4_en < S4_STORE_5th) && (S4_en >= S4_LOAD_1st)) begin //load 2 value then cal
                    S4_en_n = S4_en + 1;
                    if (S4_en_n == S4_STORE_5th) counter_S4_STORE_n = counter_S4_STORE + 1;//
                    end
                else if (counter_S4_LOAD < 2) begin
                    if (C3_en == C3_STORE_5th) begin                  //if c3 store --> s4 load      
                        S4_en_n = S4_LOAD_1st;
                        counter_S4_LOAD_n = counter_S4_LOAD + 1;
                    end
                    else if ((S4_en >= S4_LOAD_1st) && (S4_en < S4_LOAD_5th)) begin
                        S4_en_n = S4_en + 1;
                    end
                    if (counter_C3_STORE >= 10) begin //reset counter c3
                        counter_C3_LOAD_n = 0;
                        counter_C3_STORE_n = 0;
                    end
                end
                else S4_en_n = 0;
            end 
            else begin
                if (C3_en == C3_STORE_5th) begin
                    S4_en_n = S4_LOAD_1st;
                    counter_S4_n = counter_S4 + 1;
                end
                else if ((S4_en >= S4_LOAD_1st) && (S4_en < S4_LOAD_5th)) begin
                    S4_en_n = S4_en + 1;
                end
                if (counter_C3_STORE >= 10) begin
                    counter_C3_LOAD_n = 0;
                    counter_C3_STORE_n = 0;
                end
            end
            ///////////////////////////////////////////////////////////////////////////
            if (counter_C5 >= 20) begin //load 20 value first
                if (counter_C5_LOAD >= 5) begin //load 5 next value
                    if (S4_en == S4_STORE_1st) begin // S4 store then c5 load
                        C5_en_n = C5_LOAD_1st;
                        
                        if (counter_S4_STORE >= 5) begin //reset counter S4
                            counter_S4_n = 0;
                            counter_S4_STORE_n = 0;
                        end
                    end
                    if (C5_en == C5_LOAD_5th) counter_S4_LOAD_n = 0; //reset counter load s4
                    if (C5_en < C5_STORE_160th) C5_en_n = C5_en + 1 ;
                    else C5_en_n = 0;
                end
                else if (counter_C5_LOAD < 5) begin 
                    if (S4_en == S4_STORE_1st) begin
                        C5_en_n = C5_LOAD_1st;
                        
                        if (counter_S4_STORE >= 5) begin 
                            counter_S4_n = 0;
                            counter_S4_STORE_n = 0;
                        end
                        counter_C5_LOAD_n = counter_C5_LOAD + 1;
                    end
                    else if ((C5_en >= C5_LOAD_1st) && (C5_en < C5_LOAD_5th)) C5_en_n = C5_en + 1;
                    else if (C5_en == C5_LOAD_5th) counter_S4_LOAD_n = 0;
                    else C5_en_n = 0;
                    end
                else C5_en_n = 0;
            end
            else begin
                if (S4_en == S4_STORE_1st) begin
                    C5_en_n = C5_LOAD_1st;
                    counter_C5_n = counter_C5 + 1;
                end
                else if (C5_en == C5_LOAD_5th) counter_S4_LOAD_n = 0;
                else if ((C5_en >= C5_LOAD_1st) && (C5_en < C5_LOAD_5th)) begin
                    C5_en_n = C5_en + 1;
                end
                if (counter_S4_STORE >= 14) begin 
                    counter_S4_n = 0;
                    counter_S4_STORE_n = 0;
                end
            end
            /////////////////////////////////////////////////////////
            if (((C5_en[3:0] - 7) == 0) && (C5_en >= C5_STORE_16th)) begin //c5 store then f6 load
                F6_en_n = F6_en + 1;
            end
            else if (F6_en < F6_LOAD_10th) F6_en_n = F6_en; 
            else if ((F6_en < F6_STORE_42nd) && (F6_en >= F6_LOAD_10th)) F6_en_n = F6_en + 1; // 
            else F6_en_n = 0;
            ////////////////////////////////////////////////////////////////////
            if ((F6_en == F6_STORE_1st) || ((Fout_en >= FOUT_LOAD_1st) && (Fout_en < FOUT_STORE_4th))) begin
                Fout_en_n = Fout_en + 1;           
            end
            else Fout_en_n = 0;
            ///////////////////////////////////////////////////////////////////
        end
        
        DONE: begin
            validout = 1'b1;
        end
        default: begin
            validin = 1'b0;
            validout = 1'b0;
            C1_en_n = 1'b0;
            S2_en_n = 1'b0;
            C3_en_n = 1'b0;
            S2_en_n = 1'b0;
            C5_en_n = 1'b0;
            F6_en_n = 1'b0;
            Fout_en_n = 1'b0;
            //F7_en = 1'b0;
        end
    endcase
end
always @(posedge clk) begin
    C1_en <= C1_en_n;
    S2_en <= S2_en_n;
    C3_en <= C3_en_n;
    S4_en <= S4_en_n;
    C5_en <= C5_en_n;
    F6_en <= F6_en_n;
    Fout_en <= Fout_en_n;
    done <= (Fout_en == FOUT_STORE_4th);
end
always @(posedge clk or posedge rst) begin
    if (rst) begin 
        counter_C1 <= 0 ;
        counter_C1_LOAD <= 0;
        counter_C1_STORE <= 0;
        counter_S2 <= 0;
        counter_S2_LOAD <= 0;
        counter_S2_STORE <= 0;
        counter_C3 <= 0;
        counter_C3_LOAD <= 0;
        counter_C3_STORE <= 0;
        counter_S4 <= 0;
        counter_S4_LOAD <= 0;
        counter_S4_STORE <= 0;
        counter_C5 <= 0;
        counter_C5_LOAD <= 0;
    end
    else begin
        counter_C1 <= counter_C1_n;
        counter_C1_LOAD <= counter_C1_LOAD_n;
        counter_C1_STORE <= counter_C1_STORE_n;
        counter_S2 <= counter_S2_n;
        counter_S2_LOAD <= counter_S2_LOAD_n;
        counter_S2_STORE <= counter_S2_STORE_n;
        counter_C3 <= counter_C3_n;
        counter_C3_LOAD <= counter_C3_LOAD_n;
        counter_C3_STORE <= counter_C3_STORE_n;
        counter_S4 <= counter_S4_n;
        counter_S4_LOAD <= counter_S4_LOAD_n;
        counter_S4_STORE <= counter_S4_STORE_n;
        counter_C5 <= counter_C5_n;
        counter_C5_LOAD <= counter_C5_LOAD_n;
    end
end

endmodule
