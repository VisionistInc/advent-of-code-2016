
x = 0
y = 0
face = 0

f = open('input', 'r')

steps = f.read().split(', ')

f.close()

for step in steps:
    if step[:1] == 'R':
        face = face + 1
    else:
        face = face - 1

    face = face % 4

    num = int(step[1:])

    # 0 and 1 are north and east on axis
    if face > 1:
        num = num * -1

    # 0 and 2 are north and south
    if face % 2 == 0:
        y = y + num
    else:
        x = x + num

print("x = %d, y = %d, total is %d" % (x,y,abs(x)+abs(y)))
