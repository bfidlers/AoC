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

fn get_score(values: &Vec<char>) -> u32 {
    let frst = values[0].to_digit(36).unwrap() - 'A'.to_digit(36).unwrap() + 1;
    let snd = values[1].to_digit(36).unwrap() - 'X'.to_digit(36).unwrap() + 1;
    snd + (4 + snd - frst) % 3 * 3

}
