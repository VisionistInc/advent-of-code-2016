class Parser():
    def __init__(self, display):
        self.display = display

    def runLine(self, line):
        line = line.strip().split(' ')
        if line[0] == "rect":
            size = [int(arg) for arg in line[1].split('x')]
            self.display.rect(*size)
        elif line[0] == "rotate":
            index = int(line[2].split('=')[1])
            amount = int(line[4])
            if line[1] == "column":
                self.display.rotateColumn(index, amount)
            elif line[1] == "row":
                self.display.rotateRow(index, amount)
