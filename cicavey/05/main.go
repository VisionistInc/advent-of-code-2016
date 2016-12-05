package main

import (
	"crypto/md5"
	"encoding/hex"
	"fmt"
	"strconv"
	"strings"
)

func main() {
	door := "cxdnnyjw"
	var password string
	for counter := 0; len(password) < 8; counter++ {
		sumBytes := md5.Sum([]byte(door + strconv.Itoa(counter)))
		sumStr := hex.EncodeToString(sumBytes[:])
		if strings.HasPrefix(sumStr, "00000") {
			password += sumStr[5:6]
		}
	}
	fmt.Println(password)
}
