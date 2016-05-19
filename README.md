# forkbench

A simple, standalone parfib-like benchmark.

This benchmark performs a binary tree of strictly nested spawn/join
pairs.  Each benchmark is structured so as to take a parameter, `N`,
and perform exactly `N` spawn join pairs.

Making the benchmark linear in its input parameter allows us to employ
linear regression to accurately compute the exact per-spawn overhead
in each implementation.  It also lets us compare implementations with
vastly different performance (e.g. threads versus tasks) which is
difficult using a traditional parfib scheduler microbenchmark.

We use the criterion benchmarking tool to drive the benchmarks and
perform the linear regression.


