
.phony: all

THREADS ?= 1

out = ./reports/$(THREADS)_thread/

HTML= $(out)/ghc-sparks.html $(out)/cloud-haskell.html \
      $(out)/io-threads.html $(out)/monad-par.html \
      $(out)/cilk.html $(out)/hpx.html

.phony: all build

# Building
# ----------------------------------------

all: $(out) build $(HTML)

build:
	stack install
	(cd hpx && make)
	(cd cilk && make nix)

$(out):
	mkdir -p $(out)

clean:
	rm -f cilk/result hpx/result
	rm -f bin/*
#	rm -f $(HTML)

# Running
# ----------------------------------------

# This one needs a long time
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
