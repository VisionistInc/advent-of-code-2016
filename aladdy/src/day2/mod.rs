use std::io;
use std::collections::HashMap;

pub fn solve<L: Iterator<Item=io::Result<String>>>(input: &mut L) -> () {
    let keypad = keypad_mapping();
    let mut x = 1;
    let mut y = 1;
    for line in input {
        for c in line.unwrap().chars() {
            match c {
                'D' => {
                    if y < 2 {
                        y += 1;
                    }
                },
                'U' => {
                    if y > 0 {
                        y -= 1;
                    }
                },
                'L' => {
                    if x > 0 {
                        x -= 1;
                    }
                },
                'R' => {
                    if x < 2 {
                        x += 1;
                    }
                },
                _ => panic!("{:?}", c),
            }
        }
        print!("{}", keypad.get(&(x,y)).unwrap());
    }
    println!("");
}

fn keypad_mapping() -> HashMap<(usize,usize), usize> {
    let mut keypad = HashMap::new();
    keypad.insert((0,2), 7);
    keypad.insert((1,2), 8);
    keypad.insert((2,2), 9);
    
    keypad.insert((0,1), 4);
    keypad.insert((1,1), 5);
    keypad.insert((2,1), 6);
    
    keypad.insert((0,0), 1);
    keypad.insert((1,0), 2);
    keypad.insert((2,0), 3);

    keypad
}