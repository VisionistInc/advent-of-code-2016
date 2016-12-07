package main

import (
	"bufio"
	"fmt"
	"os"
	"strings"
)

func hasABBA(s string) bool {
	if len(s) < 4 {
		return false
	}
	// Check for "ABBA"
	for i := 0; i < len(s)-3; i++ {
		if s[i] != s[i+1] && s[i] == s[i+3] && s[i+1] == s[i+2] {
			return true
		}
	}
	return false
}

func extractABA(s string) []string {

	aba := []string{}

	if len(s) < 3 {
		return aba
	}

	// Check for "ABA"
	for i := 0; i < len(s)-2; i++ {
		if s[i] != s[i+1] && s[i] == s[i+2] {
			aba = append(aba, s[i:i+3])
		}
	}

	return aba
}

func convertABAtoBAB(aba string) string {
	return aba[1:2] + aba[0:1] + aba[1:2]
}

type ipv7 struct {
	value    string
	tls      bool
	ssl      bool
	supernet []string
	hypernet []string
}

func (addr *ipv7) parse() {
	nextToken := 0
	tokens := []string{"[", "]"}
	l := addr.value
	for i := 0; i < len(l); {
		j := strings.Index(l[i:], tokens[nextToken])
		nextToken = (nextToken + 1) % len(tokens)
		if j == -1 {
			j = len(l) - i
		}

		value := strings.TrimSpace(l[i : i+j])

		if nextToken == 0 { // inside of brackets
			addr.hypernet = append(addr.hypernet, value)
		} else {
			addr.supernet = append(addr.supernet, value)
		}

		i = i + j + 1
	}

	// Check for TLS

	addr.tls = supportsTLS(addr)

	// Check for SSL
	addr.ssl = supportsSSL(addr)
}

func supportsSSL(addr *ipv7) bool {
	for _, v := range addr.supernet {
		abas := extractABA(v)
		for _, aba := range abas {
			bab := convertABAtoBAB(aba)
			for _, hn := range addr.hypernet {
				if strings.Index(hn, bab) != -1 {
					return true
				}
			}
		}
	}

	return false
}

func supportsTLS(addr *ipv7) bool {
	// update tls flag
	for _, v := range addr.hypernet {
		if hasABBA(v) {
			return false
		}
	}
	for _, v := range addr.supernet {
		if hasABBA(v) {
			return true
		}
	}
	return false
}

func newIPv7(s string) *ipv7 {
	addr := &ipv7{value: s}
	addr.parse()
	return addr
}

func main() {
	tlsCount := 0
	sslCount := 0
	r, _ := os.Open("input")
	scanner := bufio.NewScanner(r)
	for scanner.Scan() {
		ip := newIPv7(scanner.Text())
		if ip.tls {
			tlsCount++
		}
		if ip.ssl {
			sslCount++
		}
	}

	fmt.Println(tlsCount, sslCount)

}
