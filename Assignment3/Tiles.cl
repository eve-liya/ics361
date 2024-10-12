;;;; File containing the moves for the 8 Tile puzzle


;; States are defined as a 1D list where every 3 elements are in it's own row.
;; 0 represents the empty space where tiles can slide into
;; validity of move is checked at the beginning of each move.

(DEFCONSTANT *tile-start-dfs* '(1 2 3 4 0 6 7 5 8))

(DEFCONSTANT *tile-start-1* '(1 2 3 4 8 5 7 0 6))

(DEFCONSTANT *tile-start-2* '(8 6 3 2 1 4 7 5 0))

(DEFCONSTANT *tile-goals* '((1 2 3 4 5 6 7 8 0)))

(DEFCONSTANT *tile-moves* '(slideUp slideDown slideRight slideLeft))

;; Tiles out of place heuristic
(DEFCONSTANT *top-hn* 'tiles-out-of-place)

;; Manhattan distance heuristic
(DEFCONSTANT *manhattan-hn* 'manhattan-distance)

;; Starter function for tiles out of place
(DEFUN tiles-out-of-place (state)
  (tiles-out-of-place-helper state 1))

;; Compares the current tile with what should be there 
(DEFUN tiles-out-of-place-helper (state num)
  ;; Done with the board add C0
  (COND ((null state) 0)
        ;; Skip if 0
        ((EQ (CAR state) 0) (tiles-out-of-place-helper (CDR state) (+ 1 num)))
        ;; if it's not equal to the correct num, add one 
        ((not (EQ (CAR state) num)) (+ 1 (tiles-out-of-place-helper (CDR state) (+ 1 num))))
        ;; if it's equal then don't add one
        (T (tiles-out-of-place-helper (CDR state) (+ 1 num)))))

;; Starter function for manhattan distance
(DEFUN manhattan-distance (state)
  (manhattan-distance-helper state 0))

;; Helper function for mahattan distance
(DEFUN manhattan-distance-helper (state index)
  ;; end of board
  (COND ((null state) 0)
        ;; if it's 0 skip, 
        ((EQ (CAR state) 0) (manhattan-distance-helper (CDR state) (+ 1 index)))
        ;; add the two differences together
        ;; use modulo and floor to find the goal position for column and row
        ;; use abs to get the absolute difference
        (T (+ (+ (abs (- (MOD (- (CAR state) 1) 3) (MOD index 3)))
                 (abs (- (FLOOR (- (CAR state) 1) 3) (FLOOR index 3))))
              ;; call again with the rest of the list and next current index
              (manhattan-distance-helper (CDR state) (+ 1 index))))))

; - 3 from position of 0
; Slide 0 up
; Invalid when 0 is first row
; When arr[i] = 0; i < 3
(DEFUN slideUp (state)
  (COND ((< (POSITION 0 state) 3) NIL)
        (T (swap state 0 (NTH (- (POSITION 0 state) 3) state)))))

; + 3 from position of 0
; Slide 0 down
; Invalid when 0 is at last row
; When arr[i] = 0; i > 5
(DEFUN slideDown (state)
  (COND ((> (POSITION 0 state) 5) NIL)
        (T (swap state 0 (NTH (+ (POSITION 0 state) 3) state)))))

; -1 from position of 0
; slide 0 left
; invalid when on the left col
; When arr[i] = 0; i = 0, 3, 6
; When i % 3 = 0
(DEFUN slideLeft (state)
  (COND ((EQ (MOD (POSITION 0 state) 3) 0) NIL)
        (T (swap state 0 (NTH (- (POSITION 0 state) 1) state)))))

; +1 from position of 0
; slide 0 right
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
