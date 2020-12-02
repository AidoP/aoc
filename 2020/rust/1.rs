const INPUT_PATH: &'static str = "../puzzle_input/1";
use std::{fs::File, io::{self, BufRead, BufReader}, collections::BTreeSet};
fn main() -> io::Result<()> {
    let mut expenses = BTreeSet::default();
    for line in BufReader::new(File::open(INPUT_PATH)?).lines() {
        expenses.insert(str::parse::<u32>(&line?).expect("Malformed input file"));
    }
    if let Some((item1, item2)) = expenses.iter().find_map(|item1| expenses.iter().find_map(|item2| if item1 + item2 == 2020 { Some((item1, item2)) } else { None })) {
        println!("{} * {} = {}", item1, item2, item1 * item2)
    } else {
        println!("No match for part 1")
    }

    if let Some((item1, item2, item3)) = expenses.iter().find_map(|item1| expenses.iter().find_map(|item2| expenses.iter().find_map(|item3| if item1 + item2 + item3 == 2020 { Some((item1, item2, item3)) } else { None }))) {
        println!("{} * {} * {} = {}", item1, item2, item3, item1 * item2 * item3)
    } else {
        println!("No match")
    }
    Ok(())
}