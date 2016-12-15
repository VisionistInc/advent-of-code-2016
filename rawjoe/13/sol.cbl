IDENTIFICATION DIVISION.
PROGRAM-ID. sol.

DATA DIVISION.
        WORKING-STORAGE SECTION.
        01 maze.
                05 x OCCURS 101 TIMES.
                        10 val OCCURS 101 TIMES.
                                15 y PIC 9(3) VALUE 998.
      *>Puzzle input
        01 puzInput PIC 9(4) VALUE 1362.
      *>Number of moves into maze we are
        01 moves PIC 9(3) VALUE 000.
      *>x0 and y0 are our loop variables through the maze
        01 x0 PIC 9(3).
        01 y0 PIC 9(3).
      *>x1 and y1 get modified to look at neighbors of x0,y0
        01 x1 PIC 9(3).
        01 y1 PIC 9(3).
      *>x2 and y2 are -1 from x1 and y1, since COBOL arrays start at 1, not 0
        01 x2 PIC 9(3).
        01 y2 PIC 9(3).
      *>Helper vars for doing math
        01 math PIC 9(10).
        01 adder PIC 9(10).
        01 divisor PIC 9(10).
        01 dividend PIC 9(10).
      *>Tracks spaces we can reach before 50
        01 cnt PIC 9(4) VALUE 1.

PROCEDURE DIVISION.
        MAIN.
      *>Idea is: iterate over the maze, space by space, incrementing moves
      *>each pass over the maze.  We only act on spaces that match moves
      *>The Maze is set up so that every space has 998 in it, except the starting space
      *>998 indicates that the space has yet to be evaluated.  It's a really large number
      *>that will likely be greater than any move count we see.

      *>So on the first pass, only one space should hit (starting point)
      *>  On that one space, look at neighbors and set to either
      *>    999 (wall) or
      *>    moves (if moves is less than the current value)

      *>Increment moves and repeat.  Eventaully get to target space and over 50 moves.
      

      *>Init starting space to take 0 moves to reach
        MOVE 000 TO val(2,2).

        MAIN-LOOP.
        MOVE 001 TO x0.
        ADD 1 TO moves.
      *>for x0 from 1 to 100
        PERFORM INNER-LOOP WITH TEST BEFORE UNTIL x0 > 100.

      *>If the space we are interested in got set
      *>And we've gotten past 50 moves
        IF val(32,40) < 998 AND moves > 50 THEN
                GO TO MAIN-DONE
        ELSE
                GO TO MAIN-LOOP
        END-IF.

        INNER-LOOP.
        MOVE 001 TO y0.
      *>for y0 from 1 to 100
        PERFORM XY-SUB WITH TEST BEFORE UNTIL y0 > 100.
      *>Increment x0
        ADD 1 TO x0.

        MAIN-DONE.
        DISPLAY "(31,39) in "val(32,40).
        DISPLAY "Total spaces in under 50 is "cnt.
        STOP RUN.

      *>This subroutine looks at neighbors of x0 and y0
      *>and determines if they are walls or spaces
        XY-SUB.
        MOVE x0 TO x1.
        MOVE y0 TO y1.

        ADD -1 TO x1.
        PERFORM ISVALID-SUB THRU ISVALID-SUB-DONE.
        ADD 2 TO x1.
        PERFORM ISVALID-SUB THRU ISVALID-SUB-DONE.
        ADD -1 TO x1.
        ADD -1 TO y1.
        PERFORM ISVALID-SUB THRU ISVALID-SUB-DONE.
        ADD 2 TO y1.
        PERFORM ISVALID-SUB THRU ISVALID-SUB-DONE.

      *>Increment y0
        ADD 1 TO y0.

      *>This subroutine does all the work to determine
      *>if a space is a wall or not
        ISVALID-SUB.
        
      *>moves was pre-incremented, so we only want to do
      *>this logic is the space matches the actual move num
        MOVE moves TO x2.
        ADD -1 TO x2.
        IF NOT val(x0,y0) = x2 THEN
                go TO ISVALID-SUB-DONE
        END-IF.

      *>bounds check x and y (COBOL arrays start at 1)
        IF x1 = 0 THEN
                GO TO ISVALID-SUB-DONE
        END-IF.
        IF y1 = 0 THEN
                GO TO ISVALID-SUB-DONE
        END-IF.

      *>If we can already get to this space in fewer moves
        IF val(x1,y1) < x2 THEN
                GO TO ISVALID-SUB-DONE
        END-IF.

      *>If already determined to be a wall
        IF val(x1,y1) = 999 THEN
                GO TO ISVALID-SUB-DONE
        END-IF.

      *>Do the math
        MOVE x1 TO x2.
        MOVE y1 TO y2.
        ADD -1 TO x2.
        ADD -1 TO y2.
        MOVE puzInput TO adder.
        MOVE x2 TO math.
        MULTIPLY math by math.
        ADD math TO adder.
        MOVE x2 TO math.
        MULTIPLY 3 by math.
        ADD math TO adder.
        MOVE x2 TO math.
        MULTIPLY y2 by math.
        MULTIPLY 2 by math.
        ADD math TO adder.
        ADD y2 TO adder.
        MOVE y2 TO math.
        MULTIPLY math by math.
        ADD math TO adder.

      *>figure out how many bits
      *>init divisor to some really large power of 2 number
      *>that dividend will likely never reach
        MOVE adder TO dividend.
        MOVE 262144 TO divisor.
        MOVE 0 TO adder.

        ISVALID-SUB-LOOP.
        DIVIDE 2 INTO divisor.
        DIVIDE dividend BY divisor GIVING math REMAINDER dividend.
      *>math should be either 1 or 0, indicating if that bit was set
        ADD math TO adder.
        IF NOT divisor = 1 THEN
            GO TO ISVALID-SUB-LOOP
        END-IF.

      *>determine if even or odd number bits
        DIVIDE adder BY 2 GIVING adder REMAINDER math.
        IF math = 0 THEN
      *>if under 50 moves, and position hasn't been set before
                IF moves < 51 AND val(x1,y1) = 998 THEN
                        ADD 1 TO cnt
                END-IF
      *>set the position
                MOVE moves TO val(x1,y1)
        ELSE
      *>set position to be wall
                MOVE 999 TO val(x1,y1)
        END-IF.

        ISVALID-SUB-DONE.
        
