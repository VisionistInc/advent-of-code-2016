package main

import "fmt"

const (
	magic = 1350
)

const (
	m1q uint64 = 0x5555555555555555
	m2q        = 0x3333333333333333
	m4q        = 0x0f0f0f0f0f0f0f0f
	hq         = 0x0101010101010101
)

func countBits(x uint64) int {
	x -= (x >> 1) & m1q
	x = (x & m2q) + ((x >> 2) & m2q)
	x = (x + (x >> 4)) & m4q
	return int((x * hq) >> 56)
}

func isOpen(x, y int) bool {
	val := uint64(x*x + 3*x + 2*x*y + y + y*y)
	val += magic
	return countBits(val)%2 == 0
}

type P struct {
	x, y int
}

func (p P) isValid() bool {
	if p.x < 0 || p.y < 0 {
		return false
	}
	return isOpen(p.x, p.y)
}

type Q struct {
	q []P
}

func (q *Q) Push(p P) {
	q.q = append(q.q, p)
}

func (q *Q) Pop() P {
	p := q.q[0]
	q.q = q.q[1:]
	return p
}

func main() {

	moveX := []int{0, 1, 0, -1}
	moveY := []int{1, 0, -1, 0}

	q := Q{}
	dist := make(map[P]int)

	start := P{1, 1}
	goal := P{31, 39}

	q.Push(start)
	dist[start] = 0

	for len(q.q) > 0 {
		p := q.Pop()
		pDist := dist[p]

		for m := 0; m < 4; m++ {
			np := P{p.x + moveX[m], p.y + moveY[m]}

			if !np.isValid() {
				continue
			}

			if dist[np] == 0 {
				q.Push(np)
				dist[np] = pDist + 1
			}
		}

		// Limit - HACK - this is enough to solve and calculate all distances
		if len(q.q) > 10000 {
			break
		}
	}

	count := 0
	for _, d := range dist {
		if d <= 50 {
			count++
		}
	}

	fmt.Println("Goal distance: ", dist[goal])
	fmt.Println("All points within 50:", count)
}
