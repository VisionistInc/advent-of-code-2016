use std::io;
use std::collections::HashMap;
use std::str::FromStr;
use std::cmp::Ordering;

pub fn solve<L: Iterator<Item=io::Result<String>>>(input: &mut L) -> () {
    
    let mut id_sum: usize = 0;
    for line in input {
        let entry = line.unwrap();
        let r = Room::from_string(&entry);

        match r {
            Some(room) => {
                if room.is_valid() {
                    id_sum += room.sector
                }
            },
            None => (),
        }
    }
    println!("{}", id_sum);
}

struct Room<'a> {
    enc_name: &'a str,
    sector: usize,
    checksum: &'a str,
}

impl<'a> Room<'a> {
    // attempts to extract a room from an entry
    //
    // the 'a are lifetime specifiers, here they indicate that
    // the lifetime of the returned room is no longer than the 
    // lifetime of the string slice it is given, this is necessary
    // as the enc_name and checksum members will be further 
    // slices into the string slice
    fn from_string(s: &'a str) -> Option<Room<'a>> {
        let split: Vec<&str> = s.rsplitn(2, '-').collect();
        let name = split[1];
        
        // split it into three pieces, the last will be an empty string
        let v: Vec<&str> = split[0].splitn(3, |c| (c == '[') | (c == ']')).collect();
        let sector = usize::from_str(v[0]).unwrap();
        let checksum = v[1];
        
        Some(Room{
            enc_name: name,
            sector: sector,
            checksum: checksum,
        })
    }

    fn is_valid(&self) -> bool {
        let mut counter: HashMap<char, usize> = HashMap::new();
        for c in self.enc_name.chars().filter(|c| c.is_alphabetic()) {
            if counter.contains_key(&c) {
                let val = counter.get_mut(&c).unwrap();
                *val += 1;
            } else {
                counter.insert(c, 1);
            }
        }

        let mut pairs: Vec<(char, usize)> = counter.drain().collect();
        pairs.sort_by(|&l, &r| {
                match r.1.cmp(&l.1) {
                    Ordering::Less => Ordering::Less,
                    Ordering::Equal => l.0.cmp(&r.0),
                    Ordering::Greater => Ordering::Greater,
                }
            });
        drop(counter); // don't need it anymore

        let checksum = pairs.iter()
            .take(5)
            .map(|&p| p.0) // drops count, gives character
            .collect::<String>();
        
        self.checksum == checksum
    }
}