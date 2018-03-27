
# On Cutter do "module add gcc" to get a new version of GCC.

out ?= ./build

CC=gcc

all: spawnbench forkbench emptydag
	$(CC) --version

$(out)/spawnbench-cilk.exe: spawnbench.c
	mkdir -p $(out)
	$(CC) -fcilkplus $^ -o $@

$(out)/forkbench-cilk.exe: forkbench.c
	mkdir -p $(out)
	$(CC) -fcilkplus $^ -o $@

$(out)/empty-DAG.exe: emptydag.c
	mkdir -p $(out)
	$(CC) -fcilkplus $^ -o $@

# Convenience:
spawnbench: $(out)/spawnbench-cilk.exe
forkbench:  $(out)/forkbench-cilk.exe
emptydag:   $(out)/empty-DAG.exe

.PHONY: install all nix emptydag forkbench spawnbench

install:

#----------------------------------------

# Here we use the same NIX_PATH as hpx just to reduce install time:
nix:
	NIX_PATH=nixpkgs=https://github.com/iu-parfunc/nixpkgs/archive/hpx-3.0.0.tar.gz  nix-build
	cp -f result/*.exe ../bin
