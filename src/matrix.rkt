#lang racket

(define (build-matrix row-count col-count proc)
  (build-list row-count
              (lambda (row)
                (build-list col-count (lambda (col) (proc row col))))))

(define (matrix-ref matrix row col)
  (list-ref (list-ref matrix row) col))

(define (matrix-rows matrix)
  (length matrix))

(define (matrix-columns matrix)
  (length (car matrix)))

(define (matrix-row-ref matrix i)
  (list-ref matrix i))

(define (matrix-col-ref matrix i)
  (map (lambda (row) (list-ref row i)) matrix))

(define (matrix-map proc . matrices)
  (apply map (cons (lambda rows (apply map (cons proc rows))) matrices)))

(define (matrix-print matrix)
  (for-each println matrix))

(provide (all-defined-out))
