---------------------------------------
--           Suduko Solver           --
-- By: Nicholas Macedo               --
-- Program to solve sudoku given     --
-- via file. Output to file & stdio. --
---------------------------------------

with Ada.Text_IO; use Ada.Text_IO;
with Ada.Integer_Text_IO; use Ada.Integer_Text_IO;

package body sudokuFunctions is

----------------------------------------------------------------------------------------------
-- emptySpot: Check to see if the spot is availiable.                                       --
-- Pre: Puzzle array to check location and the spot to check and value to compare spot to.  --
-- Post: Returns 1 if availiable and 0 if not.                                              --
----------------------------------------------------------------------------------------------
function emptySpot (gameArray : sudokuArray; row : integer; column : integer; value : integer) return integer is

    rowCal : integer;
    columnCal : integer;

begin

    rowCal := (row/3) * 3;       --Used for later calculation of array index.
    columnCal := (column/3) * 3;

    for i in 0..8 loop -- Check to see if the value is there.
        if (gameArray(row, i) = value) then
            return 0;
        end if;

        if (gameArray(i, column) = value) then
            return 0;
        end if;

        if (gameArray((rowCal + (i mod 3)),(columnCal + (i/3))) = value) then
            return 0;
        end if;
    end loop;  
    return 1;

end emptySpot;

--------------------------------------------------------------------------------------------------------
-- solveSudoku: Procedure used to solve the puzzle.  *Algorithm taken from site given in PDF*         --
-- Pre: Puzzle array to solve, row and column for recursion and a value to act as a return value.     --
-- Post: Solves the puzzle in the array. Using an interger to return a value, returns 1 if solution   --
--       and 0 if no solution to puzzle. Returns no value due to being a procedure.                   --
--------------------------------------------------------------------------------------------------------
procedure solveSudoku (gameArray : in out sudokuArray; row : in integer; column : in integer; toReturn : out integer) is

    returnVal : integer;
    isEmpty : integer;

begin
    if ((row < 9) and (column < 9)) then
        if (gameArray(row,column) /= 0) then
            if ((column + 1) < 9) then
                solveSudoku(gameArray, row, (column + 1), returnVal); -- Call the procedure for recursion --
                toReturn := returnVal; -- Catch the return value and set it to the return val of this procedure --
                return;  -- Return procedure. --
            elsif ((row + 1) < 9) then
                solveSudoku(gameArray, (row + 1), 0, returnVal);
                toReturn := returnVal;
                return;
            else 
                toReturn := 1;
                return;
            end if;
        else
            for i in 0 .. 8 loop
                isEmpty := emptySpot(gameArray, row, column, (i + 1)); --Check to see if spot is empty.
                if (isEmpty = 1) then
                    gameArray(row,column) :=  (i + 1);
                    if ((column + 1) < 9) then
                        solveSudoku(gameArray, row, (column + 1), returnVal); --Call procedure recursivly.
                        if (returnVal = 1) then
                            toReturn := 1;
                            return;
                        else
                            gameArray(row,column) := 0;
                        end if;
                    elsif ((row + 1) < 9) then
                        solveSudoku(gameArray, (row + 1), 0, returnVal); --Call procedure recursivly.
                        if (returnVal = 1) then
                            toReturn := 1;
                            return;
                        else
                            gameArray(row,column) := 0;
                        end if;
                    else
                        toReturn := 1;
                        return;
                    end if;
                end if;  
            end loop;
        end if;
    
        toReturn := 0;
        return;
    else 
        toReturn := 1;
        return;
    end if;

end solveSudoku;

---------------------------------------------------------------------------------------------------------
-- sudokuSetUp: Initialize the puzzle array with the values from the file before solving.              --
-- Pre: Puzzle array to put the unsolved puzzle into.                                                  --
-- Post: Fills the puzzle array with values from the given input fie. Returns noting due to procedure. --
---------------------------------------------------------------------------------------------------------
procedure sudokuSetUp(gameArray : out sudokuArray) is

    inFile : file_type; --In file type.
    row : integer := 0;
    strLen : constant := 99; --Length of string
    fileName : String(1 .. strLen + 1); -- String of 99 char's
    item : character; --Holds number from file in char form.
    itemNum : integer; --Holds converted number before adding to array.
    Last : Natural; --Example for this from courselink.
    fType : integer := 0;

