
extern crate rayon;

// use std::io;
use rayon::*;
use std::env;

fn spawntree(n : u64) -> u64 {
    if n == 0 {
        1 
    } else {
        let half1 = n / 2;
        let half2 = half1 + (n % 2);
        let (x,y) = join( || spawntree(half2-1),
                          || spawntree(half1));
        x+y
    }
}

fn main() {
    if env::args().count() != 2 {
        panic!("Expects exactly one argument!");
    }
    match env::args().last() {
        None => panic!("Expects exactly one argument!"),
        Some(num) => {
            print!("spawntree({:?}) = ", num); 
            let res = spawntree( num.parse::<u64>().unwrap() );
            println!("{}",res);
        }
    }
}
