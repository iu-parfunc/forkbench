
extern crate rayon;

// use std::io;
use rayon::*;

fn main() {

    join( || println!("Hello"),
          || println!("world!") );
}
