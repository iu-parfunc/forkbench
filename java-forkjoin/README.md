Run with:

```
module add java/1.8
ant compile
ant jar
NUM_THREADS=8 java -jar build/jar/ForkBench.jar 10000000
```