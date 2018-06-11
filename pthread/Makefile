
CC = gcc

all: spawnbench install

spawnbench:
	$(CC) -pthread  -o spawntree spawntree.cc
	
install:
	cp -a spawntree ../bin/spawnbench-pthread.exe
