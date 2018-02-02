
.phony: all

THREADS ?= 01

out = ./reports/$(THREADS)_thread/

HTML= $(out)/ghc-sparks.html $(out)/cloud-haskell.html \
      $(out)/io-threads.html $(out)/monad-par.html \
      $(out)/cilk.html $(out)/hpx.html $(out)/racket-futures.html

ALLBUILDS = build-haskell build-hpx build-cilk build-rust

.phony: all build rust hpx racket $(ALLBUILDS) docker run-docker docker-here docker-clean

# Building each benchmark into ./bin/
# ----------------------------------------

all: $(out) build $(HTML)

build: $(ALLBUILDS)

# Build ALL the Haskell-based implementations of this benchmark:
build-haskell:
	stack --system-ghc install

build-hpx:
	(cd hpx && make)

build-cilk:
	(cd cilk && make nix)

build-rust:
	cd rust && make

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


# Running
# ----------------------------------------

# Note: currently this dumps the criterion output for each benchmark.
# This should be improved to also gather/summarize the results.
# For example, HSBencher can import these criterion files to produce a summary.


# This one needs a long time
hpx: $(out) $(out)/hpx.html
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

rust: $(out) build-rust $(out)/rust-rayon.html
$(out)/rust-rayon.html: 
	NUM_THREADS=$(THREADS) ./bin/criterion-external ./bin/spawnbench-rust-rayon.exe -- -o $@ --csv $(out)/rust-rayon.csv -L 10

racket: $(out) build-racket $(out)/racket-futures.html
$(out)/racket-futures.html: 
	./bin/criterion-external ./racket/spawnbench.rkt \
          -- -o $@ --csv $(out)/racket-futures.csv -L 100


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

clean_checkout: $(shell git ls-files)
	git diff --exit-code
	rm -rf $@
	git clone . $@
