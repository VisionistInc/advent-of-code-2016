import algorithm
import sequtils
import strutils
import tables

proc sector_number( room: string ): int =
    ## Returns the sector number if valid, -1 otherwise
    var counts = initCountTable[char]()
    var offset = -1
    for index, letter in room:
        if letter == '-': continue
        if letter.isdigit():
            offset = index
            break
        counts.inc( letter )

    # Unfortunately, can't use the CountTable's built-in sort order...
    var pairs = toSeq( counts.pairs() )
    pairs.sort do (x, y: (char,int)) -> int:
        result = cmp(x[1], y[1]) * -1
        if result == 0:
            result = cmp(x[0], y[0])

    let calculated = join( mapIt( pairs[0..4], it[0] ), "" )
    if calculated != room[^6..^2]: -1 else: parseInt( room[offset..(offset+2)] )

# For part 2, once we reduce the modulus range, we can just scale the
# alphabet 2x and not worry about writing the wrap around logic
const letters = cycle( toSeq('a'..'z'), 2 )

proc shift( s: string, k: int ): string =
    result = ""
    let real_k = k mod 26
    for letter in s:
        if letter == '-':
            result &= " "
        elif letter.isdigit():
            result &= letter
        else:
            result &= letters[letters.find( letter )+real_k]

var total = 0
for line in lines( "input.txt" ):
    let sector = sector_number( line )
    if sector == -1: continue

    total += sector

    let decrypted = line.shift( sector )
    if "north" in decrypted:
        echo "Part 2 result: ", decrypted
echo "Part 1 result: ", total
