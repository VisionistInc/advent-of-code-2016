
f = open("input", "r")

code = f.read().split()

f.close()

for digit in code:
    pos = 5
    for c in digit:
        if c == 'U' and pos > 3:
            pos = pos - 3
        if c == 'D' and pos < 7:
            pos = pos + 3
        if c == 'R' and (pos % 3) != 0:
            pos = pos + 1
        if c == 'L' and (pos % 3) != 1:
            pos = pos - 1
    
    print(pos)
