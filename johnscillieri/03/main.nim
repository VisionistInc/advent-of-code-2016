import sequtils
import strutils

template check_triangle( sides: openarray[int] ): bool =
    (sides[0] + sides[1] > sides[2]) and (sides[1] + sides[2] > sides[0]) and (sides[0] + sides[2] > sides[1])

let data_array = mapIt( toSeq( lines("input") ), mapIt( it.splitWhitespace(), it.parseInt ) )

# Part 1
echo len( filterIt( data_array, check_triangle( it ) ) )

# Part 2
var count = 0
for i in countup(2, len(data_array), 3):
    if check_triangle( [data_array[i][0], data_array[i-1][0], data_array[i-2][0]] ): count += 1
    if check_triangle( [data_array[i][1], data_array[i-1][1], data_array[i-2][1]] ): count += 1
    if check_triangle( [data_array[i][2], data_array[i-1][2], data_array[i-2][2]] ): count += 1
echo count
