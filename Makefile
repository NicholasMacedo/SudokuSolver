all:
	gnatmake -Wall sudokufunctions.adb sudokufunctions.ads sudoku.adb

removeFiles:
	rm *.txt

clean:
	rm *.ali
	rm *.o
	rm sudoku
