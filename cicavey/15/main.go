package main

import (
	"bufio"
	"fmt"
	"os"
	"regexp"
	"strconv"
)

type disc struct {
	npos int
	pos  int
	opos int
}

func (d *disc) reset() {
	d.pos = d.opos
}

func (d *disc) turn() {
	d.pos = (d.pos + 1) % d.npos
}

func (d *disc) next() int {
	return (d.pos + 1) % d.npos
}

func main() {
	var validID = regexp.MustCompile("^Disc #(\\d+) has (\\d+) positions; at time=(\\d+), it is at position (\\d+).$")

	var discs []*disc

	r, _ := os.Open("input")
	scanner := bufio.NewScanner(r)
	for scanner.Scan() {
		// Disc #1 has 17 positions; at time=0, it is at position 1.
		sm := validID.FindAllStringSubmatch(scanner.Text(), -1)

		//id, _ := strconv.Atoi(sm[0][1])
		npos, _ := strconv.Atoi(sm[0][2])
		//t, _ := strconv.Atoi(sm[0][3])
		spos, _ := strconv.Atoi(sm[0][4])

		//fmt.Println(disc, npos, t, spos)
		discs = append(discs, &disc{npos, spos, spos})
	}

	capsule := 0
	dt := 0

	for t := 0; t < 1000000; t++ {

		if discs[capsule].next() == 0 {
			capsule++
			if capsule >= len(discs) {
				break
			}
		} else {
			capsule = 0
			dt = t + 1
		}

		for _, d := range discs {
			d.turn()
		}
	}

	fmt.Println(dt)

	for _, d := range discs {
		d.reset()
	}
	discs = append(discs, &disc{11, 0, 0})

	capsule = 0
	dt = 0

	for t := 0; t < 10000000; t++ {

		if discs[capsule].next() == 0 {
			capsule++
			if capsule >= len(discs) {
				break
			}
		} else {
			capsule = 0
			dt = t + 1
		}

		for _, d := range discs {
			d.turn()
		}
	}

	fmt.Println(dt)
}
