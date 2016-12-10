import sys
import re

comp = re.compile(r'\((\d+)x(\d+)\)')

with open(sys.argv[1]) as infile:
  data = infile.read()

pos = 0

output = []

while data[pos] != '\n' and pos <= len(data):
  if data[pos] != '(':
    output.append(data[pos])
    pos += 1
  else:
    match = comp.match(data[pos:])
    chars = int(match.group(1))
    repeat = int(match.group(2))
    print chars, repeat
    print len(match.group())
    pos += len(match.group())
    output.append(data[pos:pos+chars] * repeat)
    pos += chars

print ''.join(output)
print len(''.join(output))
