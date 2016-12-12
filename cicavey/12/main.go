package main

import (
	"bufio"
	"fmt"
	"os"
	"strconv"
	"strings"
)

type BunnyMachine struct {
	regs map[string]int
	code []string
	ip   int
	ec   int
}

func NewBunnyMachine(a, b, c, d int) *BunnyMachine {
	bc := BunnyMachine{
		regs: map[string]int{
			"a": a,
			"b": b,
			"c": c,
			"d": d,
		},
	}
	return &bc
}

func (bc *BunnyMachine) load(code []string) {
	bc.code = code
}

func (bc *BunnyMachine) decodeValue(v string) int {
	val, ok := bc.regs[v]
	if !ok {
		val, _ = strconv.Atoi(v)
	}
	return val
}

func (bc *BunnyMachine) run() {
	// Execute
	bc.ec = 0
	bc.ip = 0
	for bc.ip < len(bc.code) {

		ins := bc.code[bc.ip]

		//fmt.Printf("%06d:%02d %4d %4d %4d %4d %s", bc.ec, bc.ip, bc.regs["a"], bc.regs["b"], bc.regs["c"], bc.regs["d"], ins)

		s := strings.Split(ins, " ")

		switch s[0] {
		case "cpy":
			sr := s[1]
			val := bc.decodeValue(sr)
			dr := s[2]
			bc.regs[dr] = val
			bc.ip++
		case "inc":
			bc.regs[s[1]]++
			bc.ip++
		case "dec":
			bc.regs[s[1]]--
			bc.ip++
		case "jnz":
			r := s[1]
			val := bc.decodeValue(r)

			//fmt.Print(" val=", val)

			if val != 0 {
				offset, _ := strconv.Atoi(s[2])
				bc.ip += offset
			} else {
				bc.ip++
			}

		}
		//fmt.Println()

		bc.ec++

		if bc.ec%100000 == 0 {
			fmt.Println(bc.ec)
		}

		//if bc.ec > 1000000 {
		// break
		//}

	}
}

func main() {

	bc := NewBunnyMachine(0, 0, 1, 0)

	var code []string

	r, _ := os.Open("input")
	scanner := bufio.NewScanner(r)
	for scanner.Scan() {
		code = append(code, scanner.Text())
	}

	bc.load(code)
	bc.run()

	fmt.Println(bc.ec, bc.regs)
}
