class Display():
    def __init__(self, height, width):
        self.height = height
        self.width = width
        self.rows = []
        for i in range(height):
            column = []
            for j in range(width):
                column.append('.')
            self.rows.append(column)

    def __repr__(self):
        str = ""
        for row in self.rows:
            str+= ''.join(row)
            str+= '\n'
        return str

    def rect(self, width, height):
        for i in range(height):
            for j in range(width):
                self.rows[i][j] = '#'

    @staticmethod
    def _rotate(array, amount):
        temp=[]
        for i in range(len(array)):
            temp.append(array[i - amount % len(array)])
        return temp

    def rotateColumn(self, column_num, amount):
        column = []
        for i in range(self.height):
            column.append(self.rows[i][column_num])
        column = self._rotate(column, amount)
        for i in range(self.height):
            self.rows[i][column_num] = column[i]


    def rotateRow(self, row, amount):
        self.rows[row] = self._rotate(self.rows[row], amount)

    def count(self):
        count = 0
        for row in self.rows:
            for column in row:
                if column == '#':
                    count +=1
        return count
