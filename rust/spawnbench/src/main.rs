
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

    let threads =
        match std::env::var("NUM_THREADS") {
            Ok(str) => str.parse::<usize>().unwrap(),
            _ => panic!("Environment variable NUM_THREADS not set.")
        };
    { // Initialize the threadpool (optional):
        let conf = rayon::Configuration::new().set_num_threads(threads);
        println!("Running with threads = {:?}", conf.num_threads());
        initialize(conf).unwrap();
    }
    
    match env::args().last() {
        None => panic!("Expects exactly one argument!"),
        Some(num) => {
            print!("spawntree({:?}) = ", num); 
            let res = spawntree( num.parse::<u64>().unwrap() );
            println!("{}",res);
        }
    }

    // These seem bogus currently, it just prints zeros: [2016.05.17]
    // dump_stats();
}
