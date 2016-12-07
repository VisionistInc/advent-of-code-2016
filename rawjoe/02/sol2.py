
f = open("input", "r")

code = f.read().split()

f.close()

up2   = [3,0xd]
up4   = [6,7,8,0xa,0xb,0xc]
down2 = [1,0xb]
down4 = [2,3,4,6,7,8]
left  = [3,4,6,7,8,9,0xb,0xc]
right = [2,3,5,6,7,8,0xa,0xb]

for digit in code:
    pos = 5
    for c in digit:
        if c == 'U':
            if pos in up2:
                pos = pos - 2
            elif pos in up4:
                pos = pos - 4
        if c == 'D':
            if pos in down2:
                pos = pos + 2
            elif pos in down4:
                pos = pos + 4
        if c == 'R' and pos in right:
            pos = pos + 1
        if c == 'L' and pos in left:
            pos = pos - 1
    
    print(hex(pos))
