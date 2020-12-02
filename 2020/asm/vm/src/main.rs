use std::{cell::RefCell,fs::File, io::{self,Read,Write,Stdout,Stdin,Stderr}};
use rysk_core::Register32;

struct Mmu {
    memory: Box<[u8]>,
    program: Box<[u8]>,
    input: Box<[u8]>,
    exit_code: Option<u8>,
    stdin: RefCell<Stdin>,
    stdout: Stdout,
    stderr: Stderr
}
impl Mmu {
    const MEMORY_START: u32 = 0;
    const MEMORY_END: u32 = Self::MEMORY_START + 1024 * 1024 * 128;
    const ROM_START: u32 = Self::MEMORY_END + 1;
    const ROM_END: u32 = Self::ROM_START + 1024 * 1024 * 128;
    const INPUT_START: u32 = Self::ROM_END + 1;
    const INPUT_END: u32 = Self::INPUT_START + 1024 * 1024 * 8;
    const SHUTDOWN: u32 = u32::MAX;
    const STDIN: u32 = u32::MAX - 3;
    const STDOUT: u32 = u32::MAX - 2;
    const STDERR: u32 = u32::MAX - 1;
    fn new(size: usize, name: &str) -> io::Result<Self> {
        let mut program_file = File::open(format!("target/{}", name))?;
        let mut program = vec![];
        program_file.read_to_end(&mut program)?;
        let mut input_file = File::open(format!("../puzzle_input/{}", name))?;
        let mut input = vec![];
        input_file.read_to_end(&mut input)?;
        Ok(
            Self {
                memory: vec![0; size].into_boxed_slice(),
                program: program.into_boxed_slice(),
                input: input.into_boxed_slice(),
                exit_code: None,
                stdin: RefCell::new(io::stdin()),
                stdout: io::stdout(),
                stderr: io::stderr()
            }
        )
    }
}

impl rysk_core::Mmu<Register32> for Mmu {
    fn get(&self, index: u32) -> u8 {
        match index {
            Self::MEMORY_START..=Self::MEMORY_END => *self.memory.get(index as usize).expect("Read of unallocated memory"),
            Self::ROM_START..=Self::ROM_END => *self.program.get((index - Self::ROM_START) as usize ).expect("Read outside of program memory"),
            Self::INPUT_START..=Self::INPUT_END => *self.input.get((index - Self::INPUT_START) as usize ).expect("Read outside of input file memory"),
            Self::STDIN => {
                let mut input = [0; 1];
                self.stdin.try_borrow_mut().unwrap().read(&mut input).unwrap();
                input[0]
            }
            _ => panic!("Read of unmapped memory")
        }
    }
    fn set(&mut self, index: u32, value: u8) {
        match index {
            Self::MEMORY_START..=Self::MEMORY_END => *self.memory.get_mut(index as usize).expect("Write to unallocated memory") = value,
            Self::STDOUT => { self.stdout.write(&[value]).unwrap(); }
            Self::STDERR => { self.stderr.write(&[value]).unwrap(); }
            Self::SHUTDOWN => self.exit_code = Some(value),
            _ => panic!("Write to unmapped memory, {}", index)
        }
    }
}

fn main() {
    let program = std::env::args().skip(1).next().expect("The program name must be specified");
    // Allocate 8MB of memory
    let mut mmu = Mmu::new(1024 * 1024 * 8, &program).expect("Unable to load program");
    let mut core = rysk_core::Core::<Register32>::new(Mmu::ROM_START, 0);
    while mmu.exit_code == None {
        core.execute(&mut mmu)
    }
    std::process::exit(mmu.exit_code.unwrap() as _)
}
