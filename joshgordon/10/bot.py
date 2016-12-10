class Bot():
  def __init__(self):
    self.chips = []
    self.give_to = [(False, None), (False, None)]

  def get(self, chip):
    self.chips.append(chip)
    self.chips.sort()

  def give_chips(self, low, high):
    self.give_to = [low, high]

  def give(self):
    chips = self.chips
    self.chips = []
    return [(chips[0], self.give_to[0]), (chips[1], self.give_to[1])]

  def can_give(self):
    return len(self.chips) == 2

  def __repr__(self):
    return repr([self.chips, self.give_to])
