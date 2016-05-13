
# On Cutter do "module add gcc" to get a new version of GCC.

CC=gcc
OUTDIR=../bin/

all: $(OUTDIR)/spawnbench-cilk.exe $(OUTDIR)/forkbench-cilk.exe
	$(CC) --version

$(OUTDIR)/spawnbench-cilk.exe: spawnbench.c
	$(CC) -fcilkplus $^ -o $@

$(OUTDIR)/forkbench-cilk.exe: forkbench.c
	$(CC) -fcilkplus $^ -o $@
