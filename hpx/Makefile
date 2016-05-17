
# Which software snapshot should we use?
# This grabs our branch of nixpkgs with hpx 3.0:
SNAP=nixpkgs=https://github.com/iu-parfunc/nixpkgs/archive/hpx-3.0.0.tar.gz

all:
	NIX_PATH=$(SNAP)  nix-build
	cp result/* ../bin/
