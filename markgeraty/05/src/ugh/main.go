package main

import (
	"crypto/md5"
	"encoding/hex"
	"fmt"
	"strconv"
	"strings"
)

func main() {
	doorId := "reyedfim"
	prefix := "00000"

	fmt.Println(doorId)

	index := 0
	partOne := ""
	var partTwo [8]string

	for i := 0; i < 8; i++ {
		partTwo[i] = "answerme"
	}
	partTwoFound := 0

	for partTwoFound < 8 {
		data := []byte(doorId + strconv.Itoa(index))
		checksum := md5.Sum(data)
		checksumString := hex.EncodeToString(checksum[:])
		if strings.HasPrefix(checksumString, prefix) {
			if len(partOne) < 8 {
				partOne = partOne + string(checksumString[5])
			}

			// part two logic
			position, _ := hex.DecodeString("0" + checksumString[5:6])

			if position[0] <= 7 {
				if partTwo[position[0]] == "answerme" {
					partTwo[position[0]] = checksumString[6:7]
					partTwoFound++
				}
			}
		}

		index++
	}

	fmt.Println(partOne)
	fmt.Println(strings.Join(partTwo[:], ""))
}
