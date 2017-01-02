package main

import (
    "bufio"
    "fmt"
    "log"
    "os"
    "strings"
    "strconv"
)

const WIDTH = 36
const HEIGHT = 30

type disk struct {
    x		int
    y		int
    size	int
    used	int
    free	int
}

// readLines reads a whole file into memory
// and returns a slice of its lines.
func readLines(path string) ([]string, error) {
  file, err := os.Open(path)
  if err != nil {
    return nil, err
  }
  defer file.Close()

  var lines []string
  scanner := bufio.NewScanner(file)
  for scanner.Scan() {
    lines = append(lines, scanner.Text())
  }
  return lines, scanner.Err()
}

func atoi(num string) (int) {
	val,err := strconv.Atoi(num)
	if err != nil {
      	// handle error
      	fmt.Println(err)
      	os.Exit(2)
    }
    return val
}

func main() {
	disks := []disk{}
	viable := 0
	large := 0
	empty := 0

	lines, err := readLines("input")
	if err != nil {
		log.Fatalf("readLines: %s", err)
	}
	for i := 0; i < len(lines); i++ {
		if !(strings.Contains(lines[i], "/dev/")) {
			continue
		}	
		vals := strings.Fields(lines[i])
		xy := strings.Split(vals[0], "-")
		x := atoi(xy[1][1:len(xy[1])])
		y := atoi(xy[2][1:len(xy[2])])
		total := atoi(vals[1][:len(vals[1])-1])
		used  := atoi(vals[2][:len(vals[2])-1])
		free  := atoi(vals[3][:len(vals[3])-1])
		disks = append(disks, disk{x,y,total,used,free})
		i = i
	}

	//create 2d array to act like grid
	//will keep track of how many moves to get empty node
	//to a particular space
	grid  := [WIDTH][HEIGHT]int{}

	for i := 0; i < len(disks); i++ {
		if disks[i].used > 100 {
			large++
			grid[disks[i].x][disks[i].y] = -2
			continue
		}
		if disks[i].used == 0 {
			empty++
			grid[disks[i].x][disks[i].y] = 0
			continue
		}

		grid[disks[i].x][disks[i].y] = -1

		for j := 0; j < len(disks); j++ {
			if disks[i].used <= disks[j].free {
				viable++
			}
		}
	}

	fmt.Println(len(disks), "total disks arranged", WIDTH, "x", HEIGHT)
	fmt.Println(large, "large")
	fmt.Println(empty, "empty")
	fmt.Println(viable, "viable")

	moves := 0

	//we know goal data is at grid[WIDTH-2][0]
	//so if we can get empty space next to it
	//we can start moving it to grid[0][0]

	//we will loop over every space on the grid,
	//and spread the empty node as far as it can go
	//on a given move

	//until empty disk reaches our target
	for grid[WIDTH-2][0] == -1 {
		//for every disk
		for x := 0; x < WIDTH; x++ {
			for y := 0; y < HEIGHT; y++ {

				//if the disk isn't reached by our current move count, skip
				if grid[x][y] != moves {
					continue
				}

				//check if we can move empty disk to any neighbors
				//that haven't already been reached

				if (x > 0) && (grid[x-1][y] == -1) {
					grid[x-1][y] = moves + 1
				}

				if (x < WIDTH-1) && (grid[x+1][y] == -1) {
					grid[x+1][y] = moves + 1
				}

				if (y > 0) && (grid[x][y-1] == -1) {
					grid[x][y-1] = moves + 1
				}

				if (y < HEIGHT-1) && (grid[x][y+1] == -1) {
					grid[x][y+1] = moves + 1
				}
			}
		}
		//increment moves so we can handle those disks next time through
		moves++
	}

	//we know that it takes 5 moves to left shift the goal data and return the empty
	//space to the disk in front of it, and we have to do that WIDTH-2 times
	//it then takes one move to left shift the goal data into its final spot
	//so we just need to add hw many moves it took to get empty disk to its
	//target spot
	moves = moves + (5*(WIDTH-2)) + 1
	fmt.Println(moves, "moves minimum")
}

