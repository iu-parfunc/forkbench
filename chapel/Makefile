
CHPL = chpl

all: spawntree install

spawntree:
	$(CHPL) --no-checks -o spawntree spawntree.chpl

	
install:
	cp -a spawntree ../bin/spawnbench-chapel.exe
