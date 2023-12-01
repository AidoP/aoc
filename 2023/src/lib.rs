#![no_std]

#[panic_handler]
fn panic(_info: &core::panic::PanicInfo) -> ! {
    loop {}
}

#[link_section = ".rt-impl"]
#[no_mangle]
static RT_DATA: [u8; core::mem::size_of::<Rt>()] = [0; core::mem::size_of::<Rt>()];

extern {
    #[link_name = "RT_DATA"]
    static RT: Rt;
}

#[repr(C)]
struct Rt {
    write: extern "C" fn(i32, *const u8, usize) -> usize,
}
impl Rt {
    pub const fn new() -> Self {
        Self {
            write,
        }
    }
}

extern "C" fn write(fd: i32, str: *const u8, len: usize) -> usize { 0 }

pub fn println(str: &str) {
    unsafe { (RT.write)(1, str.as_ptr(), str.len()) };
}

