package main

import (
	"crypto/md5"
	"encoding/hex"
	"fmt"
)

func findSeq(s string, size int, exact bool) (int, string) {
	for i := 0; i < len(s)-size+1; i++ {
		seq := true
		for j := 1; j < size; j++ {
			if s[i] != s[i+j] {
				seq = false
				break
			}
		}

		if exact {
			if i+size < len(s) && s[i] == s[i+size] {
				seq = false
			}

		}

		if seq {
			return i, s[i : i+size]
		}
	}
	return -1, ""
}

func hash(input []byte) []byte {
	output := md5.Sum(input)
	return output[:]
}

func hash2(input []byte) []byte {
	var temp [16]byte
	for i := 0; i < 2017; i++ {
		temp = md5.Sum(input)
		input = []byte(hex.EncodeToString(temp[:]))
	}
	return temp[:]
}

func main() {
	//salt := "abc"
	salt := "ahsbgdzn"

	keys := make(map[int]string)
	seqs := make(map[int]string)

	hf := hash2

	max := 25000
	for i := 0; i < max; i++ {
		sum := hf([]byte(fmt.Sprintf("%s%d", salt, i)))
		hex := hex.EncodeToString(sum)
		idx, _ := findSeq(hex, 3, true)
		if idx != -1 {
			keys[i] = hex
		}
		idx, _ = findSeq(hex, 5, false)
		if idx != -1 {
			seqs[i] = hex
		}
		if i%1000 == 0 {
			fmt.Println(i)
		}
	}

	count := 0
	for i := 0; i < max; i++ {
		key, ok := keys[i]
		if !ok {
			continue
		}
		_, seq := findSeq(key, 3, true)
		for j := 1; j < 1000; j++ {
			test, ok := seqs[i+j]
			if !ok {
				continue
			}
			idx, mseq := findSeq(test, 5, false)
			if idx == -1 {
				continue
			}

			if seq == mseq[0:3] {
				count++
				fmt.Println(i, seq, "in", test, i+j, count, key)
				break
			}
		}
		if count > 63 {
			break
		}
	}

}
