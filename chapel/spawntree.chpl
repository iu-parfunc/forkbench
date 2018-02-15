config var n : int = 30;

proc spawntree(x: int) : int {
  if x == 0 then {
    return 1;
  } else {
    var half1 : int = x / 2;
    var half2 : int = half1 + (x % 2);

    // 
    // var a, b: int
    // cobegin {
    //   a = spawntree(half2 - 1);
    //   b = spawntree(half1);
    // }
    //
    // Cannot use cobegin as it will spawn two tasks

    // begin in Chapel is a fire-and-forget way to launch a task
    // in order to have the same synchronization as other benchmarks
    // a single variable is used. 

    var a$: single int; // state is empty, value is 0 (default)

    // When this task computes, the state of a$ will become full
    begin a$ = spawntree(half2 - 1);
    
    // do the other
    var b: int = spawntree(half1);

    // The state of a$ must be full before it can be read.     
    return a$ + b; 
  }
} 
  
var y : int = spawntree(n);
writeln("spawntree #", n, " is: ", y); 
