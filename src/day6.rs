use crate::common::matrix::Matrix;

const INPUT: &str = include_str!("./Day6.txt");

struct Problem {}

impl Problem {
    fn day1() {
        let input = INPUT.lines().collect::<Vec<&str>>();

        let (digits, operators) = input.split_at(input.len() - 1);
        let digits: Vec<Vec<usize>> = digits
            .iter()
            .map(|line| {
                line.split_whitespace()
                    .map(|num| num.parse().unwrap())
                    .collect()
            })
            .collect();
        let digits = Matrix::from(digits);

        let operators = operators.first().unwrap().split_whitespace();

        let mut ans = 0;

        for (index, op) in operators.enumerate() {
            let column = digits.column(index);
            match op {
                "+" => ans += column.into_iter().sum::<usize>(),
                "*" => ans += column.into_iter().product::<usize>(),
                _ => panic!("Invalid operator"),
            }
        }

        println!("Day 6, Part 1: {}", ans);
    }

    fn day2() {
        let input = INPUT.lines().collect::<Vec<&str>>();

        let (digits, operators) = input.split_at(input.len() - 1);
        let digits: Vec<Vec<char>> = digits.iter().map(|line| line.chars().collect()).collect();
        let mut operators = operators.first().unwrap().split_whitespace();
        let height = digits.len();
        let width = digits[0].len();
        let mut ans = 0;
        let mut batch: Vec<usize> = Vec::new();

        for column in 0..width {
            let mut buffer = String::new();
            for row in 0..height {
                let digit = digits[row][column];
                if digit.is_digit(10) {
                    buffer.push(digit);
                }
            }
            if !buffer.is_empty() {
                batch.push(buffer.parse().unwrap());
            } else {
                let op = operators.next().expect("not enough operators");
                let sub_total = match op {
                    "+" => batch.iter().sum::<usize>(),
                    "*" => batch.iter().product::<usize>(),
                    _ => panic!("Invalid operator"),
                };
                ans += sub_total;
                batch = vec![];
            }
        }

        if !batch.is_empty() {
            let op = operators.next().expect("not enough operators");
            let sub_total = match op {
                "+" => batch.iter().sum::<usize>(),
                "*" => batch.iter().product::<usize>(),
                _ => panic!("Invalid operator"),
            };
            ans += sub_total;
        }

        println!("Day 6, Part 2: {}", ans);
    }
}

pub fn run() {
    Problem::day1();
    Problem::day2();
}
