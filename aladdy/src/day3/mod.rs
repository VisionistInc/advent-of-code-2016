use std::io;

pub fn solve<L: Iterator<Item=io::Result<String>>>(input: &mut L) -> () {
    let mut entries: Vec<(usize, usize, usize)> = vec![];

    let mut possible = 0;
    for line in input {
        let mut sides: Vec<usize> = line.unwrap()
            .split_whitespace()
            .map(|s: &str| {
                usize::from_str_radix(s, 10).unwrap()
            })
            .collect();
           
        // has to happen before sort reorders items
        entries.push((sides[0], sides[1], sides[2]));

        sides.sort();
        if sides[0] + sides[1] > sides[2] {
            possible += 1;
        }
    }
    println!("{} triangles possible horizontally", possible);

    possible = 0;
    for chunk in entries.chunks(3) {
        let triangles = rotate(chunk);
        possible += triangles.into_iter()
            .filter(is_valid_tri)
            .count();
    }
    println!("{} triangles possible vertically", possible);
}

fn rotate(v: &[(usize, usize, usize)]) -> Vec<(usize, usize, usize)> {
    vec![(v[0].0, v[1].0, v[2].0),
         (v[0].1, v[1].1, v[2].1),
         (v[0].2, v[1].2, v[2].2)]
}

fn is_valid_tri(t: &(usize, usize, usize)) -> bool {
    (t.0 + t.1 > t.2) &
    (t.1 + t.2 > t.0) &
    (t.2 + t.0 > t.1)
}