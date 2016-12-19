package main

import "fmt"

/*
Then, a new tile is a trap only in one of the following situations:

Its left and center tiles are traps, but its right tile is not.
Its center and right tiles are traps, but its left tile is not.
Only its left tile is a trap.
Only its right tile is a trap.
*/

func trap(i int, src string) bool {
	if i < 0 {
		return false
	}
	if i >= len(src) {
		return false
	}

	if src[i] == '^' {
		return true
	}

	return false

}

func next(seed string) string {
	n := ""
	for i := 0; i < len(seed); i++ {

		l := trap(i-1, seed)
		c := trap(i, seed)
		r := trap(i+1, seed)

		trap := false
		if l && c && !r {
			trap = true
		} else if !l && c && r {
			trap = true
		} else if l && !c && !r {
			trap = true
		} else if !l && !c && r {
			trap = true
		}

		if trap {
			n += "^"
		} else {
			n += "."
		}

	}
	return n
}

func numsafe(line string) int {
	cnt := 0
	for _, c := range line {
		if c == '.' {
			cnt++
		}
	}
	return cnt
}

func main() {
	nrow := 400000
	seed := "^.....^.^^^^^.^..^^.^.......^^..^^^..^^^^..^.^^.^.^....^^...^^.^^.^...^^.^^^^..^^.....^.^...^.^.^^.^"

	ns := 0
	for i := 0; i < nrow; i++ {
		ns += numsafe(seed)
		seed = next(seed)
	}

	fmt.Println(ns)

}
