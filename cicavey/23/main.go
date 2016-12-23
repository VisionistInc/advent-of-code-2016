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
		case "tgl":
			val := bc.decodeValue(s[1])
			tip := bc.ip + val
			bc.ip++
			if tip < 0 || tip >= len(bc.code) {
				break
			}
			tgt := bc.code[tip]
			switch tgt[:3] {
			case "tgl":
				tgt = "inc" + tgt[3:]
			case "cpy":
				tgt = "jnz" + tgt[3:]
			case "inc":
				tgt = "dec" + tgt[3:]
			case "dec":
				tgt = "inc" + tgt[3:]
			case "jnz":
				tgt = "cpy" + tgt[3:]
			}
			bc.code[tip] = tgt
		case "cpy":
			bc.ip++
			val := bc.decodeValue(s[1])
			dr := s[2]
			if _, ok := bc.regs[dr]; !ok {
				break
			}
			bc.regs[dr] = val
		case "inc":
			bc.ip++
			if _, ok := bc.regs[s[1]]; !ok {
				break
			}
			bc.regs[s[1]]++
		case "dec":
			bc.ip++
			if _, ok := bc.regs[s[1]]; !ok {
				break
			}
			bc.regs[s[1]]--
		case "jnz":
			val := bc.decodeValue(s[1])
			if val != 0 {
				offset := bc.decodeValue(s[2])
				bc.ip += offset
			} else {
				bc.ip++
			}

		}

		bc.ec++

		if bc.ec%1000000 == 0 {
			fmt.Println(bc.ec)
		}
	}
}

func main() {

	bc := NewBunnyMachine(12, 0, 0, 0)

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
