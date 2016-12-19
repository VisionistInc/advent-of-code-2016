package main

import "fmt"

func part1(l int) int {

	e := make([]int, l)

	for i := 0; i < l; i++ {
		e[i] = 1
	}

	i := 0
	for {

		if e[i] == 0 {
			i = (i + 1) % l
			continue
		}

		j := -1
		for k := 1; k < l; k++ {
			if e[(i+k)%l] != 0 {
				j = (i + k) % l
				break
			}
		}
		if j == -1 {
			break
		}

		e[i] = e[i] + e[j]
		e[j] = 0

		i = (i + 1) % l
	}

	for i := 0; i < l; i++ {
		if e[i] != 0 {
			return i + 1
		}
	}

	return -1
}

type elf struct {
	id   int
	prev *elf
	next *elf
}

func part2(l int) int {

	root := &elf{1, nil, nil}
	cur := root
	var mid *elf

	// est linked list
	for i := 1; i < l; i++ {
		cur.next = &elf{i + 1, cur, nil}
		cur = cur.next

		if i == l/2 {
			mid = cur
		}
	}
	root.prev = cur
	cur.next = root

	count := l
	cur = root
	for cur.next != cur.prev {

		// track mid so we're not searching
		mid.next.prev = mid.prev
		mid.prev.next = mid.next
		// advance mid
		mid = mid.next
		count--
		// left/right is like rounding down so we skip if even (round up)
		if count%2 == 0 {
			mid = mid.next
		}
		cur = cur.next
	}

	return cur.id
}

func main() {
	l := 3001330
	fmt.Println(part1(l))
	fmt.Println(part2(l))
}
