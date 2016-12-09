package main

import (
	"bufio"
	"bytes"
	"fmt"
	"io"
	"os"
	"strconv"
	"strings"
)

func decompress(r io.Reader, nest bool, level int) int {
	output := 0
	br := bufio.NewReader(r)
	for {
		copy, err := br.ReadBytes('(')
		if err != nil {
			if err == io.EOF {
				output += len(copy)
				return output
			}
			fmt.Println(err)
		}

		// Backup pointer by '('
		br.UnreadByte()

		// Copy 'copy' to output
		output += len(copy) - 1

		cmd, err := br.ReadBytes(')')
		cmd = cmd[1 : len(cmd)-1]
		if err != nil {
			fmt.Println(err)
		}
		cmdS := strings.Split(string(cmd), "x")
		size, _ := strconv.Atoi(cmdS[0])
		rep, _ := strconv.Atoi(cmdS[1])

		// Read the next SIZE chars and repeat REP times
		repBytes := make([]byte, size)
		io.ReadFull(br, repBytes)

		if !nest {
			output += rep * size
			continue
		}

		// Nested compress

		// Optimization - no need to nest as there are no subsequences
		if !bytes.ContainsAny(repBytes, "(") {
			output += rep * size
			continue
		}

		output += rep * decompress(bytes.NewReader(repBytes), true, level+1)
	}
}

func main() {
	nest := false
	if len(os.Args) >= 2 && os.Args[1] == "2" {
		nest = true
	}
	r, _ := os.Open("input")
	fmt.Println(decompress(r, nest, 0))
}
