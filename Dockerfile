FROM dist-compile-o-rama:0.1

# Build clean_checkout with the Makefile first:
ADD . /forkbench

RUN cd /forkbench && make build-haskell

# RUN 

WORKDIR /forkbench/
