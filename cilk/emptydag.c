
#include <stdio.h>
#include <stdlib.h>

// #include <cilk/cilk.h>

#include <sys/time.h>
#include <sys/resource.h>

//--------------------------------------------------------
// General utilities:

double get_time()
{
    struct timeval t;
    struct timezone tzp;
    gettimeofday(&t, &tzp);
    return t.tv_sec + t.tv_usec*1e-6;
}

//--------------------------------------------------------

typedef unsigned long long uint64;

typedef void(*action_t)(uint64);

typedef struct {
  //  uint64* edges;
  //  uint64* verts; // Offsets into edges.  
  uint64 size;
  action_t* runs;
} dag_t;


// EMPTY computation.
void run_fun(uint64 vertid)
{
}


// TODO: Read DAG from disk or standardize randomized graph generator.
dag_t* generate_dag(uint64 n)
{
  dag_t* d = (dag_t*)malloc(sizeof(dag_t));
  d->size = n;
  d->runs = (action_t*)malloc(sizeof(action_t) * n);
  for(uint64 i=0; i<n; i++) d->runs[i] = &run_fun;
  return d;
}

void sequential_run_dag(dag_t* dag)
{
  for(int v=0; v < dag->size; v++) {
    (dag->runs[v])(v);
  }
}


// TODO: Parallel DAG traversal




int main(int argc, char** argv)
{
  uint64 n;
  if (argc>1)
    n = atoll(argv[1]);
  else {
    printf("empty-DAG: expects one argument!\n");
    return 1;
  }

  dag_t* d = generate_dag(n);
  double st = get_time();
  sequential_run_dag(d);
  double en = get_time();  
  printf("SELFTIMED: %lf\n", en-st);  
  return 0;
}
