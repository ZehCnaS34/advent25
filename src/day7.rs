use core::panic;
use std::collections::HashMap;

const INPUT: &str = include_str!("./Day7.txt");

#[derive(Debug, Copy, Clone, PartialEq, Eq)]
enum Cell {
    Start,
    Empty,
    Splitter,
}

#[derive(Debug)]
struct Problem {
    matrix: Vec<Vec<Cell>>,
}

impl Problem {
    fn load() -> Self {
        let matrix: Vec<Vec<Cell>> = INPUT
            .lines()
            .map(|line| {
                line.chars()
                    .map(|c| match c {
                        'S' => Cell::Start,
                        '.' => Cell::Empty,
                        '^' => Cell::Splitter,
                        _ => panic!("Invalid input"),
                    })
                    .collect()
            })
            .collect();
        Self { matrix }
    }
    fn day1() {
        let p = Problem::load();
        let start = p.matrix[0]
            .iter()
            .position(|c| *c == Cell::Start)
            .expect("Start not found");
        let mut beams: HashMap<usize, bool> = HashMap::new();
        beams.insert(start, true);
        let mut ans = 0;
        for index in 1..p.matrix.len() {
            let row = &p.matrix[index];
            let mut new_beams = HashMap::new();
            for beam in beams.keys() {
                match row.get(*beam).expect("could not get beam") {
                    Cell::Splitter => {
                        ans += 1;
                        let left = *beam - 1;
                        let right = *beam + 1;
                        new_beams.insert(left, true);
                        if right < row.len() {
                            new_beams.insert(right, true);
                        }
                    }
                    Cell::Empty => {
                        new_beams.insert(*beam, true);
                    }
                    v => panic!("Invalid input {:?}", v),
                }
            }
            beams = new_beams;
        }

        println!("Day 1, Part 1 {}", ans);
    }
    fn day2() {
        let p = Problem::load();
        let start = p.matrix[0]
            .iter()
            .position(|c| *c == Cell::Start)
            .expect("Start not found");
        let mut cache: HashMap<(usize, usize), usize> = HashMap::new();

        fn helper(
            cache: &mut HashMap<(usize, usize), usize>,
            p: &Problem,
            row: usize,
            offset: usize,
        ) -> usize {
            if cache.contains_key(&(row, offset)) {
                return *cache.get(&(row, offset)).unwrap();
            }

            if row >= p.matrix.len() {
                return 1;
            }

            let result = match p.matrix[row][offset] {
                Cell::Start => panic!("Invalid input {:?}", Cell::Start),
                Cell::Empty => helper(cache, p, row + 1, offset),
                Cell::Splitter => {
                    helper(cache, p, row + 1, offset - 1) + helper(cache, p, row + 1, offset + 1)
                }
            };

            cache.insert((row, offset), result);
            result
        }

        let ans = helper(&mut cache, &p, 1, start);

        println!("Day 2, Part 2 {}", ans);
    }
}

pub fn run() {
    Problem::day1();
    Problem::day2();
}
