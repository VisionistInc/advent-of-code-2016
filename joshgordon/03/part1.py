import sys

def parse_line(line):
    triangle = line.strip().split(' ')
    return [int(side) for side in triangle if side != '']

def check_triangle(triangle):
    return (triangle[0] + triangle[1] > triangle[2] and
           triangle[0] + triangle[2] > triangle[1] and
           triangle[1] + triangle[2] > triangle[0])


with open(sys.argv[1]) as f:
    triangles = [parse_line(line) for line in f]

valid = [check_triangle(triangle) for triangle in triangles]

print "valid triangles:", valid.count(True)
print "invalid triangles:", valid.count(False)
print "total triangles:", len(triangles)
