
.phony: all

HTML= reports/cilk.html reports/hpx.html

# Building
# ----------------------------------------

all: reports build $(HTML)

build:
	stack install
	(cd hpx && make)
	(cd cilk && make nix)

reports:
	mkdir -p ./reports

clean:
	rm -f cilk/result hpx/result
	rm -f bin/*
#	rm -f $(HTML)

# Running
# ----------------------------------------

# This one needs a long time
reports/hpx.html:
	./bin/criterion-external ./bin/spawnbench-hpx.exe --hpx-threads=1 -- -o reports/hpx.html -L 100

reports/cilk.html:
	./bin/criterion-external ./bin/spawnbench-cilk.exe --hpx-threads=1 -- -o reports/cilk.html -L 10



reports/rust-rayon.html:
	./bin/criterion-external NUM_THREADS=1 ./bin/spawnbench-rust-rayon -- -o $@ --csv reports/rust-rayon.csv -L 10
