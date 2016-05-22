package parfunc;

import java.util.concurrent.*;
import java.util.*;

public class ForkBench {

    public static void main(String[] args) {
	try {
	    int n = Integer.parseInt(args[0]);
	    String readThreads = System.getenv("NUM_THREADS");
	    int threads = Integer.parseInt(readThreads);
	    Bencher.invoke(n, threads);
	} catch (Exception e) {
	    System.err.println("Invalid input.");
	    System.exit(1);
	}
	
    }

    private static class Bencher extends RecursiveTask<Integer> {
	private int steps;

	public static int invoke(int n, int threads) {
	    ForkJoinPool forkJoinPool = new ForkJoinPool(threads);
	    Bencher b = new Bencher(n);
	    return forkJoinPool.invoke(b);
	}

	private Bencher(int steps) {
	    this.steps = steps;
	}

	private static int work(int steps) {
	    if (steps == 0) {
		return 1;
	    } else {
		int half1 = steps / 2;
		int half2 = half1 + (steps % 2);
		Bencher subtask = new Bencher(half2 - 1);
		subtask.fork();
		int a = work(half1);
		int b = subtask.join();
		return a + b;
	    }
	}

	@Override
	protected Integer compute() {
	    return work(steps);
	}
    }
}
