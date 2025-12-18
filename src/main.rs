use clap::{Parser, Subcommand};

mod common;
mod day4;
mod day5;

#[derive(Parser)]
struct Root {
    #[clap(subcommand)]
    command: Command,
}

#[derive(Subcommand)]
enum Command {
    Day4,
    Day5,
}

fn main() {
    match Root::parse() {
        Root { command } => match command {
            Command::Day4 => day4::run(),
            Command::Day5 => day5::run(),
        },
    }
}
