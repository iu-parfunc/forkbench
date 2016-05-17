#!/bin/bash

# set -xe
set -e
source $stdenv/setup

mkdir $out

FILE=hpx-spawnbench
EXE=$FILE".exe"

INCLUDES=" -I$hpx/include -I$hpx/lib/libffi-3.99999/include/ "

set -x

# No, you can't pass an absolute path like this:
# gcc $INCLUDES -l:$hpx/lib/libhpx.so $src/spawnbench.c -o $out/$EXE

# You can do this, but it doesn't make a difference
# gcc $INCLUDES $hpx/lib/libhpx.so $src/spawnbench.c -o $out/$EXE


# Try compling to .o first:
gcc -c $INCLUDES $src/spawnbench.c -o ./spawnbench.o 

# ----------------------------------------
OPTS=
# OPTS+="-Wl,-dynamic-linker,/nix/store/bb32xf954imhdrzn7j8h82xs1bx7p3fr-glibc-2.23/lib/ld-linux-x86-64.so.2"

# Something is wrong if that has no effect:
# OPTS+="-Wl,-dynamic-linker=/TESTBROKEN"
# ^ Ok, good it does have an effect.  But weirdly NOT when run later
# outside of a nix environment.

# Perhaps this would prioritize the correct search location?
OPTS+=" -Wl,-rpath -Wl,$hpx/lib "
# -Wl,--verbose 
# ^ No, it appears to make no difference.

#OPTS+=" -Wl,-R$hpx/lib/ -Wl,--enable-new-dtags"

# gcc -v $OPTS $INCLUDES -L$hpx/lib -lhpx ./spawnbench.o -o $out/$EXE

# Also doesn't set RPATH according to `readelf -a`
# ld -rpath $hpx/lib --entry main -dynamic-linker $glibc/lib/ld-linux-x86-64.so.2 -L$hpx/lib -lhpx ./spawnbench.o -o $out/fib2.exe 
# ----------------------------------------


# Use static lib for HPX:
# ----------------------------------------
# LIBS="-L$hpx/lib -L$hwloc/lib $hpx/lib/libhpx.a -lpthread $hpx/lib/libffi.a $hpx/lib/libjemalloc.a -lhwloc "
LIBS="-L$hpx/lib -L$hwloc/lib $hpx/lib/libhpx.a $hpx/lib/libsync.a -lpthread -lffi -ljemalloc -lhwloc -lstdc++ "
gcc $INCLUDES ./spawnbench.o $LIBS -o $out/$EXE

set +x
echo "Here's a snapshot of the expected dynamic links:"
set -x

ldd $out/$EXE
# $out/$EXE 10  # a tiny run just for testing
readelf -a $out/$EXE | grep PATH

# ldd $out/fib2.exe
# $out/fib2.exe 10

set +x

