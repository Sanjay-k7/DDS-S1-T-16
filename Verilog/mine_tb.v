module game_of_mines_tb;
    reg clk;
    reg reset;
    reg [3:0] bomb_count;  
    wire [15:0] bomb_grid; 

   
    multi_bomb_placement uut (
        .clk(clk),
        .reset(reset),
        .bomb_count(bomb_count),
        .bomb_grid(bomb_grid)  
    );

   
    always #5 clk = ~clk; 

    initial begin
       
        clk = 0;
        reset = 1;
        bomb_count = 4; 
 
        #10 reset = 0;
        #10;
        display_bomb_status(bomb_grid);
            
        #100 $finish;
    end

   
    task display_bomb_status(input [15:0] grid);
        integer i;
        for (i = 0; i < 16; i = i + 1) begin
            if (grid[i] == 1'b1) begin
                $display("Bomb detected at (%0d, %0d)", i / 4, i % 4);
            end else begin
                $display("Safe cell is present at (%0d, %0d)", i / 4, i % 4);
            end
        end
    endtask
endmodule