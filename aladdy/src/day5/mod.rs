use std::io;
use std::ops::Deref;

extern crate crypto;

use self::crypto::digest::Digest;
use self::crypto::md5::Md5;

pub fn solve<L: Iterator<Item=io::Result<String>>>(input: &mut L) -> () {
    let mut sh = Md5::new();
    let base = input.next().unwrap().unwrap();

    let mut password = String::new();

    for i in (0..) {
        sh.input_str(base.deref());
        sh.input_str(format!("{}", i).deref());
        let res = sh.result_str();
        sh.reset();

        if res.starts_with("00000") {
            println!("{}: {}", i, res);
            password.push(res.chars().skip(5).next().unwrap());
            if password.len() >= 8 {
                break;
            }
        }
    }

    println!("Password is {}", password);
}