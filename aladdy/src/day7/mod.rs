
use std::io;

pub fn solve<L: Iterator<Item=io::Result<String>>>(input: &mut L) -> () {
    let mut sup_ips = 0;
    for line in input {
        if supporting(line.unwrap().as_str()) {
            sup_ips += 1;
        }
    }
    println!("{}", sup_ips);
}

fn supporting(ip: &str) -> bool {
    let mut valid = false;
    let parts = ip.split(|c| (c == '[' || c == ']'));
    for (i, s) in parts.enumerate() {
        if has_abba(s) {
            if i % 2 == 0 {
                // even parts are outside brackets
                valid = true;
            } else {
                valid = false;
                break;
            }
        }
    }

    valid
}

fn has_abba(s: &str) -> bool {
    let bs = s.as_bytes();
    bs.windows(4).any(|win: &[u8]| (win[0] == win[3] && win[1] == win[2] && win[0] != win[1]))
}