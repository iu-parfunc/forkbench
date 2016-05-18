
.phony: all

THREADS ?= 01

out = ./reports/$(THREADS)_thread/

HTML= $(out)/ghc-sparks.html $(out)/cloud-haskell.html \
      $(out)/io-threads.html $(out)/monad-par.html \
      $(out)/cilk.html $(out)/hpx.html

ALLBUILDS = build-haskell build-hpx build-cilk build-rust

.phony: all build run-rust run-hpx $(ALLBUILDS)

# Building
# ----------------------------------------

all: $(out) build $(HTML)

build: $(ALLBUILDS)

build-haskell:
	stack install

build-hpx:
	(cd hpx && make)

build-cilk:
	(cd cilk && make nix)

build-rust:
	cd rust && make

$(out):
	mkdir -p $(out)

clean:
	rm -f cilk/result hpx/result
	rm -f bin/*
#	rm -f $(HTML)

# Running
# ----------------------------------------

# This one needs a long time
run-hpx: $(out) $(out)/hpx.html
$(out)/hpx.html:
	./bin/criterion-external ./bin/spawnbench-hpx.exe --hpx-threads=$(THREADS) \
          -- -o $@ --csv $(out)/hpx.csv -L 100

$(out)/cilk.html:
	CILK_NWORKERS=$(THREADS) ./bin/criterion-external ./bin/spawnbench-cilk.exe \
          -- -o $@ --csv $(out)/cilk.csv -L 10

$(out)/monad-par.html:
	./bin/forkbench-monad-par -o $@ --csv $(out)/monad-par.csv +RTS -N$(THREADS)

$(out)/io-threads.html:
	./bin/forkbench-io-threads.exe -o $@ --csv $(out)/io-threads.csv +RTS -N$(THREADS)

$(out)/ghc-sparks.html:
	./bin/forkbench-ghc-sparks -o $@ --csv $(out)/ghc-sparks.csv +RTS -N$(THREADS)

$(out)/cloud-haskell.html:
	./bin/forkbench-cloud-haskell -o $@ --csv $(out)/cloud-haskell.csv -L 10 +RTS -N$(THREADS)

run-rust: $(out) $(out)/rust-rayon.html
$(out)/rust-rayon.html: 
	NUM_THREADS=$(THREADS) ./bin/criterion-external ./bin/spawnbench-rust-rayon.exe -- -o $@ --csv $(out)/rust-rayon.csv -L 10
