fn main() -> Result<(), Box<dyn std::error::Error>> {
    let data = std::fs::read_to_string("input.txt")?;
    let input: Vec<Vec<u32>> = data.lines()
                                   .map(|x| x.chars()
                                             .map(|y| y as u32 - '0' as u32)
                                             .collect())
                                   .collect();

    let mapped: Vec<Vec<u32>> = calc(input);
    let result: u32 = *mapped.iter()
                            .map(|x| x.iter()
                                      .max()
                                      .unwrap())
                            .max()
                            .unwrap();
    println!("{:?}", result);

    Ok(())
}

fn calc(trees: Vec<Vec<u32>>) -> Vec<Vec<u32>> {
    let mut v: Vec<Vec<u32>> = Vec::new();
    for (i,row) in trees.iter().enumerate() {
        let mut r: Vec<u32> = Vec::new();
        for (j,el) in row.iter().enumerate() {
            let mut score = 1;
            for (dx,dy) in [(0,1), (0,-1), (-1,0), (1,0)].iter() {
                let mut view = 0;
                let mut x:i32 = j as i32 + dx;
                let mut y:i32 = i as i32 + dy;
                loop {
                    if !is_inside(x, y, &trees) {
                        break;
                    } 
                    view += 1;
                    if trees[y as usize][x as usize] >= *el {
                        break;
                    }
                    x += dx;
                    y += dy;
                }
                score *= view;
            }
            r.push(score);
        }
        v.push(r);
    }
    v
}

fn is_inside<T>(x: i32, y: i32, m: &Vec<Vec<T>>) -> bool {
    if x < 0 || y < 0 || x >= m[0].len() as i32 || y >= m.len() as i32 {
        false
    } else {
        true
    }

}
