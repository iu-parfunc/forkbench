#include "spawnbench.decl.h"

struct Main : public CBase_Main {
  Main(CkArgMsg* m) { 
    int n=30;
    if(m->argc >1 ) n = atoi(m->argv[1]);
    CProxy_Spawntree::ckNew(n, true, CProxy_Spawntree()); 
  }
};

struct Spawntree : public CBase_Spawntree {
  Spawntree_SDAG_CODE

  CProxy_Spawntree parent; bool isRoot;

  Spawntree(int n, bool isRoot_, CProxy_Spawntree parent_)
    : parent(parent_), isRoot(isRoot_) {
    calc(n);
  }

  void respond(int val) {
    if (!isRoot) {
      if (val == 0) {
        parent.response(1);
      } else {
        parent.response(val);
      }
      delete this;
    } else {
      CkPrintf("Spawntree # is: %d\n", val);
      CkExit();
    }
  }
};

#include "spawnbench.def.h"

