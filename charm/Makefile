
CHARMC = /usr/local/charm/bin/charmc $(OPTS)

OBJS = spawnbench.o

all: spawnbench install

spawnbench: $(OBJS)
	$(CHARMC) -optimize -production -language charm++ -o spawnbench $(OBJS)

spawnbench.decl.h: spawnbench.ci
	$(CHARMC)  spawnbench.ci

clean:
	rm -f *.decl.h *.def.h conv-host *.o spawnbench charmrun

spawnbench.o: spawnbench.C spawnbench.decl.h
	$(CHARMC) -optimize -production -c spawnbench.C
	
install:
	cp -a spawnbench ../bin/spawnbench-charm-chare.exe
