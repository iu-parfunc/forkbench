// =============================================================================
//  High Performance ParalleX Library (libhpx)
//
//  Copyright (c) 2013-2016, Trustees of Indiana University,
//  All rights reserved.
//
//  This software may be modified and distributed under the terms of the BSD
//  license.  See the COPYING file for details.
//
//  This software was created at the Indiana University Center for Research in
//  Extreme Scale Technologies (CREST).
// =============================================================================

/// @file
/// A simple fibonacci number computation to demonstrate HPX.
/// This example calculates a fibonacci number using recursion, where each
/// level of recursion is executed by a different HPX thread. (Of course, this
/// is not an efficient way to calculate a fibonacci number but it does
/// demonstrate some of the basic of HPX and it may demonstrate a
/// <em>pattern of computation</em> that might be used in the real world.)

#include <signal.h>
#include <unistd.h>
#include <stdio.h>
#include <stdlib.h>
#include <inttypes.h>
#include "hpx/hpx.h"

static void _usage(FILE *f, int error) {
  fprintf(f, "Usage: spawnbench [options] NUMBER\n"
          "\t-h, show help\n");
  hpx_print_help();
  fflush(f);
  exit(error);
}

static hpx_action_t _spawntree      = 0;
static hpx_action_t _spawntree_main = 0;

static int _spawntree_action(int *args, size_t size) {
  int n = *args;

  // printf("spawntree called on %d\n", n);
  
  if (n <= 0) {
    int one = 1;
    return HPX_THREAD_CONTINUE(one);
  }

  hpx_addr_t peers[] = {
    HPX_HERE,
    HPX_HERE
  };

  int ns[] = {
    (n / 2) - 1,
    (n / 2) + (n % 2) - 1
  };

  hpx_addr_t futures[] = {
    hpx_lco_future_new(sizeof(int)),
    hpx_lco_future_new(sizeof(int))
  };

  int fns[] = {
    0,
    0
  };

  void *addrs[] = {
    &fns[0],
    &fns[1]
  };

  size_t sizes[] = {
    sizeof(int),
    sizeof(int)
  };
  
  hpx_call(peers[0], _spawntree, futures[0], &ns[0], sizeof(int));
  hpx_call(peers[1], _spawntree, futures[1], &ns[1], sizeof(int));
  hpx_lco_get_all(2, futures, sizes, addrs, NULL);
  hpx_lco_delete(futures[0], HPX_NULL);
  hpx_lco_delete(futures[1], HPX_NULL);

  // printf(" -> spawntree got returns: %d and %d\n", fns[0], fns[1]);
  
  int fn = fns[0] + fns[1];
  return HPX_THREAD_CONTINUE(fn);
}

static int _spawntree_main_action(int *args, size_t size) {
  int n = *args;
  int fn = 0;                                   // spawntree result
  printf("spawntree(%d)=", n); fflush(stdout);
  hpx_time_t now = hpx_time_now();

  hpx_call_sync(HPX_HERE, _spawntree, &fn, sizeof(fn), &n, sizeof(n));
  double elapsed = hpx_time_elapsed_ms(now)/1e3;

  printf("%d\n", fn);
  printf("seconds: %.7f\n", elapsed);
  printf("localities: %d\n", HPX_LOCALITIES);
  printf("threads/locality: %d\n", HPX_THREADS);
  hpx_exit(HPX_SUCCESS);
}

int main(int argc, char *argv[]) {
  // register the spawntree action
  HPX_REGISTER_ACTION(HPX_DEFAULT, HPX_MARSHALLED, _spawntree, _spawntree_action,
                      HPX_POINTER, HPX_SIZE_T);
  HPX_REGISTER_ACTION(HPX_DEFAULT, HPX_MARSHALLED, _spawntree_main, _spawntree_main_action,
                      HPX_POINTER, HPX_SIZE_T);

  int e = hpx_init(&argc, &argv);
  if (e) {
    fprintf(stderr, "HPX: failed to initialize.\n");
    return e;
  }

  // parse the command line
  int opt = 0;
  while ((opt = getopt(argc, argv, "h?")) != -1) {
    switch (opt) {
     case 'h':
       _usage(stdout, EXIT_SUCCESS);
     case '?':
     default:
       _usage(stderr, EXIT_FAILURE);
    }
  }

  argc -= optind;
  argv += optind;

  int n = 0;
  switch (argc) {
   case 0:
     fprintf(stderr, "\nMissing spawntree number.\n"); // fall through
   default:
     _usage(stderr, EXIT_FAILURE);
   case 1:
     n = atoi(argv[0]);
     break;
  }

  // run the main action
  e = hpx_run(&_spawntree_main, &n, sizeof(n));
  hpx_finalize();
  return e;
}

