
CHPL = chpl

all: spawntree install

spawntree:
	$(CHPL) -o spawntree spawntree.chpl

	
install:
	cp -a spawntree ../bin/spawnbench-chapel.exe
