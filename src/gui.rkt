#lang racket
(require "matrix.rkt" "game-of-life.rkt" "board-canvas.rkt")
(require racket/gui/base)

(define board-rows 30)
(define board-cols 50)

(define board null)

(define (next-iteration) (set-board (next-iteration-stitch-edges board)))

(define timer-interval 200)

(define timer (new timer%
                   [notify-callback (lambda ()(next-iteration) (yield))]
                   [just-once? #f]))

(define (set-interval interval)
  (set! timer-interval interval)
  (start))

(define (start)
  (send timer start timer-interval))

(define (stop)
  (send timer stop))

(define (toggle-cell row col board)
  (define (opposite-state cell-state)
    (if (equal? cell-state alive) dead alive))
  (board-map-indexes (lambda (state r c)
                       (if (and (= row r) (= col c))
                           (opposite-state state)
                           state)) board))

(define (show-board board)
  (send canvas draw-board board))

(define (set-board new-board)
  (set! board new-board)
  (show-board board))

(define (save)
  (define file (put-file #f #f #f #f "bozeg" null '(("BOŽEG Files (*.bozeg)" "*.bozeg"))))
  (when file
    (define out (open-output-file file #:exists 'truncate))
    (write board out)
    (close-output-port out)))

(define (load)
  (define file (get-file #f #f #f #f "bozeg" null '(("BOŽEG Files (*.bozeg)" "*.bozeg"))))
  (when file
    (define in (open-input-file file))
    (set-board (read in))
    (close-input-port in)))

(define frame (new frame%
                   [label "BOŽEG"]
                   [width 1040]
                   [height 680]))

(define main-pane (new vertical-pane%
                       [parent frame]))

(define canvas-wrapper (new panel%
                            [parent main-pane]
                            [style '(auto-vscroll auto-hscroll)]))

(define canvas (new board-canvas%
                    [parent canvas-wrapper]
                    [on-click-callback
                     (lambda (row col)
                       (set-board (toggle-cell row col board)))]
                    [cell-width 20]
                    [cell-height 20]
                    [alive-color "LawnGreen"]
                    [dead-color "Black"]))

(define controls-pane (new horizontal-pane%
                           [parent main-pane]
                           [stretchable-height #f]))

(define button-start (new button%
                          [parent controls-pane]
                          [label "Start"]
                          [callback (lambda (b e) (start))]))

(define button-stop (new button%
                         [parent controls-pane]
                         [label "Stop"]
                         [callback (lambda (b e) (stop))]))

(define button-step (new button%
                         [parent controls-pane]
                         [label "Step"]
                         [callback (lambda (b e) (next-iteration))]))

(define slider (new slider%
                    [parent controls-pane]
                    [label "Speed"]
                    [style '(horizontal plain)]
                    [stretchable-width #f]
                    [min-value 0]
                    [max-value 1000]
                    [init-value 500]
                    [callback (lambda (s e)
                                (define interval (exact-floor (* 50 (expt 20 (- 1 (/ (send s get-value) 1000))))))
                                (set-interval interval))]))

(define button-save (new button%
                         [parent controls-pane]
                         [label "Save"]
                         [callback (lambda (b e) (stop) (save))]))


(define button-load (new button%
                         [parent controls-pane]
                         [label "Load"]
                         [callback (lambda (b e) (stop) (load))]))

(set-board (build-board board-rows board-cols (lambda (row col) dead)))

(send frame show #t)
