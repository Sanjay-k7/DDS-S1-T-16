module d_ff (
    input clk,         
    input d,            
    input reset,       
    output reg q        
);
    always @(posedge clk or posedge reset) begin
        if (reset)
            q <= 0;    
        else
            q <= d;     
    end
endmodule

//Linear feedback shift register
    module rng (
        input clk,
        input reset,
        output reg [3:0] random_num
    );
        always @(posedge clk ) begin
            if (reset)
                random_num <= 4'b1001;  
            else
                random_num[0] <= random_num[3] ^ random_num[2];
                random_num[1] <= random_num[0]; 
                random_num[2] <= random_num[1];
                random_num[3] <= random_num[2];
            
        end
    endmodule

module multi_bomb_placement (
    input wire clk,
    input wire reset,
    input wire [3:0] bomb_count,  
    output reg [15:0] bomb_grid   
);
    reg [3:0] placed_bombs [0:15]; 
    reg [3:0] idx;                 
    integer i, j;

    reg [3:0] rand_idx;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            bomb_grid <= 16'b0;
            rand_idx <= 0;
            
            
            for (i = 0; i < 16; i = i + 1) begin
                placed_bombs[i] = 4'b1111; 
            end
            
            for (j = 0; j < bomb_count; j = j + 1) begin
                rand_idx = (rand_idx + j + 2) % 16;
                
              
                while (placed_bombs[rand_idx] != 4'b1111) begin
                    rand_idx = (rand_idx + 1) % 16; 
                end

                placed_bombs[rand_idx] = rand_idx; 
                bomb_grid[rand_idx] <= 1'b1; 
            end
        end
    end
endmodule



module decoder_4x16 (
    input [3:0] select,         
    output reg [15:0] out      
);
    always @(*) begin
        out = 16'b0;
        out[select] = 1;       
    end
endmodule

module grid (
    input clk,
    input reset,
    input [15:0] bomb_grid,      
    output [15:0] bomb_status    
);
    genvar i;
    generate
        for (i = 0; i < 16; i = i + 1) begin : grid
            d_ff dff (
                .clk(clk),
                .d(bomb_grid[i]),   
                .reset(reset),
                .q(bomb_status[i])  
            );
        end
    endgenerate
endmodule

//Takes input from the user
module user_input_decoder (
    input [3:0] user_input,    
    output reg [15:0] select  
);
    always @(*) begin
        select = 16'b0;            
        select[user_input] = 1;  
    end
endmodule

//Module which shows Game-over
module bomb_detector (
    input [15:0] bomb_status,    
    input [15:0] chosen_cell, 
    output reg game_over         
);
    always @(*) begin
        game_over = 0;

        
        if (bomb_status & chosen_cell) begin
            game_over = 1;  
        end
    end
endmodule

//Counter to show number of cells opened
module safe_counter (
    input clk,
    input reset,
    input safe_revealed,       
    output reg [3:0] count,     
    output win                  
);
    always @(posedge clk or posedge reset) begin
        if (reset)
            count <= 0;
        else if (safe_revealed)
            count <= count + 1;
    end

    assign win = (count == 12); 
endmodule


