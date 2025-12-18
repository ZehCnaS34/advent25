use clap::{Parser, Subcommand};

mod common;
mod day4;

#[derive(Parser)]
struct Root {
    #[clap(subcommand)]
    command: Command,
}

#[derive(Subcommand)]
enum Command {
    Day4,
}

fn main() {
    match Root::parse() {
        Root { command } => match command {
            Command::Day4 => day4::run(),
        },
    }
}
