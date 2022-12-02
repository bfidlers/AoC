fn main() -> Result<(), Box<dyn std::error::Error>> {
    let input = std::fs::read_to_string("input.txt")?;
    let data: Vec<Vec<char>> = input.lines()
                                    .map(|x| x.split_whitespace()
                                              .map(|y| y.chars()
                                                        .next()
                                                        .unwrap())
                                              .collect())
                                    .collect();

    let result: u32 = data.iter()
                          .map(|x| get_score(x))
                          .sum();

    println!("{:?}", result);
    Ok(())
}

fn get_score(v: &Vec<char>) -> u32 {
    let frst = v[0].to_digit(36).unwrap() - 'A'.to_digit(36).unwrap() + 1;
    let snd  = (v[1].to_digit(36).unwrap() - 'X'.to_digit(36).unwrap()) * 3;
    snd + get_score2(frst, snd)
}

fn get_score2(frst: u32, snd: u32) -> u32 {
    let value = (snd / 3 + frst + 2) % 3;
    match value {
        0 => 3,
        _ => value
    }
}
