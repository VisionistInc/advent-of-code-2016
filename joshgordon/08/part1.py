import sys
from display import Display
from inputParser import Parser

display = Display(6, 50)
parser = Parser(display)
with open(sys.argv[1]) as infile:
    for line in infile:
        parser.runLine(line)

print display
print display.count()
