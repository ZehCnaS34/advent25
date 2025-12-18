use crate::common::graph::{AdjacencyMatrix, Distance};

const INPUT: &str = include_str!("./Day8-test.txt");

#[derive(Debug)]
struct Light {
    x: i64,
    y: i64,
    z: i64,
}

impl Distance for Light {
    fn distance(&self, other: &Light) -> f64 {
        let x = (self.x - other.x).pow(2) as f64;
        let y = (self.y - other.y).pow(2) as f64;
        let z = (self.z - other.z).pow(2) as f64;
        let dist = (x + y + z).sqrt();
        dist
    }
}

#[derive(Debug)]
struct Problem {
    lights: Vec<Light>, // nodes
}

impl Problem {
    fn load() -> Self {
        let mut lights = Vec::new();
        for line in INPUT.lines() {
            let parts = line.split(",").collect::<Vec<_>>();
            let x = parts[0].parse().unwrap();
            let y = parts[1].parse().unwrap();
            let z = parts[2].parse().unwrap();
            lights.push(Light { x, y, z });
        }

        Self { lights }
    }

    fn part1() {
        let problem = Self::load();
        println!("Part 1: {:#?}", problem);
    }

    fn part2() {}
}

pub fn run() {
    Problem::part1();
    Problem::part2();
}
