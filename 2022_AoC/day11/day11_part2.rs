fn main() -> Result<(), Box<dyn std::error::Error>> {
    let data = std::fs::read_to_string("input.txt")?;
    let mut monkeys: Vec<Monkey> = data.split("\n\n")
                                     .map(|x| parse(x))
                                     .collect();

    let lcm: u64 = monkeys.iter()
                          .map(|x| {let Test::Divisible(y,_,_) = x.test; y})
                          .product();

    for _ in 0..10000 {
        round(&mut monkeys, lcm);
    }

    let mut inspections: Vec<u64> = monkeys.iter()
                                       .map(|x| x.nb_expections)
                                       .collect();
    inspections.sort_by(|a, b| b.cmp(a));

    let result:u64 = inspections[0] * inspections[1];
    println!("{:?}", result);
    Ok(())
}

fn round(monkeys: &mut Vec<Monkey>, lcm: u64) {
    for i in 0..monkeys.len() {
        while !monkeys[i].is_empty() {
            let (elem, j) = monkeys[i].inspect(lcm);
            monkeys[j].add(elem);
        }
    }
}

#[derive(Debug)]
struct Monkey {
    items: Vec<u64>, 
    operation: Operation,
    test: Test,
    nb_expections: u64,
}

#[derive(Debug)]
enum Operation {
    Mult(u64),
    Add(u64),
    Squared,
}

#[derive(Debug)]
enum Test {
    Divisible(u64, usize, usize),
}

impl Monkey {
    fn exec_operation(&self, nb: u64) -> u64 {
        match &self.operation {
            Operation::Mult(x) => nb * x,
            Operation::Add(x) => nb + x,
            Operation::Squared => nb * nb,
        }
    }
    fn exec_test(&self, nb: u64) -> usize {
        match &self.test {
            Test::Divisible(x,t,f) => if nb % x == 0 {*t} else {*f},
        }
    }
    fn inspect(&mut self, lcm: u64) -> (u64, usize) {
        self.nb_expections += 1;
        let elem = &self.items.pop().unwrap();
        let mut worry: u64 = self.exec_operation(*elem);
        worry %= lcm;
        (worry, self.exec_test(worry))
    }
    fn add(&mut self, elem: u64) {
        let _ = &self.items.insert(0, elem);
    }
    fn is_empty(&self) -> bool {
        self.items.is_empty()
    }
}

fn parse(s: &str) -> Monkey {
    let lines: Vec<&str> = s.lines().collect();
    return Monkey {
        items: lines[1].split(":")
                       .collect::<Vec<&str>>()[1]
                       .split(",")
                       .map(|x| x.trim()
                                 .parse()
                                 .unwrap())
                       .collect::<Vec<u64>>()
                       .into_iter()
                       .rev()
                       .collect(),
        operation: parse_op(lines[2]),
        test: Test::Divisible(read_last_nb(lines[3]), 
                              read_last_nb(lines[4]) as usize,
                              read_last_nb(lines[5]) as usize),
        nb_expections: 0
    }
}

fn parse_op(s: &str) -> Operation {
    let split: Vec<&str> = s.split("old ")
                            .collect::<Vec<&str>>()[1]
                            .split_whitespace()
                            .collect();
    if split[0] == "*" {
        if split[1] == "old" {
            Operation::Squared
        } else {
            Operation::Mult(split[1].trim().parse().unwrap())
        }
    } else {
        if split[1] == "old" {
            Operation::Mult(2)
        } else {
            Operation::Add(split[1].trim().parse().unwrap())
        }
    }
}

fn read_last_nb(s: &str) -> u64 {
    s.split_whitespace().last().unwrap().parse().unwrap()
}
