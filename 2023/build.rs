fn main() {
    println!("cargo:rustc-link-arg-bins=-nostdlib");
    println!("cargo:rustc-link-arg-bins=-Tlink.ld");
    println!("cargo:rustc-link-arg-bins=-static");
}
