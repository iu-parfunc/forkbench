
all: spawnbench.exe forkbench.exe
	gcc --version

spawnbench.exe: spawnbench.c
	gcc -fcilkplus $^ -o $@

forkbench.exe: forkbench.c
	gcc -fcilkplus $^ -o $@
