package parfunc;

import java.util.concurrent.*;
import java.util.*;

public class ForkBench {
    public static void main(String[] args) {
	try {
	    int n = Integer.parseInt(args[0]);
	    String readThreads = System.getenv("NUM_THREADS");
	    int threads = Integer.parseInt(readThreads);
	    ForkJoinPool forkJoinPool = new ForkJoinPool(threads);
	    Bencher b = new Bencher(n);
	    System.out.println(forkJoinPool.invoke(b));
	} catch (Exception e) {
	    System.err.println("Invalid input.");
	    System.exit(1);
	}
	
    }

    private static class Bencher extends RecursiveTask<Integer> {
	private int steps;

	public Bencher(int steps) {
	    this.steps = steps;
	}

	@Override
	protected Integer compute() {
	    if (steps == 0) {
		return 1;
	    } else {
		int half1 = this.steps / 2;
		int half2 = half1 + (this.steps % 2);
		Bencher subtask1 = new Bencher(half2 - 1);
		Bencher subtask2 = new Bencher(half1);
		subtask1.fork();
		subtask2.fork();
		int ret = subtask1.join() + subtask2.join();
		return ret;
	    }
	}
    }
}
