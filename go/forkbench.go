package main

import (
	"fmt"
	"os"
	"strconv"
)

func forkbench(n int) {
	if n == 0 {
		return
	}

	half1 := n / 2
	half2 := half1 + (n % 2)

	go forkbench(half2 - 1)
	forkbench(half1)
}

func spawnbench(n int) int {
	if n == 0 {
		return 0
	}
	half1 := n / 2
	half2 := half1 + (n % 2)

	c := make(chan int)
	go spawnbench2(half2-1, c)
	y := spawnbench(half1)
	x := <-c
	return x + y
}

func spawnbench2(n int, c chan int) {
	c <- spawnbench(n)
}

// spawnbench

/*
func Fib(n int) int {
        if n < 2 {
                return n
        }
        return Fib(n-1) + Fib(n-2)
}

 messages := make(chan string)
    go func() { messages <- "ping" }()

    msg := <-messages
    fmt.Println(msg)

*/

func main() {
	n, _ := strconv.Atoi(os.Args[1])
	fmt.Println(n)
	// forkbench(n)
	spawnbench(n)
}
