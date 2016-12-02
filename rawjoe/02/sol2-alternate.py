start_char = '5'

# assumes 1 non-whitespace character per button
f = open("pad", "r")

pad = f.read()

f.close()

rows = pad.split('\n')

h = len(rows) - 1; # not sure why -1 yet, the split above leaves an extra 0 len sting in list

w = 0
for row in rows:
    if len(row) > w:
        w = len(row)

grid = [[' ' for x in range(w)] for y in range(h)]

y = 0
for row in rows:
    x = 0
    for c in row:
        grid[x][y] = c
        x = x + 1
    y = y + 1

print("=====PAD=====")
for y in range(h):
    for x in range(w):
        print("%c " % grid[x][y], end="")
    print("")
print("=============")


f = open("input", "r")

code = f.read().split()

f.close()

found = 0;

# find start char
for y in range(h):
    for x in range(w):
        if grid[x][y] == start_char:
            found = 1
            break
    if found == 1:
        break
            
# x and y now contain the start location

for digit in code:
    for c in digit:
        if c == 'U':
            if y != 0 and grid[x][y-1] != ' ':
                y = y-1
        if c == 'D':
            if y != h-1 and grid[x][y+1] != ' ':
                y = y+1
        if c == 'R':
            if x != w-1 and grid[x+1][y] != ' ':
                x = x+1
        if c == 'L':
            if x != 0 and grid[x-1][y] != ' ':
                x = x-1
    
    print(grid[x][y], end="")
