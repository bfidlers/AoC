fn main() -> Result<(), Box<dyn std::error::Error>> {
    let data = std::fs::read_to_string("input.txt")?;
    let blocks: Vec<&str> = data.split("\n\n")
                                .collect();
    let mut data2 = blocks.iter()
                          .map(|x| x.lines()
                                    .map(|y| y.parse::<i32>()
                                              .unwrap())
                                    .sum::<i32>())
                          .collect::<Vec<i32>>();

    data2.sort_by(|a, b| b.cmp(a));

    let result: i32 = data2.iter()
                           .take(3)
                           .sum();

    println!("{}", result);
    Ok(())
}
