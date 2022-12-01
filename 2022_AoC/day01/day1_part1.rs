use std::fs;

fn main() -> Result<(), Box<dyn std::error::Error>> {
    let data = fs::read_to_string("input.txt")?;
    let blocks: Vec<&str> = data.split("\n\n").collect();
    let data2 = blocks.iter().map(|x| x.lines()
                                  .map(|y| y.parse::<i32>().unwrap())
                                  .sum::<i32>())
                             .max();

    println!("{:?}", data2.ok_or(0));
    Ok(())
}
