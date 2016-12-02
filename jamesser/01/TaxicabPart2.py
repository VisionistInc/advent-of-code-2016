import sys

def processInput(data):
	NESW = [0, 0, 0, 0]
	position = 0
	points = {}
	for fullCommand in data.split(", "):
	    turn = fullCommand[0]
	    distance = int(fullCommand[1:])

	    if turn is 'L':
	        position -= 1
	    else:
	        position += 1

	    position %= 4

	    for i in range(distance):
	        NESW[position] = NESW[position] + 1

        	curPoint = ((NESW[1] - NESW[3]), (NESW[2] - NESW[0]))

	        if curPoint in points:
        	   return NESW

		points[curPoint] = True

	return test

dataPath = sys.argv[1]


data = ""
with open(dataPath, 'r') as dataFile:
    data=dataFile.read().replace('\n', '')

test = processInput(data)

print ("Distance from HQ: %d" % (abs(test[0] - test[2]) + abs(test[1] - test[3])))
