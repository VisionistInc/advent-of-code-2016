package main

import "fmt"

func dragon(a string, size int) string {

	for len(a) < size {
		b := make([]byte, size, size)
		for i, c := range a {
			if c == '0' {
				b[len(a)-i-1] = 49
			} else {
				b[len(a)-i-1] = 48
			}
		}
		a = a + "0" + string(b[:len(a)])
	}
	return a[:size]
}

func checksum(a string) string {

	b := make([]byte, len(a)>>1)

	for len(a)%2 == 0 {
		for i := 0; i < len(a); i += 2 {
			if a[i:i+1] == a[i+1:i+2] {
				b[i>>1] = 49
			} else {
				b[i>>1] = 48
			}
		}
		a = string(b[:len(a)>>1])
	}

	return a
}

func main() {
	fmt.Println(checksum(dragon("11110010111001001", 272)))
	fmt.Println(checksum(dragon("11110010111001001", 35651584)))
}
