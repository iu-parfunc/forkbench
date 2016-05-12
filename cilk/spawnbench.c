#include <stdio.h>
#include <stdlib.h>

#include <cilk/cilk.h>

typedef unsigned long long uint64;

// This must execute EXACTLY n forks.
uint64 spawntree(uint64 n) {
  // printf("Spawntree of %d\n", n);
  if (n==0) return 1;

  // First we split without losing any:
  uint64 half1 = n / 2;
  uint64 half2 = half1 + (n % 2);
  
  // We subtract one from our total, because of *this* spawn:
  uint64 x = cilk_spawn spawntree(half2 - 1);
  uint64 y = spawntree(half1);
  cilk_sync; 
  return x + y;
}

int main(int argc, char** argv) {
  uint64 n;
  if (argc>1)
    n = atoi(argv[1]);
  else {
    printf("spawnbench: expects one argument!\n");
    return 1;
  }
  uint64 r = spawntree(n);
  printf("Result: %llu\n", r);
  return 0;
}
