#lang racket
(require "matrix.rkt")

(define build-board build-matrix)

(define board->matrix identity)

(define matrix->board identity)

(define alive 'alive)

(define dead 'dead)

(define (matrix-slice matrix-ref-proc)
  (lambda (matrix origin-row origin-col rows cols)
    (build-matrix rows cols
                  (lambda (row col)
                    (matrix-ref-proc matrix (+ origin-row row) (+ origin-col col))))))

(define matrix-slice-fill-missing
  (lambda (el)
    (matrix-slice
     (lambda (matrix row col)
       (let ([rows (matrix-rows matrix)]
             [cols (matrix-cols matrix)])
         (if (and (>= row 0) (< row rows) (>= col 0) (< col cols))
             (matrix-ref matrix row col)
             el))))))

(define matrix-slice-stitch-edges
  (matrix-slice
   (lambda (matrix row col)
     (define rows (matrix-rows matrix))
     (define cols (matrix-cols matrix))
     (matrix-ref matrix (modulo row rows) (modulo col cols)))))

(define (get-neighborhood slice-proc)
  (lambda (matrix row col)
    (slice-proc matrix (- row 1) (- col 1) 3 3)))

(define get-neighborhood-dead-edges (get-neighborhood (matrix-slice-fill-missing dead)))

(define get-neighborhood-stitch-edges (get-neighborhood matrix-slice-stitch-edges))

(define (alive-neighbors-count slice)
  (define state->number (lambda (state) (if (equal? state alive) 1 0)))
  (- (apply + (matrix->list (matrix-map state->number slice)))
     (state->number (matrix-ref slice 1 1))))

(define (next-cell-state-from-numbers current-state alive-neighbors)
  (cond [(equal? alive-neighbors 2) current-state]
        [(equal? alive-neighbors 3) alive]
        [else dead]))

(define (next-cell-state matrix row col)
  (define neighbors (get-neighborhood-stitch-edges matrix row col))
  (define alive-neighbors (alive-neighbors-count neighbors))
  (define current-state (matrix-ref matrix row col))
  (next-cell-state-from-numbers current-state alive-neighbors))

(define (next-iteration neighborhood-proc)
  (lambda (board)
    (define matrix (board->matrix board))
    (define rows (matrix-rows board))
    (define cols (matrix-cols board))
    (build-board
     rows cols
     (lambda (row col)
       (next-cell-state matrix row col)))))

(define next-iteration-stitch-edges (next-iteration get-neighborhood-stitch-edges))

(define next-iteration-dead-edges (next-iteration get-neighborhood-dead-edges))

(provide build-board
         board->matrix
         matrix->board
         alive
         dead
         next-iteration-stitch-edges
         next-iteration-dead-edges)
