fn main() -> Result<(), Box<dyn std::error::Error>> {
    let input = std::fs::read_to_string("input.txt")?;
    let data: Vec<Vec<&str>> = input.split("$ ")
                                    .map(|x| x.lines()
                                              .collect())
                                    .collect();

    let sizes: Vec<(&str, i32)> = calculate_size(data);

    let disk_space = 70000000;
    let required = 30000000;
    let needed = required - (disk_space - sizes.last().unwrap().1);

    let result: i32 = sizes.iter()
                           .map(|x| x.1)
                           .filter(|&x| x >= needed)
                           .min()
                           .unwrap();

    println!("{:?}", result);
    Ok(())
}

fn calculate_size(input: Vec<Vec<&str>>) -> Vec<(&str, i32)> {
    let mut dirs: Vec<&str> = Vec::new();
    let mut parent_sizes: Vec<i32> = Vec::new();
    let mut c_size: i32 = 0;
    let mut dir_sizes: Vec<(&str, i32)> = Vec::new();

    for block in input[1..].iter() {
        let command:Vec<&str> = block[0].split_whitespace().collect();
        match command[0] {
            "cd" => {
                match command[1] {
                    "/"  => {
                        dirs.clear();
                        dirs.push("/");
                    }
                    ".." => {
                        let c_dir = dirs.pop().unwrap();
                        dir_sizes.push((c_dir, c_size));
                        c_size += parent_sizes.pop().unwrap();
                    },
                    dir  => {
                        dirs.push(dir);
                        parent_sizes.push(c_size);
                        c_size = 0;
                    }
                }
            }
            "ls" => {
                c_size = block[1..].iter()
                                   .map(|x| x.split_whitespace()
                                             .next()
                                             .unwrap()
                                             .parse()
                                             .unwrap_or(0))
                                   .sum();
            }
            _ => panic!("unknown input"),
        }
    }
    // Some directories are still open
    while !dirs.is_empty() {
        let dir = dirs.pop().unwrap();
        dir_sizes.push((dir, c_size));
        c_size += parent_sizes.pop().unwrap_or(0);
    }
    dir_sizes
}
