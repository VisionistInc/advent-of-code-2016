import sys


class Keypad():
    """
    Keypad class - abstract class that mostly just handles movement.
    You'll have to extend this to include a grid (an nxn length array that
    gets wrapped), a size, and an initial position to start at.
    """

    grid = [
        ]
    size = 0
    position = None

    def move(self, move):
        if move == "U":
            new_position = self.position - self.size
            if new_position < 0:
                return False
        elif move == "D":
            new_position = self.position + self.size
            if new_position >= self.size * self.size:
                return False
        elif move == "L":
            new_position = self.position - 1
            if (self.position // self.size) != new_position // self.size:
                return False
        elif move == "R":
            new_position = self.position + 1
            if self.position // self.size != new_position // self.size:
                return False
        if self.grid[new_position] == " ":
            return False

        self.position = new_position
        return new_position

    def get_char(self):
        return self.grid[self.position]

class Keypad_3(Keypad):
    grid = [str(x) for x in range(1, 10)]
    size=3
    position = grid.index("5")

class Keypad_5(Keypad):
    grid = [
        " "," ","1"," "," ",
        " ","2","3","4"," ",
        "5","6","7","8","9",
        " ","A","B","C"," ",
        " "," ","D"," "," "
    ]
    size = 5
    position = grid.index("5")


# store the digits we stop on
code_3 = []
code_5 = []

#read the file
f = open(sys.argv[1])

# keypad instances
keypad_3 = Keypad_3()
keypad_5 = Keypad_5()

#iterate over the lines. Each line has a string of instructions
for line in f:
    line = line.strip()
    # iterate over the instructions in a line.
    for char in line:
        keypad_3.move(char)
        keypad_5.move(char)

    # at the end of each line, we stop on a digit that we need to keep track of.
    code_3.append(keypad_3.get_char())
    code_5.append(keypad_5.get_char())

# we're done with the file, so go ahead and let it go.
f.close()

# Print out the results
print "3x3 code:" + ''.join(code_3)
print "5x5 code:" + ''.join(code_5)

