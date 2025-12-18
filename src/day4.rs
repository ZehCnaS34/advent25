use crate::common::matrix::{Location, LocationIterator, Matrix};

const INPUT: &str = include_str!("./Day4.txt");

#[derive(Debug, PartialEq, Eq)]
enum Cell {
    Hey,
    Empty,
}

struct Board {
    grid: Matrix<Cell>,
}

impl Board {
    fn load() -> Self {
        Self {
            grid: Matrix::from(
                INPUT
                    .split("\n")
                    .map(|line| {
                        line.chars()
                            .map(|c| match c {
                                '@' => Cell::Hey,
                                '.' => Cell::Empty,
                                c => panic!("Invalid cell {}", c),
                            })
                            .collect()
                    })
                    .collect::<Vec<Vec<Cell>>>(),
            ),
        }
    }

    fn can_pull_hey(&self, loc: &Location) -> bool {
        let mut count = 0;
        for l in self.grid.neighbors(loc) {
            if self.grid.get(&l).unwrap() == &Cell::Hey {
                count += 1;
            }
        }
        count < 4
    }

    fn location_iter(&self) -> LocationIterator<'_, Cell> {
        self.grid.location_iter()
    }
}

fn day1() {
    let board = Board::load();
    let mut ans: i32 = 0;

    for loc in board.location_iter() {
        if board.grid.get(&loc).unwrap() == &Cell::Empty {
            continue;
        }
        if board.can_pull_hey(&loc) {
            ans += 1;
        }
    }

    println!("Day 4 Part 1 {}", ans);
}

fn day2() {
    let mut board = Board::load();
    let mut ans: i32 = 0;

    loop {
        let mut remove = Vec::new();

        for loc in board.location_iter() {
            let cell = board.grid.get(&loc).unwrap();
            if cell == &Cell::Empty {
                continue;
            }
            if board.can_pull_hey(&loc) {
                ans += 1;
                remove.push(loc);
            }
        }

        for loc in &remove {
            board.grid.set(&loc, Cell::Empty);
        }

        if remove.is_empty() {
            break;
        }
    }

    println!("Day 4 Part 2 {}", ans);
}

pub fn run() {
    day1();
    day2();
}
