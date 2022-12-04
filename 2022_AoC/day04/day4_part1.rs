fn main() -> Result<(), Box<dyn std::error::Error>> {
    let input = std::fs::read_to_string("input.txt")?;
    let data: Vec<Vec<Vec<i32>>> = input.lines()
                                        .map(|x| x.split(",")
                                                  .map(|y| y.split("-")
                                                            .map(|z| z.parse()
                                                                      .unwrap())
                                                            .collect())
                                                  .collect())
                                        .collect();

    let result: usize = data.iter()
                            .map(|x| overlaps(x))
                            .filter(|x| *x)
                            .count();

    println!("{:?}", result);
    Ok(())
}

fn overlaps(line: &Vec<Vec<i32>>) -> bool {
    let f = &line[0];
    let s = &line[1];
    (&f[0] >= &s[0] && &f[1] <= &s[1]) || (&f[0] <= &s[0] && &f[1] >= &s[1])
}
