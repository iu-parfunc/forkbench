#!/bin/bash

echo "Hello world"

echo "Inputs are here: $src"
echo "Current dir: "`pwd`
echo "Output results go here: $out"

# set -xe
set -e
source $stdenv/setup

mkdir $out

INCLUDES=" -I$hpx/include -I$hpx/lib/libffi-3.99999/include/ "

set -x

gcc -Wl,-rpath=$hpx/lib $INCLUDES -L$hpx/lib -lhpx $src/fibonacci.c -o $out/fib.exe

# gcc $INCLUDES $hpx/lib/libhpx.so $src/fibonacci.c -o $out/fib.exe

set +x

echo "Here's a snapshot of the expected dynamic links:"
ldd $out/fib.exe

$out/fib.exe 10
