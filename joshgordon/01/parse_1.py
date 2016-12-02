from operator import add, sub
import sys

#image stuff
from PIL import Image, ImageDraw

#Read in the directions
with open(sys.argv[1]) as f:
    directions = f.read()[:-1]
directions.strip()
directions = directions.split(', ')

compass = 0
# Compass directions:
# 0 : north
# 1 : east
# 2 : south
# 3 : west
# turning RIGHT increments the compass, turning LEFT decrements.

compass_names = ["NORTH", "EAST", "SOUTH", "WEST"]

# starting at 0,0
coord = [0, 0]

# This gets multplied by the distance and then added as a whole to the
# coord variable above. It defines the directions that each movement
# should go.
movements = [
    # NORTH: add 1 to Y
    [0, 1],
    # EAST: add 1 to X
    [1, 0],
    #SOUTH: add -1 to Y
    [0, -1],
    # WEST: add -1 to X
    [-1, 0]
]

visited_coords = []
crosses = []

# Keep track of this so we can draw a pretty picture.
stop_coords = []
max_coord = [0, 0]
min_coord = [0, 0]

# Go through each step and figure out location
for direction in directions:
    if direction[0] == "R":
        compass += 1
    else:
        compass -= 1
    compass %= 4
    distance = int(direction[1:])

    #Update the coordinate.
    for i in range(distance):
        coord = map(add, coord, movements[compass])
        if coord in visited_coords:
            crosses.append(coord)
        visited_coords.append(coord)
    # original from part 1
    # coord = map(add, coord, [x * distance for x in movements[compass]])

    # update info for images:
    max_coord = map(max, coord, max_coord)
    min_coord = map(min, coord, min_coord)
    stop_coords.append(coord)
    print "facing %s, traveling %d to %s" % (compass_names[compass], distance, coord)

print "Need to travel to %s, for a total of %d blocks" % (coord, abs(coord[0]) + abs(coord[1]))
if len(crosses) > 0:
    print "Crossed %d time(s), the first one at %s for a distance of %d" % (len(crosses), crosses[0], abs(crosses[0][0]) + abs(crosses[0][1]))


### Generate a nice map
size = map(sub, max_coord, min_coord)
# round the sizes up to an even number for ffmpeg happiness
size = map(lambda x : x + x % 2, size)
stop_coords = [map(sub, coord, min_coord) for coord in stop_coords]
visited_coords =  [map(sub, coord, min_coord) for coord in visited_coords]

image = Image.new('RGBA', size, "black")
draw = ImageDraw.Draw(image)
# for i in range(len(stop_coords)-1):
#     draw.line(stop_coords[i] + stop_coords[i + 1])
#     image.save("frames/%04d.png" % (i,), "PNG")
for i in range(len(visited_coords) - 1):
     draw.line(visited_coords[i] + visited_coords[i + 1])
     image.save("frames/%04d.png" % (i,), "PNG")

