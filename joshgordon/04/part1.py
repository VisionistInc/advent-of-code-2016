import sys

class room():
  name = None
  sector = None
  checksum = None
  def __init__(self, room_string):
    self.name = room_string[:-12]
    self.sector = int(room_string[-11:-8])
    self.checksum = room_string[-7:-2]

  def __str__(self):
    return self.name

  def compute_checksum(self):
    name = self.name.translate(None, '-')
    chars = {}
    for char in name:
      if char in chars:
        chars[char] += 1
      else:
        chars[char] = 1
    #chars = chars.
    chars = [(v,k) for (k, v) in chars.items()]
    # totally cheating on this one.
    chars.sort(key=lambda tup: str(9 - tup[0]) + tup[1])
    return ''.join([x[1] for x in chars[:5]])

  def is_valid(self):
    return self.compute_checksum() == self.checksum

  def decrypt_name(self):
    return ''.join([self.decrypt_letter(x) for x in self.name])

  def decrypt_letter(self, letter):
    if letter == "-":
      return " "
    codepoint = ord(letter)
    codepoint -= ord('a')
    codepoint += self.sector
    codepoint %= 26
    codepoint += ord('a')
    return chr(codepoint)



rooms = []
with open (sys.argv[1]) as f:
  for line in f:
    rooms.append(room(line))


for room in rooms:
  print room.decrypt_name() + ":", room.sector

valid_rooms = [room for room in rooms if room.is_valid()]
print "Total sector number of valid rooms:", reduce(lambda x, y: x + y.sector, valid_rooms, 0)
