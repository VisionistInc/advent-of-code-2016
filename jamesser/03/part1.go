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
		strs := scanner.Text()
		a, e := strconv.Atoi(strings.TrimSpace(strs[0:5]))
		b, e := strconv.Atoi(strings.TrimSpace(strs[5:10]))
		c, e := strconv.Atoi(strings.TrimSpace(strs[10:15]))
		fmt.Printf("%d %d %d \n", a, b, c)
		
		if e != nil {
		}
		
		if a + b > c && b + c > a && c + a > b {
			valid = valid + 1
		}
	}
	fmt.Print(valid)
}
