package main

import (
	"bufio"
	"fmt"
	"os"
	"strconv"
	"strings"
)

type Sink interface {
	Give(int)
}

type Output struct {
	id  int
	bin []int
}

func NewOutput(id int) *Output {
	o := &Output{id: id}
	return o
}

func (o *Output) Give(chip int) {
	o.bin = append(o.bin, chip)
}

type Bot struct {
	id    int
	lo    Sink
	hi    Sink
	chip1 int
	chip2 int
}

func (b *Bot) Give(chip int) {
	if b.chip1 == 0 {
		b.chip1 = chip
	} else if b.chip2 == 0 {
		b.chip2 = chip

		if (b.chip1 == 61 && b.chip2 == 17) || (b.chip1 == 17 && b.chip2 == 61) {
			fmt.Println("BOT", b.id, "is the target")
		}

		loV := b.chip1
		hiV := b.chip2
		if loV > hiV {
			loV, hiV = hiV, loV
		}
		b.chip1 = 0
		b.chip2 = 0
		if b.lo != nil {
			b.lo.Give(loV)
		} else {
			// output
		}
		if b.hi != nil {
			b.hi.Give(hiV)
		} else {
			//output
		}
	} else {
	}
}

func (b *Bot) Assign(lo, hi *Bot) {
	b.lo = lo
	b.hi = hi
}

type BotMap struct {
	bots map[int]*Bot
}

func NewBotMap() *BotMap {
	bm := BotMap{
		bots: make(map[int]*Bot),
	}
	return &bm
}

func (bm *BotMap) Get(id int) *Bot {
	bot := bm.bots[id]
	if bot == nil {
		bot = &Bot{id: id}
		bm.bots[id] = bot
	}
	return bot
}

type OutputMap struct {
	outputs map[int]*Output
}

func NewOutputMap() *OutputMap {
	om := OutputMap{
		outputs: make(map[int]*Output),
	}
	return &om
}

func (om *OutputMap) Get(id int) *Output {
	output := om.outputs[id]
	if output == nil {
		output = &Output{id: id}
		om.outputs[id] = output
	}
	return output
}

func main() {
	var q [][2]int
	bm := NewBotMap()
	om := NewOutputMap()

	r, _ := os.Open("input")
	scanner := bufio.NewScanner(r)
	for scanner.Scan() {
		l := scanner.Text()
		if strings.HasPrefix(l, "value") {
			s := strings.Split(l, " ")
			value, _ := strconv.Atoi(s[1])
			botNum, _ := strconv.Atoi(s[5])
			bm.Get(botNum)
			q = append(q, [2]int{botNum, value})
		} else {
			s := strings.Split(l, " ")
			botNum, _ := strconv.Atoi(s[1])

			loOut := s[5] == "output"
			loNum, _ := strconv.Atoi(s[6])
			hiOut := s[10] == "output"
			hiNum, _ := strconv.Atoi(s[11])

			bot := bm.Get(botNum)

			if loOut {
				bot.lo = om.Get(loNum)
			} else {
				bot.lo = bm.Get(loNum)
			}

			if hiOut {
				bot.hi = om.Get(hiNum)
			} else {
				bot.hi = bm.Get(hiNum)
			}
		}
	}
	// Execute
	for _, cmd := range q {
		bm.Get(cmd[0]).Give(cmd[1])
	}

	fmt.Println(om.Get(0).bin[0] * om.Get(1).bin[0] * om.Get(2).bin[0])
}
