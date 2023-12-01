#![no_std]
#![no_main]

extern crate aoc;

#[link_section = ".entry"]
#[export_name = "aoc"]
pub extern "C" fn aoc() {
    aoc::println("apples\n");
}
