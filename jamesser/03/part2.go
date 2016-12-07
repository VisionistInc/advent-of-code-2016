package main

import "fmt"
import "os"
import "bufio"
import "strconv"
import "strings"

func main() {
	file, err := os.Open(os.Args[1])

	if err != nil {
	}

	defer file.Close()
	valid := 0
	scanner := bufio.NewScanner(file)
	for scanner.Scan() {
		strs1 := scanner.Text()
		scanner.Scan()
		strs2 := scanner.Text()
		scanner.Scan()
		strs3 := scanner.Text()

		a1, e := strconv.Atoi(strings.TrimSpace(strs1[0:5]))
		b1, e := strconv.Atoi(strings.TrimSpace(strs1[5:10]))
		c1, e := strconv.Atoi(strings.TrimSpace(strs1[10:15]))

		a2, e := strconv.Atoi(strings.TrimSpace(strs2[0:5]))
		b2, e := strconv.Atoi(strings.TrimSpace(strs2[5:10]))
		c2, e := strconv.Atoi(strings.TrimSpace(strs2[10:15]))

		a3, e := strconv.Atoi(strings.TrimSpace(strs3[0:5]))
		b3, e := strconv.Atoi(strings.TrimSpace(strs3[5:10]))
		c3, e := strconv.Atoi(strings.TrimSpace(strs3[10:15]))
		
		if e != nil {
		}
		
		if a1 + a2 > a3 && a1 + a3 > a2 && a2 + a3 > a1 {
			valid = valid + 1
		}

		if b1 + b2 > b3 && b1 + b3 > b2 && b2 + b3 > b1 {
			valid = valid + 1
		}
		if c1 + c2 > c3 && c1 + c3 > c2 && c2 + c3 > c1 {
			valid = valid + 1
		}
	}
	fmt.Print(valid)
}
