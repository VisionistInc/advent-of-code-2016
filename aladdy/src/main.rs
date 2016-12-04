use std::io::stdin;
use std::io::BufRead;

mod day1;

fn main() {
    let stdin = stdin();
    let handle = stdin.lock();
    day1::solve(&mut (handle.lines()));
}