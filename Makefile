
.phony: all

HTML= reports/cilk.html reports/hpx.html reports/monad-par.html \
    reports/ghc-sparks.html reports/cloud-haskell.html reports/io-threads.html

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
	./bin/criterion-external ./bin/spawnbench-hpx.exe --hpx-threads=1 \
          -- -o $@ --csv reports/hpx.csv -L 100

reports/cilk.html:
	CILK_NWORKERS=1 ./bin/criterion-external ./bin/spawnbench-cilk.exe \
          -- -o $@ --csv reports/cilk.csv -L 10

reports/monad-par.html:
	./bin/forkbench-monad-par -o $@ --csv reports/monad-par.csv +RTS -N1

reports/io-threads.html:
	./bin/forkbench-io-threads.exe -o $@ --csv reports/io-threads.csv +RTS -N1

reports/ghc-sparks.html:
	./bin/forkbench-ghc-sparks -o $@ --csv reports/ghc-sparks.csv +RTS -N1

reports/cloud-haskell.html:
	./bin/forkbench-cloud-haskell -o $@ --csv reports/cloud-haskell.csv -L 10 +RTS -N1
