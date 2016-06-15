package parfunc;

import java.util.concurrent.*;
import java.util.*;

public class ForkBench {

    public static void main(String[] args) {
	try {
	    int n = Integer.parseInt(args[0]);
	    String readThreads = System.getenv("NUM_THREADS");
	    int threads = Integer.parseInt(readThreads);
	    long res = Bencher.invoke(n, threads);
            System.err.println(res);
	} catch (Exception e) {
	    System.err.println("Invalid input.");
	    System.exit(1);
	}
	
    }

    private static class Bencher extends RecursiveTask<Long> {
	private long steps;

	public static long invoke(long n, int threads) {
	    ForkJoinPool forkJoinPool = new ForkJoinPool(threads);
	    Bencher b = new Bencher(n);
	    return forkJoinPool.invoke(b);
	}

	private Bencher(long steps) {
	    this.steps = steps;
	}

	private static long work(long steps) {
	    if (steps == 0) {
		return 1;
	    } else {
		long half1 = steps / 2;
		long half2 = half1 + (steps % 2);
		Bencher subtask = new Bencher(half2 - 1);
		subtask.fork();
		long a = work(half1);
		long b = subtask.join();
		return a + b;
	    }
	}

	@Override
	protected Long compute() {
	    return work(steps);
	}
    }
}
