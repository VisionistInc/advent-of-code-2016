import tables

var answer = newSeq[CountTable[string]](8)
for table in mitems( answer ):
    table = initCountTable[string]()

for line in lines( "input.txt" ):
    for i, character in line[0..7]:
        answer[i].inc( $character )

var largest = ""
var smallest = ""
for table in answer.mitems:
    table.sort()
    largest &= table.largest.key
    smallest &= table.smallest.key
echo "Part 1: ", largest
echo "Part 2: ", smallest
