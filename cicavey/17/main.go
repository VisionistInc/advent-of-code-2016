package main

import (
	"crypto/md5"
	"encoding/hex"
	"fmt"
)

/*
#########
#S| | | #
#-#-#-#-#
# | | | #
#-#-#-#-#
# | | | #
#-#-#-#-#
# | | |
####### V
*/

type State struct {
	x, y int
	path string
}

func main() {

	seed := "hijkl"
	s := State{0, 0, ""}

	byteSum := md5.Sum([]byte(seed + s.path))
	hexSum := hex.EncodeToString(byteSum[:])[:4]

	openU := []byte(hexSum)[0] >= 98
	openD := []byte(hexSum)[1] >= 98
	openL := []byte(hexSum)[2] >= 98
	openR := []byte(hexSum)[3] >= 98

	fmt.Println(openU, openD, openL, openR)

}
