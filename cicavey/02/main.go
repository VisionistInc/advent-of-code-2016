package main

import (
	"bufio"
	"fmt"
	"os"
	"strings"
)

func main() {
	if len(os.Args) < 3 {
		fmt.Println("Usage: <keypadfile> <inputfile>")
		os.Exit(-1)
	}
	dirIdxMap := map[string]int{
		"U": 0,
		"D": 1,
		"L": 2,
		"R": 3,
	}

	// Read keypad file - Creates a graph of the keypad
	keypad := map[string][4]string{}
	r, _ := os.Open(os.Args[1])
	scanner := bufio.NewScanner(r)
	for scanner.Scan() {
		adjRow := strings.Split(scanner.Text(), ",")
		r := [4]string{}
		copy(r[:], adjRow[1:])
		keypad[adjRow[0]] = r
	}

	pos := "5"
	code := ""

	r, _ = os.Open(os.Args[2])
	scanner = bufio.NewScanner(r)
	for scanner.Scan() {
		for _, d := range scanner.Text() {
			npos := keypad[pos][dirIdxMap[string(d)]]
			if npos != "_" {
				pos = npos
			}
		}
		code += pos
	}
	fmt.Println(code)
}
