---------------------------------------
--           Sudoku Solver           --
-- By: Nicholas Macedo (0889469)     --
-- Program to solve sudoku given     --
-- via file. Output to file & stdio. --
---------------------------------------

with Ada.Text_IO; use Ada.Text_IO;
with sudokuFunctions; use sudokuFunctions;

procedure sudoku is

    returnVal : integer := 2; --Value set to 2 because its not expected to return 2.
    row : integer;
    column : integer;
    gameArray : sudokuArray;

begin
    row := 0;
    column := 0;

    Put_Line("Welcome to my Sudoku Solver using Ada!");
    
    -- Setting up the sudoku puzzle from the file into the array.
    sudokuSetUp(gameArray);

    -- Solving the Sudoku Puzzle. Check if has solution or not using returnVal.
    Put_Line("Solving the puzzle...");
    solveSudoku(gameArray, row, column, returnVal);

    -- If returnVal is 1 then puzzle has solution.
    if(returnVal = 1) then
        Put_Line("Solved Sudoku Puzzle: ");
        printSudoku(gameArray);               --Show solution to stdio.
        printSudokuToFile(gameArray);         -- Print solution to file.
    else
        Put_Line("No Solution Found.");
    end if;

    Put_Line("Exiting...");
end sudoku;
