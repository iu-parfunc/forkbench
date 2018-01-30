FROM dist-compile-o-rama:0.1

# Build clean_checkout with the Makefile first:
ADD . /forkbench

WORKDIR /forkbench/ocr
