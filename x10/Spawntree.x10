package spawnbench;

public class Spawntree {
  static def spawntree(n:Long):Long {
    if(n == 0) return 1;
    val f1:Long = n/2;
    val f2:Long = f1 + (n % 2);
    val a:Long;
    val b:Long;
    finish {
      async a = spawntree(f2-1);
      b = spawntree(f1);
    }
    return a + b;
  }

  public static def main(args:Rail[String]) {
    val N = args.size > 0 ? Long.parseLong(args(0)) : 30;
    Console.OUT.println("Spawntree # is: " + spawntree(N));
  }
}
