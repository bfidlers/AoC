fn main() -> Result<(), Box<dyn std::error::Error>> {
    let input = std::fs::read_to_string("input.txt")?;
    let mut data: Vec<(&str, i32)> = input.lines()
                                          .map(|x| x.split_at(1))
                                          .map(|x| (x.0, x.1.trim()
                                                            .parse()
                                                            .unwrap()))
                                          .collect();
    let mut h: (i32, i32) = (0,0);
    let mut t: (i32, i32) = (0,0);
    let mut pos: Vec<(i32,i32)> = Vec::new();

    while data.len() != 0 {
        step(&mut h, &mut t, &mut data);
        pos.push(t);
    }

    pos.sort();
    pos.dedup();
    let result: usize = pos.len();

    println!("{:?}", result);

    Ok(())
}

fn step(h: &mut (i32, i32), t: &mut (i32, i32), moves: &mut Vec<(&str, i32)>) {
    let (dir, nb) = moves[0];

    if nb == 0 {
        moves.remove(0);
        return
    }
    match dir {
        "U" => h.1 += 1,
        "R" => h.0 += 1,
        "D" => h.1 -= 1,
        "L" => h.0 -= 1,
        &_  => panic!("invalid move"),
    }
    moves[0] = (dir, nb - 1);

    if touching(&h, &t) {
        return
    }
    if manhattan(&h, &t) == 2 {
        match dir {
            "U" => t.1 = t.1 + 1,
            "R" => t.0 = t.0 + 1,
            "D" => t.1 = t.1 - 1,
            "L" => t.0 = t.0 - 1,
            &_  => panic!("invalid move"),
        }
        return
    }

    let dir = get_dir(&h, &t);
    t.0 += dir.0;
    t.1 += dir.1;
}

fn touching(h: &(i32, i32), t: &(i32, i32)) -> bool {
    for dx in [-1,0,1] {
        for dy in [-1,0,1] {
            if h.0 + dx == t.0 && h.1 + dy == t.1 {
                return true;
            }
        }
    }
    false
}

fn manhattan(h: &(i32, i32), t: &(i32, i32)) -> u32 {
    h.0.abs_diff(t.0) + h.1.abs_diff(t.1)
}

fn get_dir(h: &(i32, i32), t: &(i32, i32)) -> (i32, i32) {
    let diff = (h.0 - t.0, h.1 - t.1);
    (diff.0 / diff.0.abs(), diff.1 / diff.1.abs())
}
