import sys

number = 5
movements = {'U': -3, 'D': 3, 'L': -1, 'R': 1}
invalid = {'U': [1, 2, 3], 'D': [7, 8, 9], 'L': [1, 4, 7], 'R': [3, 6, 9]}
code = []
f = open(sys.argv[1])
for line in f:
    line = line.strip()
    for char in line:
        if number not in invalid[char]:
            number += movements[char]
    code.append(number)

f.close()

code = [str(digit) for digit in code]
print ''.join(code)

