use std::collections::VecDeque;

fn main() -> Result<(), Box<dyn std::error::Error>> {
    let input = std::fs::read_to_string("input.txt")?;
    let mut data: Vec<char> = input.chars().rev().collect();
    let len_begin = data.len();

    let mut v: VecDeque<char> = VecDeque::new();
    for i in 0..=13 {
        v.push_back(data.pop().unwrap());
    }

    loop {
        if all_different(&v) {
            break;
        }
        v.pop_front();
        v.push_back(data.pop().unwrap());
    }

    let len_end = data.len();
        
    println!("{:?}", len_begin - len_end);
    Ok(())
}

fn all_different(v: &VecDeque<char>) -> bool {
    for i in 0..v.len() {
        for j in i+1..v.len() {
            if v.get(i).unwrap() == v.get(j).unwrap() {
                return false;
            }
        }
    }
    true
}
