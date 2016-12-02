import sys

dataPath = sys.argv[1]

NESW = [0, 0, 0, 0]
position = 0

data = ""
with open(dataPath, 'r') as dataFile:
    data=dataFile.read().replace('\n', '')

for fullCommand in data.split(", "):
    turn = fullCommand[0]
    distance = int(fullCommand[1:])

    if turn is 'L':
	position -= 1
    else:
	position += 1

    position %= 4

    NESW[position] = NESW[position] + distance

print ("Distance from HQ: %d" % (abs(NESW[0] - NESW[2]) + abs(NESW[1] - NESW[3])))
