
// 0, 1, 1, 2, 3, 5, 8, 13, 21, 34, ...

/*
config const n: int = 10;

var arg1in: sync int;
var arg1out: sync int = 0;

var arg2out: sync int = 1;

var result: sync int;

proc arg1supplier() {
  var newval: int;
  do {
    newval = arg1in;
    arg1out = newval;
  } while (newval != -1);
}

proc arg2supplier() {
  var newval: int;
  do {
    newval = result;
    arg2out = newval;
  } while (newval != -1);
}

proc fibcomputer() {
  if (n > 1) {
    output(1, 0);
    if (n > 2) {
      output(2, 1);
    }
  }
  for i in 3..n do {
    var arg1val: int = arg1out;
    var arg2val: int = arg2out;
    var resultval = arg1val + arg2val;
    output(i, resultval);
    if (i == n) {
      arg1in = -1;
      result = -1;
    } else {
      arg1in = arg2val;
      result = resultval;
    }
  }
}
*/

proc spawntree(n) : int
{
  if (n==0) {
    return 1;
  } else {

    var half1 : int = n / 2;
    var half2 : int = half1 + (n % 2);
    
    // We subtract one from our total, because of *this* spawn:
    var x : int;
    var y : int;
    cobegin {
      x = spawntree(half2 - 1);
      y = spawntree(half1);
    }
    return x + y;
  }
}


proc main() {
  // TODO: Read argument from command line.
  var n : int = 30;
  var y : int = spawntree(n);
  writeln("spawntree #", n, " is: ", y);
}

