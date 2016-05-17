
# On Cutter do "module add gcc" to get a new version of GCC.

CC=gcc

all: $(out)/spawnbench-cilk.exe $(out)/forkbench-cilk.exe
	$(CC) --version

$(out)/spawnbench-cilk.exe: spawnbench.c
	mkdir -p $(out)
	$(CC) -fcilkplus $^ -o $@

$(out)/forkbench-cilk.exe: forkbench.c
	mkdir -p $(out)
	$(CC) -fcilkplus $^ -o $@

install:

#----------------------------------------

nix:
	NIX_PATH=nixpkgs=https://github.com/iu-parfunc/nixpkgs/archive/hpx-3.0.0.tar.gz  nix-build
	cp -f result/*.exe ../bin
