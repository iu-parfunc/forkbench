#!/bin/bash

echo "Hello world"

echo "Inputs are here: $src"
echo "Current dir: "`pwd`
echo "Output results go here: $out"

set -xe
source $stdenv/setup

mkdir $out
touch $out/foo
