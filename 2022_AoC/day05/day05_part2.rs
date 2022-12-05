fn main() -> Result<(), Box<dyn std::error::Error>> {
    let input = std::fs::read_to_string("input.txt")?;
    let data: Vec<&str> = input.split("\n\n")
                               .collect();
    let mut crates = parse_crates(data[0]);
    let moves = parse_moves(data[1]);

    for m in moves {
        move_crates(&m, &mut crates);
    }

    let result:String = crates.iter()
                              .map(|x| x.last()
                                        .unwrap())
                              .collect::<Vec<&char>>()
                              .into_iter()
                              .collect();

    println("{:?}", result);

    Ok(())
}

fn parse_crates(s: &str) -> Vec<Vec<char>> {
    let test: Vec<Vec<String>> = s.lines()
                                  .map(|x| x.chars()
                                            .collect::<Vec<char>>()
                                            .chunks(4)
                                            .map(|y| y.iter()
                                                      .collect::<String>())
                                            .collect())
                                  .collect();
    let test2 = test.iter()
                    .map(|x| x.iter()
                              .map(|y| y.chars()
                                        .nth(1)
                                        .unwrap())
                              .collect())
                    .collect();
    transpose(test2)
}

fn transpose(m: Vec<Vec<char>>) -> Vec<Vec<char>> {
    let mut t = Vec::new();
    for j in 0..m[0].len() {
        let mut v = Vec::new();
        for i in (0..m.len()-1).rev() {
            if m[i][j].is_alphabetic() {
                v.push(m[i][j]);
            }
        }
        t.push(v);
    }
    t
}

fn parse_moves(s: &str) -> Vec<Vec<i32>> {
    s.lines().map(|x| x.split_whitespace()
                       .map(|y| y.parse::<i32>())
                       .filter(|y| y.is_ok())
                       .map(|y| y.unwrap())
                       .collect())
             .collect()
}

fn move_crates(m: &Vec<i32>, crates: &mut Vec<Vec<char>>) {
    // Tried using take(..m[0]) but couldn't get it to work ...
    let mut v = Vec::new();
    for i in (0..m[0] as usize) {
        let x = crates[(m[1] - 1) as usize].pop()
                                           .unwrap();
        v.insert(0,x);
    }
    crates[(m[2] - 1) as usize].append(& mut v);
}
