import sequtils
import tables

# Traditional keypad
const map = [
    #U,D,L,R
    [1,4,1,2],
    [2,5,1,3],
    [3,6,2,3],
    [1,7,4,5],
    [2,8,4,6],
    [3,9,5,6],
    [4,7,7,8],
    [5,8,7,9],
    [6,9,8,9]
]

# Diamond keypad: A = 10, B = 11, C = 12, D = 13
#     1
#   2 3 4
# 5 6 7 8 9
#   A B C
#     D
const diamond_map = [
    [1,3,1,1],
    [2,6,2,3],
    [1,7,2,4],
    [4,8,3,4],
    [5,5,5,6],
    [2,10,5,7],
    [3,11,6,8],
    [4,12,7,9],
    [9,9,8,9],
    [6,10,10,11],
    [7,13,10,12],
    [8,12,11,12],
    [11,13,13,13]
]

const move_map = { 'U':0, 'D':1, 'L':2, 'R':3 }.toTable()

proc press( filename: string, keypad: openarray[array[4, int]], start=5 ): string =
    result = ""
    for line in lines( filename ):
        result &= $foldl( line, keypad[a-1][move_map[b]], start ) & " "

echo press( "input", map )
echo press( "input", diamond_map )
