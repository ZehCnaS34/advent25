const INPUT: &str = include_str!("./Day5.txt");

#[derive(Debug)]
struct Problem {
    id_ranges: Vec<IdRange>,
    ids: Vec<Id>,
}

impl Problem {
    fn load() -> Self {
        let mut iter = INPUT.split("\n\n");
        let id_ranges = String::from(iter.next().unwrap());
        let ids = String::from(iter.next().unwrap());

        let id_ranges = id_ranges
            .split("\n")
            .map(|id| IdRange::try_from(String::from(id)).unwrap())
            .collect::<Vec<IdRange>>();
        let ids = ids
            .split("\n")
            .map(|id| id.parse().map_err(|_| "Invalid ID".to_string()))
            .collect::<Result<Vec<Id>, String>>()
            .unwrap();

        Problem {
            id_ranges: merge_ranges(id_ranges),
            ids,
        }
    }

    fn id_in_ranges(&self, id: &Id) -> bool {
        self.id_ranges
            .binary_search_by(|range| {
                if range.contains(id) {
                    std::cmp::Ordering::Equal
                } else if *id < range.start {
                    std::cmp::Ordering::Greater
                } else {
                    std::cmp::Ordering::Less
                }
            })
            .is_ok()
    }
}

type Id = u64;

#[derive(Debug, Clone, PartialEq, Eq, PartialOrd, Ord)]
struct IdRange {
    start: Id,
    end: Id,
}

impl IdRange {
    fn contains(&self, id: &Id) -> bool {
        self.start <= *id && *id <= self.end
    }

    fn overlaps(&self, other: &IdRange) -> bool {
        other.start <= self.end
    }

    fn merge(&self, other: IdRange) -> IdRange {
        IdRange {
            start: self.start.min(other.start),
            end: self.end.max(other.end),
        }
    }

    fn size(&self) -> usize {
        (self.end - self.start + 1) as usize
    }
}

impl TryFrom<String> for IdRange {
    type Error = String;

    fn try_from(value: String) -> Result<Self, Self::Error> {
        let parts: Vec<&str> = value.split('-').collect();
        if parts.len() != 2 {
            return Err("Invalid format".to_string());
        }
        let start = parts[0].parse().map_err(|_| "Invalid start".to_string())?;
        let end = parts[1].parse().map_err(|_| "Invalid end".to_string())?;
        Ok(IdRange { start, end })
    }
}

fn merge_ranges(ranges: Vec<IdRange>) -> Vec<IdRange> {
    let mut ranges = ranges;
    ranges.sort_by_key(|r| r.start);

    let mut merged: Vec<IdRange> = Vec::new();
    for r in ranges.iter() {
        if merged.is_empty() || !merged.last().unwrap().overlaps(r) {
            merged.push(r.clone());
        } else {
            let last = merged.pop().unwrap();
            merged.push(last.merge(r.clone()));
        }
    }
    merged
}

fn part1() {
    let problem = Problem::load();
    let count = problem
        .ids
        .iter()
        .filter(|id| problem.id_in_ranges(*id))
        .count();
    println!("Day 5 Part 1: {}", count);
}

fn part2() {
    let problem = Problem::load();
    let total_sizes: usize = problem.id_ranges.iter().map(|rng| rng.size()).sum();
    println!("Day 5 Part 2: {}", total_sizes);
}

pub fn run() {
    part1();
    part2();
}
