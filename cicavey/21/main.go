package main

import (
	"bufio"
	"fmt"
	"os"
	"strconv"
	"strings"
)

type scrambler struct {
	raw []byte
}

func NewScrambler(s string) scrambler {
	return scrambler{[]byte(s)}
}

func (scr *scrambler) swapPos(src, dst int) {
	scr.raw[src], scr.raw[dst] = scr.raw[dst], scr.raw[src]
}

func (scr *scrambler) swapLtr(src, dst string) {
	sB := []byte(src)[0]
	dB := []byte(dst)[0]

	for i := 0; i < len(scr.raw); i++ {
		if scr.raw[i] == sB {
			scr.raw[i] = dB
		} else if scr.raw[i] == dB {
			scr.raw[i] = sB
		}
	}
}

func (scr *scrambler) rev(s, e int) {
	temp := make([]byte, len(scr.raw))
	copy(temp, scr.raw)
	for i, j := s, e; i <= e; i++ {
		scr.raw[i] = temp[j]
		j--
	}
}

func (scr *scrambler) rot(s int, left bool) {
	l := len(scr.raw)
	startIdx := (s % l)
	if startIdx == 0 { // no need to rotate if the steps are multiple of length
		return
	}

	if !left {
		startIdx = l - startIdx
	}

	temp := make([]byte, l)
	copy(temp, scr.raw)

	for i := 0; i < l; i++ {
		scr.raw[i] = temp[(i+startIdx)%l]
	}
}

func (scr *scrambler) rotLeft(s int) {
	scr.rot(s, true)
}

func (scr *scrambler) rotRight(s int) {
	scr.rot(s, false)
}

func (scr *scrambler) move(src, dst int) {
	temp := make([]byte, len(scr.raw))
	tgt := scr.raw[src]
	copy(temp, scr.raw)
	temp = append(temp[:src], temp[src+1:]...)
	temp = append(temp[:dst], append([]byte{tgt}, temp[dst:]...)...)
	scr.raw = temp
}

func (scr *scrambler) rotLtr(s string) {
	idx := strings.Index(string(scr.raw), s)
	if idx == -1 {
		return
	}

	cnt := 1 + idx
	if idx >= 4 {
		cnt++
	}
	scr.rotRight(cnt)
}

func (scr scrambler) String() string {
	return string(scr.raw)
}

func main() {

	scr := NewScrambler("abcdefgh")
	/*
		s.swapPos(4, 0)
		s.swapLtr("d", "b")
		s.rev(0, 4)
		s.rot(1, true)
		s.move(1, 4)
		s.move(3, 0)
		s.rotLtr("b")
		s.rotLtr("d")
		fmt.Println(s)
	*/

	r, _ := os.Open("input")
	scanner := bufio.NewScanner(r)
	for scanner.Scan() {
		s := strings.Split(scanner.Text(), " ")
		switch s[0] {
		case "rotate":
			if s[1] == "based" {
				src := s[6]
				scr.rotLtr(src)
			} else {
				left := s[1] == "left"
				cnt, _ := strconv.Atoi(s[2])
				scr.rot(cnt, left)
			}
		case "swap":
			if s[1] == "position" {
				src, _ := strconv.Atoi(s[2])
				dst, _ := strconv.Atoi(s[5])
				scr.swapPos(src, dst)
			} else {
				src := s[2]
				dst := s[5]
				scr.swapLtr(src, dst)
			}
		case "reverse":
			start, _ := strconv.Atoi(s[2])
			end, _ := strconv.Atoi(s[4])
			scr.rev(start, end)
		case "move":
			src, _ := strconv.Atoi(s[2])
			dst, _ := strconv.Atoi(s[5])
			scr.move(src, dst)
		}
	}

	fmt.Println(scr)

}
