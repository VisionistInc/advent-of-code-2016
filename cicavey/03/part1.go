package main

import (
	"bufio"
	"fmt"
	"os"
	"regexp"
	"strconv"
)

type tri [3]int64

func (t tri) Valid() bool {
	return (t[0]+t[1] > t[2]) && (t[1]+t[2] > t[0]) && (t[2]+t[0] > t[1])
}

var re = regexp.MustCompile("\\d+")

func convertLine(l string) [3]int64 {

	s := re.FindAllString(l, -1)
	var tri [3]int64
	for i := 0; i < 3; i++ {
		v, _ := strconv.ParseInt(s[i], 10, 32)
		tri[i] = v
	}

	return tri
}

func main() {

	valid := 0

	r, _ := os.Open("input")
	scanner := bufio.NewScanner(r)
	for scanner.Scan() {

		row0 := convertLine(scanner.Text())

		if tri(row0).Valid() {
			valid++
		}
	}

	fmt.Println(valid)
}
