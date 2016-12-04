use std::collections::HashSet;
use std::io::Result;

const N: isize = 0;
const E: isize = 1;
const S: isize = 2;
const W: isize = 3;

enum Direction {
    Right,
    Left,
}

pub fn solve<L: Iterator<Item=Result<String>>>(input: &mut L) -> () {
    let line = input.next().unwrap().unwrap();
    let v: Vec<&str> = line.split(", ").collect();
    println!("Ending is {} blocks away", solve_line(&v));
}

fn solve_line(v: &Vec<&str>) -> isize {
    let mut x: isize = 0;
    let mut y: isize = 0;
    let mut dir = 0; // start facing north
    let mut visited = HashSet::new();
    let mut first = false;
    
    for step in v.into_iter() {
        let (direction, mut distance) = get_travel(step);
        match direction {
            Direction::Right => {
                dir = (dir + 1) % 4; // turn right, modulus for full rotation
            },
            Direction::Left => {
                if dir == 0 {
                    dir = 3
                } else {
                    dir = dir - 1
                }
            }
        }
        
        while distance > 0 {
            match dir {
                N => {
                    y = y + 1
                },
                E => {
                    x = x + 1
                },
                S => {
                    y = y - 1
                },
                W => {
                    x = x - 1
                },
                _ => unreachable!(),
            }
            distance -= 1;

            if first == false && visited.contains(&(x,y)) {
                println!("First doubly visited location is {:?} which is {} blocks away",
                    (x,y), x.abs()+y.abs());
                first = true;
            }
            visited.insert((x,y));
        }
    }
    
    x.abs() + y.abs()
}

fn get_travel(v: &str) -> (Direction, isize) {
    let mut cs = v.chars();
    let dir = cs.next().unwrap();
    let num = isize::from_str_radix(cs.as_str(), 10).unwrap();
    match dir {
        'R' => (Direction::Right, num),
        'L' => (Direction::Left, num),
        _ => panic!("{:?}", dir),
    }
}