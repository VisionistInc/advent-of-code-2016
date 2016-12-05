package main

import (
	"crypto/md5"
	"encoding/hex"
	"fmt"
	"os"
	"strconv"
	"strings"
)

func pass1(count int, password []byte, hexSum string) bool {
	password[count] = []byte(hexSum[5:6])[0]
	return true
}

func pass2(count int, password []byte, hexSum string) bool {
	posValue, _ := hex.DecodeString("0" + hexSum[5:6])
	pos := posValue[0]
	value := []byte(hexSum[6:7])[0]

	if pos > 7 {
		return false
	}

	if password[pos] != 32 {
		return false
	}

	password[pos] = value

	return true
}

func main() {

	passFunc := pass1
	if len(os.Args) >= 2 && os.Args[1] == "2" {
		passFunc = pass2
	}

	door := "cxdnnyjw"
	password := make([]byte, 8)
	for i := range password {
		password[i] = 32
	}

	for counter, pwcount := 0, 0; pwcount < 8; counter++ {
		sumBytes := md5.Sum([]byte(door + strconv.Itoa(counter)))
		sumStr := hex.EncodeToString(sumBytes[:])
		if strings.HasPrefix(sumStr, "00000") {
			if passFunc(pwcount, password, sumStr) {
				fmt.Println(string(password))
				pwcount++
			}
		}
	}
	fmt.Println(string(password))
}
