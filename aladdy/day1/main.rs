use std::io;

fn main() {
    let mut input = String::new();
    match io::stdin().read_line(&mut input) {
        Ok(_) => {
            let v: Vec<&str> = input.trim().split(", ").collect();
            println!("{}", solve(&v));
        },
        Err(error) => println!("error: {}", error),
    }
}

const N: isize = 0;
const E: isize = 1;
const S: isize = 2;
const W: isize = 3;

enum Direction {
    Right,
    Left,
}

fn solve(v: &Vec<&str>) -> isize {
    let mut x: isize = 0;
    let mut y: isize = 0;
    let mut dir = 0; // start facing north
    
    for step in v {
        let (direction, distance) = get_travel(step);
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
        
        match dir {
            N => {
                y = y + distance
            },
            E => {
                x = x + distance
            },
            S => {
                y = y - distance
            },
            W => {
                x = x - distance
            },
            _ => unreachable!(),
        }
        println!("{} {} {} {}", dir, distance, x, y);
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