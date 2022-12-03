fn main() -> Result<(), Box<dyn std::error::Error>> {
    let input = std::fs::read_to_string("input.txt")?;
    let data: Vec<(&str, &str)> = input.lines()
                                       .map(|x| x.split_at(x.len() / 2))
                                       .collect();

    let result: u32 = data.iter()
                          .map(|x| to_value(get_common(x.0, x.1)))
                          .sum();
    println!("{:?}", result);
    Ok(())
}

fn get_common(frst: &str, snd: &str) -> char {
    let mut iter = frst.chars();
    loop {
        let value = iter.next().unwrap();
        if snd.chars().find(|x| *x == value).is_some() {
            return value;
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
