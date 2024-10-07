;;;; File containing the moves for the Missionaries and Cannibals problem.

;;; State is represented by (numCannibalsWest numMissionariesWest whichSideBoat)
;; Starting state with 3 cannibals, 3 missionaries and boat all on the west side
(DEFVAR *start* '(3 3 W))
;; Goal: all people have crossed the river
(DEFVAR *goals* '((0 0 E)))
;; All possible moves since boat can carry at most two people.
(DEFVAR *moves* '(c1 c2 m1 m2 cm))

;; If cannibals outnumber the missionaries on either side then it's invalid state return NIL
;; Check to see if we have a valid amount of people on the west, 
;; can't be more than 3 can't be less than 0
;; Check if cannibals > missionaries on west side
;; Maybe check   ((EQ (NTH 0 state) (NTH 1 state)) T) 
;; CCC MMM |
(DEFUN validState (state)
  (COND
   ((> (NTH 0 state) 3) NIL)
   ((> (NTH 1 state) 3) NIL)
   ((< (NTH 0 state) 0) NIL)
   ((< (NTH 1 state) 0) NIL)
   ; All missionaries can be on the east side
   ((EQ (NTH 1 state) 0) state)
   ((EQ (- 3 (NTH 1 state)) 0) state)
   ; More cannibals on the west side than other side invalid
   ((> (- 3 (NTH 0 state)) (- 3 (NTH 1 state))) NIL)
   ((> (NTH 0 state) (NTH 1 state)) NIL)
   (T state)))

;; A function to move one Cannibal from either the west or the east 
;; depending on the initial direction of the boat
(DEFUN C1 (state)
  (COND
   ; If on the west subtract one cannibal
   ((EQ (NTH 2 state) 'W) (validState (LIST (- (NTH 0 state) 1) (NTH 1 state) 'e)))
   ; Else add one cannibal to the west side
   (T (validState (LIST (+ (NTH 0 state) 1) (NTH 1 state) 'w)))))

;; A function to move two Cannibals from either the west or the east 
;; depending on the initial direction of the boat, returns NIL if resulting state is invalid
(DEFUN C2 (state)
  (COND
   ; If on the west subtract two cannibals
   ((EQ (NTH 2 state) 'W) (validState (LIST (- (NTH 0 state) 2) (NTH 1 state) 'e)))
   ; Else add two cannibals to the west side
   (T (validState (LIST (+ (NTH 0 state) 2) (NTH 1 state) 'w)))))

;; A function to move one Missionary from either the west or the east 
;; depending on the initial direction of the boat
(DEFUN M1 (state)
  (COND
   ; If on the west subtract one missionary
   ((EQ (NTH 2 state) 'W) (validState (LIST (NTH 0 state) (- (NTH 1 state) 1) 'e)))
   ; Else add one missionary to the west side
   (T (validState (LIST (NTH 0 state) (+ (NTH 1 state) 1) 'w)))))

;; A function to move two missionaries from either the west or the east 
;; depending on the initial direction of the boat, returns NIL if resulting state is invalid
(DEFUN M2 (state)
  (COND
   ; If on the west subtract two missionaries

   ((EQ (NTH 2 state) 'W) (validState (LIST (NTH 0 state) (- (NTH 1 state) 2) 'e)))

   ; Else add two missionaries to the west side

   (T (validState (LIST (NTH 0 state) (+ (NTH 1 state) 2) 'w)))))

;; A function to move one cannibal and one missionary from either the west or the east 
;; depending on the initial direction of the boat, returns NIL if resulting state is invalid
(DEFUN CM (state)
  (COND
   ; If on the west subtract one cannibal and one missionary
   ((EQ (NTH 2 state) 'W) (validState (LIST (- (NTH 0 state) 1) (- (NTH 1 state) 1) 'e)))
   ; Else add one cannibal and one missionary
   (T (validState (LIST (+ (NTH 0 state) 1) (+ (NTH 1 state) 1) 'w)))))