fn main() -> Result<(), Box<dyn std::error::Error>> {
    let data = std::fs::read_to_string("input.txt")?;
    let input: Vec<Vec<u32>> = data.lines()
                                   .map(|x| x.chars()
                                             .map(|y| y as u32 - '0' as u32)
                                             .collect())
                                   .collect();
    let mapped1: Vec<Vec<(u32,bool)>> = map_trees_ul(input);
    let mapped2: Vec<Vec<(u32,bool)>> = map_trees_br(mapped1);
    let result: usize = mapped2.iter()
                            .map(|x| x.iter()
                                      .map(|y| y.1)
                                      .filter(|y| *y)
                                      .count())
                            .sum();
    println!("{:?}", result);

    Ok(())
}

fn map_trees_ul(trees: Vec<Vec<u32>>) -> Vec<Vec<(u32, bool)>> {
    let mut v: Vec<Vec<(u32, bool)>> = Vec::new();
    let mut l_biggest: u32;
    let mut u_biggest: Vec<u32> = vec![0; trees[0].len()];
    for (i,row) in trees.iter().enumerate() {
        let mut r: Vec<(u32, bool)> = Vec::new();
        l_biggest = 0;
        for (j,el) in row.iter().enumerate() {
            if i == 0 || j == 0 || el > &l_biggest || el > &u_biggest[j] {
                r.push((*el, true));
            } else {
                r.push((*el, false));
            }

            if el > &l_biggest {
                l_biggest = *el;
            } 
            if el > &u_biggest[j] {
                u_biggest[j] = *el;
            }
        }
        v.push(r);
    }
    v
}

fn map_trees_br(trees: Vec<Vec<(u32, bool)>>) -> Vec<Vec<(u32, bool)>> {
    let mut v: Vec<Vec<(u32, bool)>> = Vec::new();
    let mut r_biggest: u32;
    let mut l_biggest: Vec<u32> = vec![0; trees[0].len()];
    for (i,row) in trees.iter().rev().enumerate() {
        let mut r: Vec<(u32, bool)> = Vec::new();
        r_biggest = 0;
        for (j,el) in row.iter().rev().enumerate() {
            if i == 0 || j == 0 || el.1 || el.0 > r_biggest || el.0 > l_biggest[j] {
                r.push((el.0, true));
            } else {
                r.push((el.0, false));
            }

            if el.0 > r_biggest {
                r_biggest = el.0;
            } 
            if el.0 > l_biggest[j] {
                l_biggest[j] = el.0;
            }
        }
        r.reverse();
        v.push(r);
    }
    v.reverse();
    v
}
