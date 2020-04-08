#lang racket

(define (build-matrix row-count col-count proc)
  (build-list row-count
              (lambda (row)
                (build-list col-count (lambda (col) (proc row col))))))

(define (matrix-ref matrix row col)
  (list-ref (list-ref matrix row) col))

(define (matrix-rows matrix)
  (length matrix))

(define (matrix-cols matrix)
  (length (car matrix)))

(define (matrix-row-ref matrix i)
  (list-ref matrix i))

(define (matrix-col-ref matrix i)
  (map (lambda (row) (list-ref row i)) matrix))

(define (matrix-map proc . matrices)
  (apply map (lambda rows (apply map proc rows)) matrices))

(define matrix->list-of-lists identity)

(define list-of-lists->matrix identity)

(define (matrix->list matrix)
  (foldr append '() matrix))

(define (list->matrix rows cols list)
  (build-matrix rows cols (lambda (row col)
                            (list-ref list (+ (* row rows) col)))))

(define (matrix-print matrix)
  (for-each (lambda (row) (for-each (lambda (el) (display el) (display " ")) row) (newline)) matrix))

(provide (all-defined-out))
