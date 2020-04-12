#lang racket
(require "matrix.rkt")

(define build-board build-matrix)

(define board->matrix identity)

(define matrix->board identity)

(define (board-map proc board)
  (matrix->board (matrix-map proc (board->matrix board))))

(define (board-map-indexes proc board)
  (define matrix (board->matrix board))
  (define rows (matrix-rows matrix))
  (define cols (matrix-cols matrix))
  (build-board rows cols (lambda (row col)
                           (proc (matrix-ref matrix row col) row col))))

(define (board-for-each board proc)
  (define matrix (board->matrix board))
  (define rows (matrix-rows matrix))
  (define cols (matrix-cols matrix))
  (for ([row (range rows)])
    (for ([col (range cols)])
      (proc row col (matrix-ref matrix row col)))))

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
       (define rows (matrix-rows matrix))
       (define cols (matrix-cols matrix))
       (if (and (>= row 0) (< row rows) (>= col 0) (< col cols))
           (matrix-ref matrix row col)
           el)))))

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
  (cond [(= alive-neighbors 2) current-state]
        [(= alive-neighbors 3) alive]
        [else dead]))

(define (next-cell-state neighborhood-proc matrix row col)
  (define neighbors (neighborhood-proc matrix row col))
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
       (next-cell-state neighborhood-proc matrix row col)))))

(define next-iteration-stitch-edges (next-iteration get-neighborhood-stitch-edges))

(define next-iteration-dead-edges (next-iteration get-neighborhood-dead-edges))

(provide build-board
         board->matrix
         matrix->board
         board-map
         board-map-indexes
         board-for-each
         alive
         dead
         next-iteration-stitch-edges
         next-iteration-dead-edges)
