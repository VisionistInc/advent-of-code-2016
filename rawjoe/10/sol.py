from collections import defaultdict
tokens = defaultdict(list)
output = defaultdict(list)


cmds = [cmd.rstrip('\n') for cmd in open('input')]

while len(cmds) > 1:
    for cmd in cmds:
        # handle value case
        if cmd.startswith('value '):
            params = cmd.split(' ')
            val = params[1]
            bot = params[5]
            tokens[bot].append(val)
            if len(tokens[bot]) > 2:
                print("!!!!!!! MORE THAN 2 TOKENS!!!!!!")
            cmds.remove(cmd)
            break
        # handle bot case
        if cmd.startswith('bot '):
            params = cmd.split(' ')
            src = params[1]
            if len(tokens[src]) == 2:
                lowtype = params[5]
                lowdest = params[6]
                hightype = params[10]
                highdest = params[11]
                low = tokens[src].pop()
                high = tokens[src].pop()
                if int(high) < int(low):
                    tmp = low
                    low = high
                    high = tmp
                if lowtype == 'output':
                    output[lowdest].append(low)
                else:
                    tokens[lowdest].append(low)
                if hightype == 'output':
                    output[highdest].append(high)
                else:
                    tokens[highdest].append(high)
                cmds.remove(cmd)
                
                if low == '17' and high == '61':
                    print(src)
                break

print((int(output['0'].pop()) * int(output['1'].pop()) * int(output['2'].pop())))
