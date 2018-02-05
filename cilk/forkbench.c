#include <stdio.h>
#include <stdlib.h>

#include <cilk/cilk.h>

typedef unsigned long long uint64;

// This must execute EXACTLY n forks.
void forktree(uint64 n)
{
  if (n==0) return;

  // First we split without losing any:
  uint64 half1 = n / 2;
  uint64 half2 = half1 + (n % 2);
  
  cilk_spawn forktree(half2 - 1);
  forktree(half1);
}

int main(int argc, char** argv) {
  uint64 n;
  if (argc>1)
    n = atoi(argv[1]);
  else {
    printf("forkbench: expects one argument!\n");
    return 1;
  }
  forktree(n);
  return 0;
}
