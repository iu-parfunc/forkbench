
X10CXX = ${X10_HOME}/bin/x10c++

all: spawnbench install

spawnbench:
	$(X10CXX) -O Spawntree.x10 -o Spawntree
	
install:
	cp -a Spawntree ../bin/spawnbench-x10.exe
