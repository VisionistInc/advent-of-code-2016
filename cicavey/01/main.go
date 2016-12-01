package main

import (
	"flag"
	"fmt"
	"io/ioutil"
	"log"
	"strconv"
	"strings"
)

const (
	N = iota
	E
	S
	W
)

func abs(a int) int {
	if a < 0 {
		return -a
	}
	return a
}

type point [2]int

func (p point) TaxiDistance() int {
	return abs(p[0]) + abs(p[1])
}

func main() {

	var svCheck = flag.Bool("s", false, "Check for second visit")

	flag.Parse()

	input, err := ioutil.ReadFile(flag.Args()[0])
	if err != nil {
		log.Fatal(err)
	}

	heading := N // "NESW"

	p := point{0, 0}

	loc := make(map[point]bool)
	loc[p] = true

	dirs := strings.Split(string(input), ",")

nav:
	for _, dir := range dirs {
		dir = strings.TrimSpace(dir)
		n, _ := strconv.Atoi(dir[1:])

		// Turning alters the heading by stepping/wrap through an imagined array of "NESW"
		switch dir[0:1] {
		case "L":
			heading--
			if heading < 0 {
				heading = 3
			}
		case "R":
			heading++
			if heading > 3 {
				heading = 0
			}
		}

		// which coordinate x|0 or y|1 to alter
		c := 0
		// Increment by
		v := 1
		switch heading {
		case N:
			c = 1
			v = 1
		case S:
			c = 1
			v = -1
		case E:
			c = 0
			v = 1
		case W:
			c = 0
			v = -1
		}

		// Step by increment in a direction, optionally checking previous locations
		for i := 0; i < n; i++ {
			p[c] += v

			if *svCheck && loc[p] {
				break nav
			}
			loc[p] = true
		}

	}

	fmt.Println(p.TaxiDistance())
}
