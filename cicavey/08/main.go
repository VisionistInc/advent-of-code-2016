package main

import (
	"bufio"
	"fmt"
	"os"
	"strconv"
	"strings"
)

type display struct {
	pixels [][]bool
	w, h   int
}

func newDisplay(w, h int) *display {
	d := display{w: w, h: h}
	d.pixels = make([][]bool, h)
	for y := 0; y < h; y++ {
		d.pixels[y] = make([]bool, w)
	}
	return &d
}

func (d *display) rect(w, h int) {
	for y := 0; y < h; y++ {
		for x := 0; x < w; x++ {
			d.pixels[y][x] = true
		}
	}
}

func (d *display) rotateRow(rowIdx, val int) {
	row := d.pixels[rowIdx]
	si := d.w - (val % d.w)
	newRow := make([]bool, d.w)
	for x := 0; x < d.w; x++ {
		newRow[x] = row[(si+x)%d.w]
	}
	d.pixels[rowIdx] = newRow
}

func (d *display) rotateCol(col, val int) {
	si := d.h - (val % d.h)
	newCol := make([]bool, d.h)
	for y := 0; y < d.h; y++ {
		newCol[y] = d.pixels[(si+y)%d.h][col]
	}
	for y := 0; y < d.h; y++ {
		d.pixels[y][col] = newCol[y]
	}

}

func (d display) print() {
	for y := 0; y < d.h; y++ {
		row := d.pixels[y]
		for x := 0; x < d.w; x++ {
			if row[x] {
				fmt.Print("#")
			} else {
				fmt.Print(".")
			}
		}
		fmt.Println()
	}
}

func (d display) count() int {
	count := 0
	for y := 0; y < d.h; y++ {
		row := d.pixels[y]
		for x := 0; x < d.w; x++ {
			if row[x] {
				count++
			}
		}
	}
	return count
}

func main() {
	d := newDisplay(50, 6)
	r, _ := os.Open("input")
	scanner := bufio.NewScanner(r)
	for scanner.Scan() {
		l := scanner.Text()
		if strings.HasPrefix(l, "rect") {
			vals := strings.Split(l[5:], "x")
			w, _ := strconv.Atoi(vals[0])
			h, _ := strconv.Atoi(vals[1])
			d.rect(w, h)
		} else if strings.HasPrefix(l, "rotate row") {
			vals := strings.Split(l[13:], " by ")
			row, _ := strconv.Atoi(vals[0])
			by, _ := strconv.Atoi(vals[1])
			d.rotateRow(row, by)

		} else if strings.HasPrefix(l, "rotate column") {
			vals := strings.Split(l[16:], " by ")
			col, _ := strconv.Atoi(vals[0])
			by, _ := strconv.Atoi(vals[1])
			d.rotateCol(col, by)
		}
	}
	d.print()
	fmt.Println(d.count())
}
