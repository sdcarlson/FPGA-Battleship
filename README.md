# Introduction 

The objective of this final project was to implement a classic game of Battleship on a Field-Programmable Gate Array (FPGA), specifically using a Basys3 board. This project aims to bring the strategic, grid-based gameplay of Battleship into the realm of digital hardware design. Our goal is to not only create a playable version of Battleship but also to integrate visual components using a VGA display, thereby enhancing the user experience.

# Design Description

All arrays are sized 36 bits, with row major order.
Cursor: 36 bit array where a single 1 bit determines the current spot of the cursor (all other bits should be 0)
Ship Location Array: 36 bit array where 1 bits determines the current spots occupied by a ship.
Coloring Array (grid state array): 36 bit array where 1 bits determine where the player has attacked so far on the board.

## VGA Display Module

With a 25 Mhz clock generated from a mod-4 counter, we cycle through every pixel in a 640 x 480 screen space and update their 3 corresponding 4-bit RGB values individually through some if conditionals. To prevent a “stretched” look of the 6 x 6 grid we had envisioned, we captured pixel updates only on a 480 x 480 grid, with the remaining parts of the screen blacked out. For a 6 x 6 grid, this meant that squares representing spots on the grid will have 80 x 80 dimensions, and with some division to the 480 x 480 grid layout, we can easily determine the current spot at any given area in the board. We update the correct pixel colors that occupy the given spot which is determined by conditionals that consider a ships location array (ship positions on the board), coloring array (player attacks on the board), and cursor array (current cursor position on the board).
##Seven Segment Module
Handles translating the seven segment signal to display win/loss notifications on the seven segment display (has correct bit sequence for cathode/anode configuration). Default case is closing all seven segments on the display (no win/loss end condition detected yet).
##Grid Attack Module
Initially set lives register to be a 15 1 bit value, which will be passed as output to illuminate the corresponding 15 leds on the board. These leds will represent the lives remaining for the player. If a reset is detected (restart game), reassign the 15 1 bit value back to lives. If a debounced attack signal is passed, we update the coloring array, and if the current cursor spot does not overlap with a space occupied by a spot, we left shift the lives register. We pass the lives register to directly update the 15 leds on the board, and whenever there is a left shift on this register, we simulate a loss of a “life” by closing off the led (left shift introduces a 0 bit).
##Top Module
This module is mainly responsible for routing the correct inputs and outputs across all other modules. Passes the ship configuration to the ship location array. Using a refresh clock, we consistently check to see if there is a win detected (coloring array completely overlaps all the 1 bits with the ships location array, indicating player has successfully hit all ships), if there is a loss detected (lives register is 0), or if the game state is still in progress. Depending on these scenarios, we pass a seven sig signal consistently as well to the Seven Seg Module.
##Debouncer Module
This module serves as a filtering mechanism to stabilize potentially noisy input signals coming from the buttons on the Basys 3 that the users are using to control the game. The module operates synchronously using a high-frequency clock (100 Hz). It takes as input the raw signals coming from each of the buttons and outputs the debounced signal which is stable. The module works by using a 2-bit state variable (debounce_state) to track the signal’s state through a simple state machine. The state machine transitions between its states on each positive edge of the high-frequency clock based on the presence or absence of the input signal (button press). The outputted debounced signal is only asserted when a stable high signal is detected by the module.
##Grid Controller Module
This module is used to manage and update the state of the 6x6 battleship grid based on your user inputs. This module takes in the debounced button signals for directional controls (up, down, left, right) and produces a 36-bit literal that contains 35 0’s and a single 1 representing the user’s position on the grid. The module initializes the user’s position to the top-left corner of the grid. On each positive edge of the clock, the module checks if one of the directions has been selected and updates the grid output accordingly. The array outputted from this module is passed directly into the VGA display module so the user’s grid selection can be visualized on the monitor.
##Clock Dividers Module
The clock divider module takes as input the Basys 3 system clock (‘clk’ in the .xdc file) and produces two slower clocks of frequency 1 Hz and 100 Hz. The module uses internal counters (one_hz_counter and refresh_counter) to divide the frequency of the input clock and achieve the desired frequencies for the new clocks.
