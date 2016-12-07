package main

import (
	"bufio"
	"fmt"
	"os"
	"sort"
	"strconv"
	"strings"
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
	if p[i].Value == p[j].Value {
		return p[i].Key > p[j].Key
	}
	return p[i].Value < p[j].Value
}
func (p PairList) Swap(i, j int) {
	p[i], p[j] = p[j], p[i]
}

func stringHistogram(s string) map[string]int {
	h := make(map[string]int)
	for _, c := range s {
		count := h[string(c)]
		h[string(c)] = count + 1
	}
	return h
}

func computeChecksum(s string) string {
	hist := stringHistogram(s)

	var pairs PairList

	for k, v := range hist {
		pairs = append(pairs, Pair{k, v})
	}

	sort.Sort(sort.Reverse(pairs))

	var sum string

	for _, p := range pairs[0:5] {
		sum += p.Key
	}

	return sum
}

func decrypt(name string, sectorID int) string {
	sectorMod := byte(sectorID % 26)

	ascii := []byte(name)

	for i := range ascii {
		if ascii[i] == 32 {
			continue
		}
		ascii[i] += sectorMod
		if ascii[i] > 122 {
			ascii[i] -= 26
		}
	}

	return string(ascii)
}

func main() {
	total := 0
	r, _ := os.Open("input")
	scanner := bufio.NewScanner(r)
	for scanner.Scan() {
		tokens := strings.Split(scanner.Text(), "-")

		lastToken := strings.Split(tokens[len(tokens)-1], "[")

		sectorID, _ := strconv.Atoi(lastToken[0])
		checksum := lastToken[1][0 : len(lastToken[1])-1]
		name := strings.Join(tokens[0:len(tokens)-1], " ")
		compCheckSum := computeChecksum(strings.Join(tokens[0:len(tokens)-1], ""))

		if checksum == compCheckSum {
			total += sectorID
			name = decrypt(name, sectorID)
			if strings.Index(name, "north") != -1 {
				fmt.Println(name, sectorID)
			}
		}
	}

	fmt.Println(total)
}