begin
    
    while (fType /= 1) loop
        put_line("Enter the name of the input file. (Program ends on incorrect name.): ");
        Get_Line(fileName, Last); --Get file name from user.
        if(fileName(Last-3 .. Last) = ".txt") then
            fType := 1;
        end if;
    end loop;

    open(inFile, in_file, Name => fileName(1..Last)); --Open given file.
    loop
        exit when End_Of_File(inFile);
            for column in 0 .. 8 loop
                get(inFile,item);
                itemNum := Character'Pos(item); --Convert character num to ascii value for number.
                itemNum := itemNum - 48; --Convert from ascii to actual numbers (0 to 9)
                gameArray(row,column) := itemNum;
            end loop;
            row := row + 1;
    end loop;
    close(inFile); --Close file after reading values.
    exception
        when Name_Error | Use_Error =>
        raise Program_Error with "Program termination triggered due to invalid file."; --Exit program if file error.
        
end sudokuSetUp;

-----------------------------------------------------------------------------------
-- printSudoku: Procedure used to print the solved puzzle to the screen.         --
-- Pre: Puzzle array with solution.                                              --
-- Post: Prints solution to screen with format. Returns noting due to procedure. --
-----------------------------------------------------------------------------------
procedure printSudoku(gameArray : in sudokuArray) is

    row : integer := 0;
    column : integer := 0;

begin
    put_line("+-----+-----+-----+");
    for i in 0 .. 11 loop
        if (i = 3 or i = 7 or i = 11) then
            put_line("+-----+-----+-----+");
        else
            column := 0;
            for j in 0 .. 18 loop
                if (j = 0 or j = 6 or j = 12 or j = 18) then
                    put("|");
                elsif (j = 2 or j = 4 or j = 8 or j = 10 or j = 14 or j = 16) then
                    put(" ");
                else
                    put(gameArray(row,column),width=>0);
                    column := column + 1;
                end if;
            end loop;
            New_Line;
            row := row + 1;
        end if;
        end loop;

end printSudoku;

---------------------------------------------------------------------------------------------------
-- printSudokuToFile: Procedure used to print the solved puzzle to the output file given.        --
-- Pre: Puzzle array with solution.                                                              --
-- Post: Created output file with the puzzle's solution inside. Returns noting due to procedure. --
---------------------------------------------------------------------------------------------------
procedure printSudokuToFile(gameArray : in sudokuArray) is

    row : integer := 0;
    column : integer := 0;
    outFile : file_type; --Out file name.
    strLen : constant := 99;
    fileName : String(1 .. strLen + 1); -- String of 99 char's
    Last : Natural; --Given in example.

begin

    put_line("Enter the name of the output file. (Must end in .txt): ");
    Get_Line(fileName, Last);

    create(outFile, out_file, Name => fileName(1..Last));  --Creates and opens the file given by the user to store the output.
    put_line(outFile,"+-----+-----+-----+");
    for i in 0 .. 11 loop  --Loop through the rows to print the output in special format.
        if (i = 3 or i = 7 or i = 11) then
            put_line(outFile,"+-----+-----+-----+");
        else
            column := 0;
            for j in 0 .. 18 loop  --Loop through the columns to print the output in the special format.
                if (j = 0 or j = 6 or j = 12 or j = 18) then -- If these values then its an edge.
                    put(outFile,"|");
                elsif (j = 2 or j = 4 or j = 8 or j = 10 or j = 14 or j = 16) then --If these values then its inbetween values.
                    put(outFile," ");
                else
                    put(outFile,gameArray(row,column),width=>0); --Prints the value at the row and column kept track of seperatly.
                    column := column + 1;
                end if;
            end loop;
            put_line(outFile,""); --Acts as artificial new line.
            row := row + 1;
        end if;
        end loop;
    close(outFile);
        exception
            when Name_Error | Use_Error =>
            raise Program_Error with "Program termination triggered due to invalid file.";

end printSudokuToFile;

end sudokuFunctions;
