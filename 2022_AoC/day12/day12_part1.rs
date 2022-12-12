use std::cmp::Ordering;
use std::collections::HashMap;
use std::collections::BinaryHeap;

fn main() -> Result<(), Box<dyn std::error::Error>> {
    let input = std::fs::read_to_string("input.txt")?;
    let mut data: Vec<Vec<i32>> = input.lines()
                                       .map(|x| x.chars()
                                                 .map(|y| y as i32 - 'a' as i32)
                                                 .collect())
                                       .collect();

    let start: (usize, usize) = find_elem(&data, 'S' as i32 - 'a' as i32);
    let end: (usize, usize) = find_elem(&data, 'E' as i32 - 'a' as i32);
    data[start.1][start.0] = 'a' as i32 - 'a' as i32;
    data[end.1][end.0] = 'z' as i32 - 'a' as i32;

    let result = a_star(&start, &end, &data);

    println!("{:?}", result);

    Ok(())
}

fn find_elem(matrix: &Vec<Vec<i32>>, elem: i32) -> (usize, usize) {
    for (i, row) in matrix.iter().enumerate() {
        for (j, el) in row.iter().enumerate() {
            if elem == *el {
                return (j, i);
            }
        }
    }
    (0,0)
}

fn manhattan(f: &(usize, usize), s: &(usize, usize)) -> i32 {
    (f.0 as i32 - s.0 as i32).abs() + (f.1 as i32 - s.1 as i32).abs()
}

#[derive(Eq,PartialEq)]
struct Cost {
    pos: (usize, usize),
    cost: i32,
}

impl Ord for Cost {
    fn cmp(&self, other: &Self) -> Ordering {
        other.cost.cmp(&self.cost)
    }
}

impl PartialOrd for Cost {
    fn partial_cmp(&self, other: &Self) -> Option<Ordering> {
        Some(self.cmp(other))
    }
}

fn a_star(start: &(usize, usize), 
          end: &(usize, usize), 
          matrix: &Vec<Vec<i32>>) 
    -> Option<i32> {

    let mut open_set: BinaryHeap<Cost> = BinaryHeap::new();
    let mut came_from: HashMap<(usize,usize),(usize,usize)> = HashMap::new();
    let mut g_score: HashMap<(usize,usize),i32> = HashMap::new();

    open_set.push(Cost{pos:*start, cost:manhattan(&start, &end)});
    g_score.insert(*start, 0);

    while let Some(Cost{pos, cost}) = open_set.pop() {
        if pos == *end {
            return Some(cost);
        }

        let neighbours = get_neighbours(&pos, &matrix); 
        for neighbour in neighbours {
            let dist = g_score.get(&pos).unwrap()
                + manhattan(&pos, &neighbour);
            if dist < *g_score.get(&neighbour).unwrap_or(&i32::MAX) {
                came_from.insert(neighbour, pos);
                g_score.insert(neighbour, dist);
                let score = dist + manhattan(&neighbour, &end);
                open_set.push(Cost{pos:neighbour, cost:score});
            }
            
        }
    }
    None
}

fn get_neighbours(pos: &(usize, usize), 
                  matrix: &Vec<Vec<i32>>) 
    -> Vec<(usize, usize)> {

    let mut v: Vec<(usize, usize)> = Vec::new();

    for (dx,dy) in [(0,-1), (0,1), (-1,0), (1,0)].iter() {
        let (x, y) = (pos.0 as i32 - dx, pos.1 as i32 - dy);
        if x < 0 || x >= matrix[0].len() as i32 {
            continue;
        }
        if y < 0 || y >= matrix.len() as i32 {
            continue;
        }
        if matrix[pos.1][pos.0] < matrix[y as usize][x as usize] - 1 {
            continue;
        }
        v.push((x as usize, y as usize));
    }
    v
}
