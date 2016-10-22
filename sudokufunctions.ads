---------------------------------------
--           Suduko Solver           --
-- By: Nicholas Macedo               --
-- Program to solve sudoku given     --
-- via file. Output to file & stdio. --
---------------------------------------

package sudokuFunctions is

    -- State the Array to hold the board --
    type sudokuArray is array(0..8, 0..8) of integer;

    -- Used to check if the spot in question is taken. --
    function emptySpot (gameArray : sudokuArray; row : integer; column : integer; value : integer)
    return integer;

    -- Used to fill in the sudoku in a recursive mannor. --
    procedure solveSudoku (gameArray : in out sudokuArray ; row : in integer ; column : in integer ; toReturn : out integer);

    -- Used to fill the game array with the data in the input file. --
    procedure sudokuSetUp(gameArray : out sudokuArray);

    -- Used to print the solved sudoku in the correct format to stdio. --
    procedure printSudoku(gameArray : in sudokuArray);

    -- Used to print the solved sudoku in the correct format to the output file chosen by the user. --
    procedure printSudokuToFile(gameArray : in sudokuArray);

end sudokuFunctions;
