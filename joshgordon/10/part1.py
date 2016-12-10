import sys
from bot import Bot
import re

valueLine = re.compile(r'value (\d+) goes to bot (\d+)')
giveLine = re.compile(r'bot (\d+) gives low to (bot|output) (\d+) and high to (bot|output) (\d+)')

bots = {}
output = {}

def make_output(bot_output, num):
  return (bot_output == "output", num)

with open(sys.argv[1]) as infile:
  for line in infile:
    if line[:5] == "value":
      match = valueLine.match(line)
      value = int(match.group(1))
      bot_num = int(match.group(2))
      if bot_num not in bots:
        bots[bot_num] = Bot()
      bots[bot_num].get(value)
  infile.seek(0)
  for line in infile:
    if line[:3] == "bot":
      match = giveLine.match(line)
      bot_num = int(match.group(1))
      low = make_output(match.group(2), int(match.group(3)))
      high = make_output(match.group(4), int(match.group(5)))
      if bot_num not in bots:
        bots[bot_num] = Bot()
      bots[bot_num].give_chips(low, high)

#OKAY, I think we're done parsing. Holy crap that was gnarly.
found = True

while True:
  if found == False:
    break
  found = False
  for bot in bots:
    if bots[bot].can_give():
      found = True
      #print "bot %d can give" %(bot,)
      give= bots[bot].give()
      #print "Bot %d giving chip %d to bot %d and chip %d to bot %d" % (bot, give[0][0], give[0][1][1], give[1][0], give[1][1][1])
      if give[0][1][0]:
        output[give[0][1][1]] = give[0][0]
      else:
        bots[give[0][1][1]].get(give[0][0])
      if give[1][1][0]:
        output[give[1][1][1]] = give[1][0]
      else:
        bots[give[1][1][1]].get(give[1][0])

      #print give[0][0], give[1][0]

      if give[0][0] == 17 and give[1][0] == 61:
        print "Bot sorting 17 and 61 is:", bot

print "Output:", output
