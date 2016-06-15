

# Manticore 2016.03.08:
# SNAP=nixpkgs=https://github.com/iu-parfunc/nixpkgs/archive/42f1ba17e8fe8d899bfee0ed95d693c7d51e8e57.tar.gz
# Manticore 2014.08.18:
SNAP=nixpkgs=https://github.com/iu-parfunc/nixpkgs/archive/tag-hpx-3.0.0-a.tar.gz

all:
	NIX_PATH=$(SNAP) nix-shell -p manticore --run "pmlc -o spawnbench-manticore.exe spawnbench.pml"
	rm -f ../bin/*-manticore*
#	cp -f result/* ../bin/
	cp -f *.exe ../bin/
