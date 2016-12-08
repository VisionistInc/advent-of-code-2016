
use std::io;
use std::collections::HashMap;

pub fn solve<L: Iterator<Item=io::Result<String>>>(input: &mut L) -> () {
    let zeroth = HashMap::with_capacity(26);
    let first = HashMap::with_capacity(26);
    let second = HashMap::with_capacity(26);
    let third = HashMap::with_capacity(26);
    let fourth = HashMap::with_capacity(26);
    let fifth = HashMap::with_capacity(26);
    let sixth = HashMap::with_capacity(26);
    let seventh = HashMap::with_capacity(26);
    let mut letters = vec![zeroth, first, second, third, fourth, fifth, sixth, seventh];
    
    for line in input {
        for (i, c) in line.unwrap().chars().enumerate() {
            let counter = letters[i].entry(c).or_insert(0);
            *counter += 1;
        }
    }

    let mut most = String::new();
    let mut least = String::new();
    for m in letters {
        let c = m.iter().fold(('_', 0), |acc, t| {
            if acc.1 < *t.1 {
                (*t.0, *t.1)
            } else {
                acc
            }
        }).0;
        most.push(c);
        let d = m.iter().fold(('_', 100000), |acc, t| {
            if acc.1 > *t.1 {
                (*t.0, *t.1)
            } else {
                acc
            }
        }).0;
        least.push(d);
    }
    println!("{}", most);
    println!("{}", least)
}