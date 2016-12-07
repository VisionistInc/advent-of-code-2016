import sys

class Column():
    def __init__(self):
        self.chars = {}

    def add_char(self, char):
        if char in self.chars:
            self.chars[char] += 1
        else:
            self.chars[char] = 1

    def get_char(self):
        chars = [(v,k) for (k, v) in self.chars.items()]
        # totally cheating on this one.
        chars.sort(key=lambda tup: tup[0], reverse=True)
        return chars[0][1]


data = open(sys.argv[1], 'r')
columns = []
for line in data:
    line = line.strip()
    if len(columns) == 0:
        for i in range(len(line)):
            columns.append(Column())
    for i in range(len(line)):
        columns[i].add_char(line[i])

word = [column.get_char() for column in columns]
print(''.join(word))

data.close()
