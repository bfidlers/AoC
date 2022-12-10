fn main() -> Result<(), Box<dyn std::error::Error>> {
    let data = std::fs::read_to_string("input.txt")?;
    let input: Vec<Instr> = data.lines()
                                .map(|x| parse(x))
                                .collect();

    let mut xs: Vec<i32> = vec![1, 1];
    execute(&input, &mut xs);
    let result = get_result(&xs);
    println!("{:?}", result); 

    Ok(())
}

#[derive(Debug)]
enum Instr {
    Noop, 
    Addx(i32),
}

fn parse(line: &str) -> Instr {
    let s: Vec<&str> = line.split_whitespace().collect();
    match s[0] {
        "noop" => Instr::Noop,
        "addx" => Instr::Addx(s[1].parse().unwrap()),
        &_     => panic!("Unexpected instruction"),
    }
}

fn execute(instrs: &Vec<Instr>, xs: &mut Vec<i32>) {
    for instr in instrs.iter() {
        let x = xs.last().unwrap().clone();
        match instr {
            Instr::Noop     => xs.push(x),
            Instr::Addx(nb) => {
                xs.push(x);
                xs.push(x+nb);
            }
        }
    }
}

fn get_result(xs: &Vec<i32>) -> i32 {
    let mut result: i32 = 0;
    for i in [20, 60, 100, 140, 180, 220].iter() {
        result += xs[*i as usize] * i;
    }
    result
}
