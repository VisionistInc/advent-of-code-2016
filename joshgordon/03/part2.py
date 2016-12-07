import sys

# Transform the original array of triangles into the right form for part 2
def part2_triangles(triangles):
    # Shove all the columns together.
    all_triangles = [x[0] for x in triangles] + [x[1] for x in triangles] + [x[2] for x in triangles]
    # split all the columns into their own triangles
    return [all_triangles[x:x+3] for x in range(0, len(all_triangles), 3)]

# parse a line of input into an array of sides
def parse_line(line):
    triangle = line.strip().split(' ')
    return [int(side) for side in triangle if side != '']

# check if the triangle is valid
def check_triangle(triangle):
    return (triangle[0] + triangle[1] > triangle[2] and
           triangle[0] + triangle[2] > triangle[1] and
           triangle[1] + triangle[2] > triangle[0])


with open(sys.argv[1]) as f:
    triangles = [parse_line(line) for line in f]

# do the transform for part 2
triangles = part2_triangles(triangles)

# check all the triangles
valid = [check_triangle(triangle) for triangle in triangles]

# print output
print "valid triangles:", valid.count(True)
print "invalid triangles:", valid.count(False)
print "total triangles:", len(triangles)
