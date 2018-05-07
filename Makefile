# HOWTO:
# 
# This Makefile contains a set of different actions to build and then
# run specific implementations of the benchmark (build-X, X).
# It also contains some commands for using Docker.


.phony: all

THREADS ?= 01

out = ./reports/$(THREADS)_thread/

HTML= $(out)/ghc-sparks.html $(out)/cloud-haskell.html \
      $(out)/io-threads.html $(out)/monad-par.html \
      $(out)/cilk.html $(out)/racket-futures.html \
      $(out)/charm-chare.html $(out)/chapel.html

ALLBUILDS = build-haskell build-cilk build-charm build-rust build-chapel

.phony: all build run-all rust racket $(ALLBUILDS) docker run-docker docker-here docker-clean

# Building each benchmark into ./bin/
# ----------------------------------------

all: $(out) build run-all

run-all: $(HTML)

build: $(ALLBUILDS)

# Build ALL the Haskell-based implementations of this benchmark:
build-haskell:
	stack --system-ghc install

build-cilk:
	cd cilk && make

build-charm:
	cd charm && make

build-rust:
	cd rust && make

build-chapel:
	cd chapel && make

build-racket:
	raco make racket/spawnbench.rkt

build-manticore:
	cd manticore && make

build-java-forkjoin:
	cd java-forkjoin && make

$(out):
	mkdir -p $(out)

clean:
	rm -f cilk/result hpx/result
	rm -f bin/*
#	rm -f $(HTML)


# Distributed systems (but running shared-memory):
#-------------------------------------------------

#build-hpx:
#	(cd hpx && make)

build-chapel:
	(cd chapel && make)

# Running
# ----------------------------------------

# Note: currently this dumps the criterion output for each benchmark.
# This should be improved to also gather/summarize the results.
# For example, HSBencher can import these criterion files to produce a summary.

chapel: $(out) $(out)/chapel.html


# This one needs a long time
#hpx: $(out) $(out)/hpx.html
#$(out)/hpx.html:
#	./bin/criterion-external ./bin/spawnbench-hpx.exe --hpx-threads=$(THREADS) \
#          -- -o $@ --csv $(out)/hpx.csv -L 100

$(out)/cilk.html:
	CILK_NWORKERS=$(THREADS) ./bin/criterion-external ./bin/spawnbench-cilk.exe \
          -- -o $@ --csv $(out)/cilk.csv -L 10

# These don't use criterion-external because they link the criterion library into the executables:
$(out)/monad-par.html:
	./bin/forkbench-monad-par -o $@ --csv $(out)/monad-par.csv +RTS -N$(THREADS)

$(out)/io-threads.html:
	./bin/forkbench-io-threads.exe -o $@ --csv $(out)/io-threads.csv +RTS -N$(THREADS)

$(out)/ghc-sparks.html:
	./bin/forkbench-ghc-sparks -o $@ --csv $(out)/ghc-sparks.csv +RTS -N$(THREADS)

$(out)/cloud-haskell.html:
	./bin/forkbench-cloud-haskell -o $@ --csv $(out)/cloud-haskell.csv -L 10 +RTS -N$(THREADS)

rust: $(out) build-rust $(out)/rust-rayon.html
$(out)/rust-rayon.html: 
	NUM_THREADS=$(THREADS) ./bin/criterion-external ./bin/spawnbench-rust-rayon.exe -- -o $@ --csv $(out)/rust-rayon.csv -L 10

racket: $(out) build-racket $(out)/racket-futures.html
$(out)/racket-futures.html: 
	./bin/criterion-external ./racket/spawnbench.rkt \
          -- -o $@ --csv $(out)/racket-futures.csv -L 100

charm: $(out) build-charm $(out)/charm-chare.html
$(out)/charm-chare.html:
	./bin/criterion-external ./bin/spawnbench-charm-chare.exe \
	    $(THREADS) +p$(THREADS) +setcpuaffinity \
	    -- -o $@ --csv $(out)/charm-chare.csv -L 100

chapel: $(out) build-chapel $(out)/chapel.html
$(out)/chapel.html:
	./bin/criterion-external ./bin/spawnbench-chapel.exe \
	    --n=$(THREADS) -- -o $@ --csv $(out)/chapel.csv -L 100


manticore: $(out) build-manticore $(out)/manticore.html
run-manticore: $(out) $(out)/manticore.html
$(out)/manticore.html: 
	./bin/criterion-external ./bin/spawnbench-manticore.exe -p $(THREADS) \
          -- -o $@ --csv $(out)/manticore.csv -L 10;
#	if [ "$(THREADS)" == "02" ]; then \
         echo "Manticore fails at 2 threads"; \
        else ./bin/criterion-external ./bin/spawnbench-manticore.exe -p $(THREADS) \
          -- -o $@ --csv $(out)/manticore.csv -L 10; \
        fi

java-forkjoin: $(out) build-java-forkjoin $(out)/java-forkjoin.html
run-java-forkjoin: $(out) $(out)/java-forkjoin.html

# FIXME: Should really use a regression methodology where we start up the JVM once:
# For now we just run for a really long time.  This gets to ~100M spawns on 1 thread:
$(out)/java-forkjoin.html: 
	NUM_THREADS=$(THREADS) ./bin/criterion-external "java -XX:-AggressiveOpts -XX:-TieredCompilation -jar ./bin/ForkBench.jar" \
          -- -o $@ --csv $(out)/java-forkjoin.csv -L 100;


# Docker
#-----------------------------------------

# This option does the Docker build "out of place" to avoid an
# excessively large copy from the working space.
docker-clean: clean_checkout .docker_base_image_verified.token
	cd clean_checkout && docker build -t forkbench .

docker: docker-here
docker-here: .docker_base_image_verified.token
	docker build -t forkbench .

# Hacky, but what can you do with Docker?
BASEIMG=$(shell head -n1 Dockerfile  | awk '{ print $$2 }')

.docker_base_image_verified.token:
	docker run ${BASEIMG} || (cd compile-o-rama && make docker2)
	docker run ${BASEIMG}
	touch $@

run-docker:
	docker run -it forkbench 

# Create a clean copy of the working directory within a subdirectory.
clean_checkout: $(shell git ls-files)
	git diff --exit-code
	rm -rf $@
	git clone . $@
