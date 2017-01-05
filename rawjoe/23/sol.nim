import strutils

const startval = 7
# const startval = 12

# chars represent instructions
const cpy = 'c'
const inc = 'i'
const dec = 'd'
const jnz = 'j'
const tgl = 't'

type
    Inst* = object
        # opcode
        op: char
        # parameters
        p1, p2: int
        # if true, corresponding param is register, otherwise literal
        f1, f2: bool
        # the actual val each param represents (either register val or literal)
        p1val, p2val: int

var
    # our registers a,b,c,d
    reg    = @[startval,0,0,0]

    code = newSeq[Inst](0)
    inst: Inst

for line in lines "input":

    var
        params = line.split(Whitespace)
        val: int

    # if nothing in line
    if params.len() == 0:
        continue

    inst = Inst(op: params[0][0], p1: 0, p2: 0, f1: false, f2: false)

    try:
        # try to parse second value as int
        val = parseInt params[1]
    except ValueError:
        # parsing failed, so it's a reg, subtract off ascii value for a
        inst.f1 = true
        val = ord(params[1][0]) - 97
    inst.p1 = val

    if params.len() < 3:
        code.add(inst)
        continue

    try:
        # try to parse third value as int
        val = parseInt params[2]
    except ValueError:
        # parsing failed, so it's a reg, subtract off ascii value for a
        inst.f2 = true
        val = ord(params[2][0]) - 97
    inst.p2 = val

    code.add(inst)

# set program counter to 0
var pc = 0

while pc < code.len():
    # extract current instruction
    inst = code[pc]

    if inst.f1:
        inst.p1val = reg[inst.p1]
    else:
        inst.p1val = inst.p1

    if inst.f2:
        inst.p2val = reg[inst.p2]
    else:
        inst.p2val = inst.p2

    # handle toggle
    if inst.op == tgl:
        var loc = pc + inst.p1val

        # if the instruction we are modifying is within the code
        if (loc >= 0) and (loc < code.len()):
            if code[loc].op == inc:
                code[loc].op = dec
            elif (code[loc].op == dec) or (code[loc].op == tgl):
                code[loc].op = inc
            elif code[loc].op == jnz:
                code[loc].op = cpy
            else:
                code[loc].op = jnz

    # handle copy only if second parameter is a register
    if (inst.op == cpy) and inst.f2:
        reg[inst.p2] = inst.p1val

    # handle increment only if first parameter is a register
    if (inst.op == inc) and inst.f1:
        reg[inst.p1] += 1

    # handle decrement only if first parameter is a register
    if (inst.op == dec) and inst.f1:
        reg[inst.p1] -= 1

    # handle jnz if p1 is not zero
    if (inst.op == jnz) and (inst.p1val != 0):
        # note that 1 is added to pc at bottom of loop
        # so we should add 1 less here
        pc += (inst.p2val - 1)

    pc += 1

echo reg
