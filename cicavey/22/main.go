package main

import (
	"bufio"
	"fmt"
	"os"
	"strconv"
	"strings"
)

type node struct {
	x, y              int
	size, used, avail int
}

func (a *node) viable(b *node) bool {
	if a == b {
		return false
	}
	if a.used == 0 {
		return false
	}
	return b.avail >= a.used
}

func main() {

	var grid [33][30]*node
	var nodes []*node

	r, _ := os.Open("input")
	scanner := bufio.NewScanner(r)
	for scanner.Scan() {
		line := scanner.Text()
		if !strings.HasPrefix(line, "/") {
			continue
		}

		s := strings.Fields(line)

		n := strings.Split(s[0], "-")

		x, _ := strconv.Atoi(n[1][1:])
		y, _ := strconv.Atoi(n[2][1:])

		size, _ := strconv.Atoi(s[1][:len(s[1])-1])
		used, _ := strconv.Atoi(s[2][:len(s[2])-1])
		avail, _ := strconv.Atoi(s[3][:len(s[3])-1])

		node := &node{x, y, size, used, avail}

		grid[x][y] = node
		nodes = append(nodes, node)
	}

	cnt := 0
	// Check for pairs
	for i := 0; i < len(nodes); i++ {
		for j := 0; j < len(nodes); j++ {
			if nodes[i].viable(nodes[j]) {
				cnt++
			}
		}
	}

	fmt.Println(cnt)

	for y := 0; y < 30; y++ {
		for x := 0; x < 33; x++ {
			n := grid[x][y]

			if x == 0 && y == 0 {
				fmt.Print("E")
			} else if x == 32 && y == 0 {
				fmt.Print("G")
			} else if n.used == 0 {
				fmt.Print("_")
			} else if n.size > 100 {
				fmt.Print("#")
			} else {
				fmt.Print(".")
			}
		}
		fmt.Println()
	}
	fmt.Println("Solve by hand. Fail. 49 moves to start pattern, 5*31 moves, 1 move to finsh = 205")
}
