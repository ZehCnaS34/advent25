use clap::{Parser, Subcommand};

mod common;
mod day4;
mod day5;
mod day6;
mod day7;
mod day8;

#[derive(Parser)]
struct Root {
    #[clap(subcommand)]
    command: Command,
}

#[derive(Subcommand)]
enum Command {
    Day4,
    Day5,
    Day6,
    Day7,
    Day8,
}

fn main() {
    match Root::parse() {
        Root { command } => match command {
            Command::Day4 => day4::run(),
            Command::Day5 => day5::run(),
            Command::Day6 => day6::run(),
            Command::Day7 => day7::run(),
            Command::Day8 => day8::run(),
        },
    }
}
