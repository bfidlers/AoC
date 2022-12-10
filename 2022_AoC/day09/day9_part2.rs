fn main() -> Result<(), Box<dyn std::error::Error>> {
    let input = std::fs::read_to_string("input.txt")?;
    let mut data: Vec<(&str, i32)> = input.lines()
                                          .map(|x| x.split_at(1))
                                          .map(|x| (x.0, x.1.trim()
                                                            .parse()
                                                            .unwrap()))
                                          .collect();
    let mut h: (i32, i32) = (0,0);
    let mut t:Vec<(i32, i32)> = vec![(0,0);9];
    let mut pos: Vec<(i32,i32)> = Vec::new();

    while data.len() != 0 {
        step(&mut h, &mut t, &mut data);
        pos.push(*t.last().unwrap());
        println!("{:?}", data);
        println!("{:?}", h);
        println!("{:?}", t);
    }

    pos.dedup();
    println!("{:?}", pos);
    pos.sort();
    pos.dedup();
    let result: usize = pos.len();

    println!("{:?}", result);

    Ok(())
}

fn step(h: &mut (i32, i32), t: &mut Vec<(i32, i32)>, moves: &mut Vec<(&str, i32)>) {
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

    let mut p = h;
    for c in t {
        if touching(&p, &c) {
            p = c;
            continue
        } else if manhattan(&p, &c) == 2 {
            let dir = get_dir_straight(&p, &c);
            c.0 += dir.0;
            c.1 += dir.1;
            p = c;
            continue
        } else {
            let dir = get_dir(&p, &c);
            c.0 += dir.0;
            c.1 += dir.1;
            p = c;
        }
    }

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

fn get_dir_straight(h: &(i32, i32), t: &(i32, i32)) -> (i32, i32) {
    if h.0 == t.0 {
        (0, (h.1 - t.1) / 2)
    } else {
        ((h.0 - t.0) / 2, 0)
    }
}

fn get_dir(h: &(i32, i32), t: &(i32, i32)) -> (i32, i32) {
    let diff = (h.0 - t.0, h.1 - t.1);
    (diff.0 / diff.0.abs(), diff.1 / diff.1.abs())
}
