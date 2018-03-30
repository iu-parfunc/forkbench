
CHARMC = ~/git/charm/bin/charmc $(OPTS)

OBJS = spawnbench.o

all: spawnbench

spawnbench: $(OBJS)
	$(CHARMC) -language charm++ -o spawnbench $(OBJS)

spawnbench.decl.h: spawnbench.ci
	$(CHARMC)  spawnbench.ci

clean:
	rm -f *.decl.h *.def.h conv-host *.o spawnbench charmrun

spawnbench.o: spawnbench.C spawnbench.decl.h
	$(CHARMC) -c spawnbench.C
