
my_path = [[0,0]]

x = 0
y = 0
face = 0

f = open('input', 'r')

steps = f.read().split(', ')

f.close()

found = 0

for step in steps:
    if step[:1] == 'R':
        face = face + 1
    else:
        face = face - 1

    face = face % 4

    num = int(step[1:])

    adder = 1
    # 0 and 1 are north and east on axis
    if face > 1:
        adder = -1

    axis = 'x'
    if face % 2 == 0:
        axis = 'y'

    # 0 and 2 are north and south
    for i in range(0,num):
        if axis == 'y':
            y = y + adder
        else:
            x = x + adder

        if [x,y] in my_path:
            print("x = %d, y = %d, total is %d" % (x,y,abs(x)+abs(y)))
            found = 1
            break

        my_path.append([x,y])

    if found == 1:
        break

if found == 0:
    print("uh oh")
