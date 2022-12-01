use std::fs;

fn main() -> Result<(), Box<dyn std::error::Error>> {
    let data = fs::read_to_string("input.txt")?;
    let blocks: Vec<&str> = data.split("\n\n").collect();
    let mut data2 = blocks.iter().map(|x| x.lines()
                                  .map(|y| y.parse::<i32>().unwrap())
                                  .sum::<i32>())
                             .collect::<Vec<i32>>();

    data2.sort_by(|a, b| b.cmp(a));

    let _sum: i32 = data2[0..3].iter().sum();

    println!("{:?}", _sum);
    Ok(())
}
