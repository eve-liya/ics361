;;;; File containing the moves for the 8 Tile puzzle


;; States are defined as a 1D list where every 3 elements are in it's own row.
;; 0 represents the empty space where tiles can slide into
;; validity of move is checked at the beginning of each move.

(DEFVAR *start* '(1 2 3 7 4 0 6 5 8))

(DEFVAR *goals* '((1 2 3 4 5 6 7 8 0)))

(DEFVAR *moves* '(slideUp slideDown slideLeft slideRight))

; - 3 from position of 0
; Slide up
; Invalid when 0 is first row
; When arr[i] = 0; i < 3
(DEFUN slideUp (state)
  (COND ((< (POSITION 0 state) 3) NIL)
        (T (swap state 0 (NTH (- (POSITION 0 state) 3) state)))))

; + 3 from position of 0
; Slide down
; Invalid when 0 is at last row
; When arr[i] = 0; i > 5
(DEFUN slideDown (state)
  (COND ((> (POSITION 0 state) 5) NIL)
        (T (swap state 0 (NTH (+ (POSITION 0 state) 3) state)))))

; -1 from position of 0
; Swap left
; invalid when on the left col
; When arr[i] = 0; i = 0, 3, 6
; When i % 3 = 0
(DEFUN slideLeft (state)
  (COND ((EQ (MOD (POSITION 0 state) 3) 0) NIL)
        (T (swap state 0 (NTH (- (POSITION 0 state) 1) state)))))

; +1 from position of 0
; Swap right
; invalid when on the right col
; When arr[i] = 0; i = 2, 5, 8
; When i % 3 = 2
(DEFUN slideRight (state)
  (COND ((EQ (MOD (POSITION 0 state) 3) 2) NIL)
        (T (swap state 0 (NTH (+ (POSITION 0 state) 1) state)))))

;; Swap elements e1 and e2
(DEFUN swap (state e1 e2)
  (COND ((NULL state) nil)
        ((EQ (CAR state) e1) (CONS e2 (swap (CDR state) e1 e2)))
        ((EQ (CAR state) e2) (CONS e1 (swap (CDR state) e1 e2)))
        (T (CONS (CAR state) (swap (CDR state) e1 e2)))))
