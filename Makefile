
.phony: all

HTML= reports/cilk.html
# reports/hpx.html

# Building
# ----------------------------------------

all: reports build $(HTML)

build:
	stack install
	(cd hpx && make)
	(cd cilk && make nix)

reports:
	mkdir -p ./reports

# Running
# ----------------------------------------

# This one needs a long time
reports/hpx.html:
	./bin/criterion-external ./bin/hpx-spawnbench.exe --hpx-threads=1 -- -o reports/hpx.html -L 100

reports/cilk.html:
	./bin/criterion-external ./bin/cilk-spawnbench.exe --hpx-threads=1 -- -o reports/hpx.html -L 100
