
.PHONY: build run

build:
	ant compile
	ant jar
	cp build/jar/ForkBench.jar ../bin/

run:
	NUM_THREADS=$(THREADS) java -jar build/jar/ForkBench.jar 1000 -XX:-AggressiveOpts -XX:-TieredCompilation
