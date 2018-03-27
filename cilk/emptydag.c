
#include <stdio.h>
#include <stdlib.h>

// #include <cilk/cilk.h>

#include <sys/time.h>
#include <sys/resource.h>

typedef unsigned long long uint64;

typedef uint64 vert_id;
typedef void(*action_t)(uint64);

typedef struct {
  vert_id* edges;  // Concatenated chunks of per-vertex edges.
  uint64* verts;   // Offsets into edges.
  uint64* degree; // Count of edges per vert.
  uint64 size;
  action_t* runs;
  // TODO: in_counters for fetch-and-decrements...
  // TODO: out_sets for fetch-and-decrements...
} dag_t;


//--------------------------------------------------------
// General utilities:

double get_time()
{
    struct timeval t;
    struct timezone tzp;
    gettimeofday(&t, &tzp);
    return t.tv_sec + t.tv_usec*1e-6;
}

uint64 min(uint64 x, uint64 y) {
  if (x<y) return x;
  else return y;
}

//--------------------------------------------------------

// EMPTY computation.
void run_fun(uint64 vertid)
{
}


// TODO: Read DAG from disk or standardize randomized graph generator.
// This generates a topological sort directly:
dag_t* generate_dag(uint64 nVert, double avg_degree)
{
  dag_t* d = (dag_t*)malloc(sizeof(dag_t));
  d->size = nVert;
  d->runs = (action_t*)malloc(sizeof(action_t) * nVert);

  // All tasks use the same function pointer for now:
  for(uint64 i=0; i<nVert; i++) d->runs[i] = &run_fun;

  d->verts  = (uint64*)malloc(sizeof(uint64) * nVert);
  d->degree = (uint64*)malloc(sizeof(uint64) * nVert);
  
  // This should use a, e.g., an stl-vector so it can grow:
  uint64 max_edges = (uint64)(avg_degree * (double)nVert + 1000);
  d->edges = (vert_id*)malloc(sizeof(uint64) * max_edges);
  
  uint64 edge_cursor = 0;
  
  // Hackishly stop producing edges if we run out of space:
  for(uint64 i=0; i<nVert; i++) {    
    uint64 edges = rand() % (uint64)(1.9 * avg_degree);
    if (i==0 || edge_cursor >= max_edges)
      edges=0;
    else 
      edges = min(edges, max_edges - edge_cursor);
    d->degree[i] = edges;
    // printf("Adding %d edges, edge cursor %d, max_edges %d\n", edges, edge_cursor, max_edges);
    
    for (uint64 j=0; j<edges; j++)
      // LAME graph, just a random vert to the left of us in topo sort:
      d->edges[edge_cursor+j] = rand() % i;

    edge_cursor += edges;
  }
  
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

  dag_t* d = generate_dag(n, 10.0);
  double st = get_time();
  sequential_run_dag(d);
  double en = get_time();  
  printf("SELFTIMED: %lf\n", en-st);  
  return 0;
}
