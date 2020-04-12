#lang racket
(require "matrix.rkt" "game-of-life.rkt")
(require racket/gui/base)

(define (draw-cell dc row col width height state grid-color alive-color dead-color)
  (send dc set-brush (if (equal? state alive) alive-color dead-color) 'solid)
  (send dc set-pen grid-color 1 'solid)
  (send dc draw-rectangle (* width col) (* height row) width height))

(define (draw-board-to-dc dc board width height grid-color alive-color dead-color)
  (board-for-each board
                  (lambda (row col state)
                    (draw-cell dc row col width height state grid-color alive-color dead-color))))

(define board-canvas%
  (class canvas%
    (super-new)
    (init-field on-click-callback
                [cell-width 10]
                [cell-height 10]
                [grid-color (make-object color% 32 32 32)]
                [alive-color "White"]
                [dead-color "Black"])
    (inherit get-dc refresh)
    (define board-internal null)
    (define/public (draw-board board)
      (set! board-internal board)
      (define matrix (board->matrix board))
      (send this min-width (* (matrix-cols matrix) cell-width))
      (send this min-height (* (matrix-rows matrix) cell-height))
      (refresh))
    (define/override (on-paint)
      (when (not (null? board-internal))
        (draw-board-to-dc (get-dc) board-internal cell-width cell-height grid-color alive-color dead-color)))
    (define/override (on-event event)
      (when (equal? (send event get-event-type) 'left-down)
        (define x (send event get-x))
        (define y (send event get-y))
        (on-click-callback (quotient y cell-height) (quotient x cell-width))))))

(provide board-canvas%)
