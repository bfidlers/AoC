fn main() -> Result<(), Box<dyn std::error::Error>> {
    let input = std::fs::read_to_string("input.txt")?;
    let l: Vec<&str> = input.lines()
                            .collect();
    let data: Vec<Vec<&str>> = l.chunks(3)
                                .map(|s| s.into())
                                .collect();


    let result: u32 = data.iter()
                          .map(|x| to_value(get_common(x)))
                          .sum();
    println!("{:?}", result);
    Ok(())
}

fn get_common(values: &Vec<&str>) -> char {
    let mut iter = values[0].chars();
    loop {
        let value = iter.next().unwrap();
        if values[1].chars().find(|x| *x == value).is_some() {
            if values[2].chars().find(|x| *x == value).is_some() {
                return value;
            }
        }
    }
}

fn to_value(c: char) -> u32 {
    let value = c.to_digit(36).unwrap() - 9;
    if c.is_ascii_lowercase() {
        value
    } else {
        value + 26
    }
}
