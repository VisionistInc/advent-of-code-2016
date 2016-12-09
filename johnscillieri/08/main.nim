import sequtils
import strutils

var m = @[
    newSeq[int](50),
    newSeq[int](50),
    newSeq[int](50),
    newSeq[int](50),
    newSeq[int](50),
    newSeq[int](50),
]

proc to_string( m: seq[seq] ) =
    for row in m:
        echo mapIt( row, if it==0: "." else: "#" ).join()
    echo ""

template rotate_row( m: var seq[seq], row: int ) =
    m[row] = m[row][^1] & m[row][0.. ^2]

template rotate_column( m: var seq[seq], column: int ) =
    var t = m[^1][column]
    for i, row in m:
        #echo i, ",", column, " was ",  m[i][column], " and is now ", t
        (m[i][column], t) = (t, m[i][column])


m.tostring

# for line in lines( "input.txt" ):
#     echo line
