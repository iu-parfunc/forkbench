#! /usr/bin/env racket
#lang racket

(require racket/future)

(printf "futures-enabled ~a, processors ~a\n"
        (futures-enabled?)
        (processor-count))

(define (spawnbench n)
  (if (zero? n)
      1
      (let-values ([(half r) (quotient/remainder n 2)])
        (let* ([half2 (+ half r)]
               [x (future (lambda () (spawnbench (sub1 half2))))]
               [y (spawnbench half)])
          (+ (touch x) y)))))

(define (seqbench n)
  (if (zero? n)
      1
      (let-values ([(half r) (quotient/remainder n 2)])
        (let* ([half2 (+ half r)]
               [x (seqbench (sub1 half2))]
               [y (seqbench half)])
          (+ x y)))))

(define n
  (match (current-command-line-arguments)
    [(vector s) (string->number s)]
    [other (error "expected one command line argument, got: " other)]))

(spawnbench n)
