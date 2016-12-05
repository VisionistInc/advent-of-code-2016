use std::io;

pub fn solve<L: Iterator<Item=io::Result<String>>>(input: &mut L) -> () {
    let mut possible = 0;
    for line in input {
        let mut sides: Vec<usize> = line.unwrap()
            .split_whitespace()
            .map(|s: &str| {
                usize::from_str_radix(s, 10).unwrap()
            })
            .collect();
        sides.sort();
        if sides[0] + sides[1] > sides[2] {
            possible += 1;
        }
    }
    println!("{}", possible);
}