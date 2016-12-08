use std::io;
use std::ops::Deref;

extern crate crypto;

use self::crypto::digest::Digest;
use self::crypto::md5::Md5;

pub fn solve<L: Iterator<Item=io::Result<String>>>(input: &mut L) -> () {
    let mut sh = Md5::new();
    let base = input.next().unwrap().unwrap();

    let mut password = String::new();
    let mut next_pass = vec!['_', '_', '_', '_', '_', '_', '_', '_'];
    let mut next_chars = 0;

    for i in 0.. {
        sh.input_str(base.deref());
        sh.input_str(format!("{}", i).deref());
        let res = sh.result_str();
        sh.reset();

        if res.starts_with("00000") {
            println!("{}: {}", i, res);
            if password.len() < 8 {
                password.push(res.chars().skip(5).next().unwrap());
            }
            let mut iter = res.chars().skip(5);
            let loc_s = format!("{}", iter.next().unwrap());
            let loc = usize::from_str_radix(loc_s.deref(), 16).unwrap();
            if loc < 8 && next_pass[loc] == '_' {
                next_pass[loc] = iter.next().unwrap();
                println!("\t{:?}", next_pass);
                next_chars += 1;
                if next_chars >= 8 {
                    break;
                }
            }
        }
    }

    println!("Password is {}", password);
    println!("Second password is {}", next_pass.drain(..).collect::<String>());
}