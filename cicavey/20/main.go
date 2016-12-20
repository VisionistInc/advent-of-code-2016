package main

import (
	"bufio"
	"fmt"
	"os"
	"sort"
	"strconv"
	"strings"
)

type seg struct {
	l, u int64
}

func (s *seg) overlaps(s2 *seg) bool {
	return s.u+1 >= s2.l
}

type seglist []*seg

func (p seglist) Len() int {
	return len(p)
}
func (p seglist) Less(i, j int) bool {
	return p[i].l < p[j].l
}
func (p seglist) Swap(i, j int) {
	p[i], p[j] = p[j], p[i]
}

func min(a, b int64) int64 {
	if a < b {
		return a
	}
	return b
}

func max(a, b int64) int64 {
	if a > b {
		return a
	}
	return b
}

func main() {
	var sl seglist
	r, _ := os.Open("input")
	scanner := bufio.NewScanner(r)
	for scanner.Scan() {
		r := strings.Split(scanner.Text(), "-")
		lb, _ := strconv.ParseInt(r[0], 10, 64)
		ub, _ := strconv.ParseInt(r[1], 10, 64)
		if lb > ub {
			lb, ub = ub, lb
		}
		sl = append(sl, &seg{lb, ub})
	}
	sort.Sort(sl)
	merge := true
	for merge {
		var sl2 seglist
		merge = false
		for i := 0; i < len(sl)-1; i++ {
			if sl[i].overlaps(sl[i+1]) {
				sl2 = append(sl2, &seg{min(sl[i].l, sl[i+1].l), max(sl[i].u, sl[i+1].u)})
				merge = true
				i++
			} else {
				sl2 = append(sl2, sl[i])
				if i == len(sl)-2 {
					sl2 = append(sl2, sl[i+1])
				}
			}
		}
		sl = sl2
	}

	fmt.Println(sl[0].u + 1)

	var count2 int64
	for i := 0; i < len(sl)-1; i++ {
		fmt.Println(sl[i+1].l, sl[i].u)
		count2 += sl[i+1].l - sl[i].u - 1
	}
	count2++ // for the last bound
	fmt.Println(count2)

}
