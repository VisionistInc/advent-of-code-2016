package main

import (
	"bufio"
	"fmt"
	"os"
	"sort"
)

type Pair struct {
	Key   string
	Value int
}
type PairList []Pair

func (p PairList) Len() int {
	return len(p)
}
func (p PairList) Less(i, j int) bool {
	return p[i].Value < p[j].Value
}
func (p PairList) Swap(i, j int) {
	p[i], p[j] = p[j], p[i]
}

func order(hist map[string]int, rev bool) string {
	var pairs PairList

	for k, v := range hist {
		pairs = append(pairs, Pair{k, v})
	}

	if !rev {
		sort.Sort(sort.Reverse(pairs))
	} else {
		sort.Sort(pairs)
	}

	if len(pairs) > 0 {
		return pairs[0].Key
	}

	return ""
}

func main() {
	least := false
	if len(os.Args) >= 2 && os.Args[1] == "2" {
		least = true
	}

	phist := make([]map[string]int, 8)
	for i := 0; i < 8; i++ {
		phist[i] = make(map[string]int)
	}

	r, _ := os.Open("input")
	scanner := bufio.NewScanner(r)
	for scanner.Scan() {
		for i, c := range scanner.Text() {
			phist[i][string(c)] = phist[i][string(c)] + 1
		}
	}

	// convert each
	for _, c := range phist {
		fmt.Print(order(c, least))
	}
	fmt.Println()
}
