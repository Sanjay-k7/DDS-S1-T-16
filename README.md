# GAME OF MINES

<!-- First Section -->
## Team Details
<details> 
  <summary>Detail</summary>

  > Semester: 3rd Sem B. Tech. CSE

  > Section: S1
>   Team ID: S1_T-16

  > Member-1: G.Aravind, 231CS124, gurugubelliaravind.231cs124@nitk.edu.in

  > Member-2: K Sanjay Abhiroop, 231CS128, karumanchisanjay.231cs128@nitk.edu.in

  > Member-3:	Pranav Gujjar, 231CS143, pranavgujjar.231cs143@nitk.edu.in

</details>

<!-- Second Section -->
## Abstract
<details>
  
  <summary>Detail</summary>
  
  > 


## Motivation:

Our primary motivation for developing Game of Mines was to create a game which is fun and educational. During our search for such games, we looked at the classic games that entertained us in the past, and Minesweeper from Windows 7 got here to thoughts as an iconic recreation of logic, chance, and danger. We wanted to capture the same excitement and simplicity of Minesweeper even as exploring methods to decorate it with current hardware elements. So, we wanted to renovate the game into a hardware game.


## PROBLEM STATEMENT:

The Game of Mines is a modern take on the classic Minesweeper concept, a grid-based game that challenges players to find hidden gems while avoiding dangerous mines. The fun and simplicity of the game drives the game, it relies on chance, creating a happy balance of risk and reward. As digital gaming has evolved, many games like Minesweeper have remained popular due to their straightforward design and ability to engage players of all ages.

## FEATURES:

• Use a random number generator circuit i.e,Linear Feedback Shift Register (LFSR) to select random spots in which bombs will be placed.

• Then we will use D flip-flops to represent each of the spots.

• Then we will implement a multiplexer system to allow player to select spots and the output will decide whether the chosen spot is safe or not.

• Then a counter will be used to determine whether the user has given input to all the spots other than the ones with bombs.

• Demo evaluation: The objective is to design a circuit that randomly selects one of the spots as bomb and implement a system that allows the user to enter their choices of spots and check if the bomb is in that 
                   spot. The user loses if he selects a spot with the bomb or else the user will win if he chooses all the spots without the bomb.

</details>



## Functional Block Diagram
<details>
  
![Untitled design](https://github.com/user-attachments/assets/85f1f9ee-6fd4-40bd-ba26-bb3e7a09deec)
  <summary>Detail</summary>  


</details>

## Working

<details>

<summary>Detail</summary>

### Instructions to Use the Circuit:

• Click on reset before starting the game.

• Click on Set Bomb to set 1 bomb, the game can be played now. Repeat this process to set multiple bombs. The number of bombs will be displayed on the screen.

• After you set certain number of bombs, you can start opening the boxes.

• Enter the 4- bit input which is assigned to the corresponding box in column major order. Then click on the confirm button to lock in the answer.

• The Game Over output will be lit and all the bombs will be displayed if the user encounters a bomb or else, the person can keep giving the inputs.

• If the user enters all the inputs other than the bombs, Game Won output will be lit.

• Click on reset to restart the game.

## Working of Modules:

### Random number generator: 
Generates a random number using linear feedback shift register (LFSR). It keeps on repeating numbers from 1 to 15 randomly and we will lock a number randomly by clicking on the Set Bomb button. The bit keeps shifting while the first bit is the XOR of last two digits.

### Score Counter Module:
It uses j-k flip flops where the output of one flip flop is given as clock for next flip flop and it increases when there is a change in input. The change in input is recorded by using d flip flop.
The counter can count from 0 to 15. It basically increments its value by 1 every time the user opens a box without a bomb. It is essential to know whether the user won or lost the game.

### Grid Module:
This records the placement of those bombs from random number generator using d - flip flops and records the number of bombs using counter.

### D-Flip Flop Module:
It takes in the input from the decoder, bomb placement module and game over condition. The output will be 1 if that box is opened or the game is finished and a bomb is present in that location. The other output will be 1 if the bomb is present in that box and the box is opened.

### Output Module:
This takes in the inputs and opens the box assigned with that number. The game over condition will be reached if any one of the boxes with bomb is opened. i.e., We use And gate to check if bomb is present and the box is opened. Game won condition is reached when (16 -number of bombs) boxes are opened. This number is obtained by subtracter and is kept track using counter.

### Main Module:
This is the main module where we can play the game by following the steps written in Simulation. It involves the Output module which shows all the boxes, it’s state and final game winning or losing condition

### flowchart

![Untitled design](https://github.com/user-attachments/assets/85f1f9ee-6fd4-40bd-ba26-bb3e7a09deec)


</details>


## Logisim Circuit Diagram

<details>
  
### Random Number Generator:
![random number generator](https://github.com/user-attachments/assets/4b1b08b5-4a0c-48a8-8b2d-32a470ef46e0)

### Grid Module:
![Grids](https://github.com/user-attachments/assets/29c9076e-02c9-4b55-95c3-7acae7c9d50b)

### D-Flip Flop Module:
![d-flip-flop](https://github.com/user-attachments/assets/4da4167e-9b70-4bbe-a2f7-f4781b2a872b)

### Output Generator Module:
![output](https://github.com/user-attachments/assets/24f10f13-723f-45fb-bb13-24e575163ba7)

### Main Module:
![main](https://github.com/user-attachments/assets/7e8a39bf-4eeb-4a2f-b14a-7d1de2094487)

<summary>Detail</summary>
  
</details>

## Verilog Code

<details>
<summary>Detail</summary>

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


### Test bench File

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
</details>

## References
<details>

  <summary>Detail</summary>
  
</details>
