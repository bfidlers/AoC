fn main() -> Result<(), Box<dyn std::error::Error>> {
    let input = std::fs::read_to_string("input.txt")?;
    let data: Vec<Vec<&str>> = input.lines()
                                    .map(|x| x.split_whitespace()
                                              .collect())
                                    .collect();

    let result: i32 = data.iter()
                          .map(|x| get_score(x))
                          .sum();

    println!("{:?}", result);
    Ok(())
}

fn get_score(values: &Vec<&str>) -> i32 {
    let score = match values[1] {
        "X" => 0,
        "Y" => 3,
        "Z" => 6,
        _ => 0,
    };
    score + get_score2(values[0], values[1])
}

fn get_score2(first: &str, snd: &str) -> i32 {
    match first {
        "A" => match snd {
                   "X" => 3,
                   "Y" => 1,
                   "Z" => 2,
                   _ => 0,
        },
        "B" => match snd {
                   "X" => 1,
                   "Y" => 2,
                   "Z" => 3,
                   _ => 0,
        },
        "C" => match snd {
                   "X" => 2,
                   "Y" => 3,
                   "Z" => 1,
                   _ => 0,
        },
        _ => 0,
    }
}
