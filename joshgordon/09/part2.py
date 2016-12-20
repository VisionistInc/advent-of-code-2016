import sys
import re

#regex to match the markers
comp = re.compile(r'\((\d+)x(\d+)\)')

#Yay, recursion. Did you mean recursion?
def decompress(string):

  # base case: don't have any markers in our text, so we just return the length
  if comp.search(string) is None:
    return len(string.strip())

  # otherwise we have to search for markers and "expand" them. ("expand" because we promptly throw out all the actual text)
  else:
    # the length of our string is 0
    length = 0
    # we start at the beginning of the string
    pos = 0
    while pos < len(string) and string[pos] != '\n':

      # if the position we're at is a marker, we can go ahead and process it
      if string[pos] == '(':
        # figure out the number of chars and the number of times to repeat.
        match = comp.match(string[pos:])
        chars = int(match.group(1))
        repeat = int(match.group(2))

        # move our position past the marker
        pos += len(match.group())

        # recurse over the part that needs to be expanded, and multiply by the number of times that chunk gets repeated
        length += decompress(string[pos:pos+chars]) * repeat

        # move past the end of the chunk
        pos += chars
      # if it's not a marker, move forward by 1
      else:
        length += 1
        pos += 1

    # don't forget to return the length at the end!
    return length

with open(sys.argv[1]) as infile:
  data = infile.read()

print decompress(data)
