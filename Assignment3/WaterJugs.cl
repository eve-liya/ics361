;;;; File containing the moves for the Water Jugs problem

;;; State is represented by (0 0)
;;; First number represents the 5 gallon jug water level
;;; Second number represents the 3 gallon jug water level
;;; Starting state (0 0) no water in each jug
(DEFVAR *start* '(0 0))
;;; Goal is (4 x) since 3 gallon jug can't hold 4 gallons
(DEFVAR *goals* '((4 0) (4 1) (4 2) (4 3)))
;; List of moves
(DEFVAR *moves* '(p3o p5o f3 f5 p53 p35))

;; A simple heuristic, the closer you are to 4 then the closer you are to the goal
(DEFUN hn (state)
  (abs (- 4 (NTH 0 state)))
  )

;; valid states
(DEFUN validity (state)
  (COND
   ((> (NTH 0 state) 5) NIL)
   ((> (NTH 1 state) 3) NIL)
   ((< (NTH 0 state) 0) NIL)
   ((< (NTH 1 state) 0) NIL)
   (T state)))

;; pour the 3 gallon jug out do i really need to check if valid here?
(DEFUN p3o (state)
  (COND ((EQ (NTH 1 state) 0) NIL)
        (T (validity (LIST (NTH 0 state) 0)))))

;; pour the 5 gallon jug out
(DEFUN p5o (state)
  (COND ((EQ (NTH 0 state) 0) NIL)
        (T (validity (LIST 0 (NTH 1 state))))))

;; Fill 3 gallon jug from spout
(DEFUN f3 (state)
  (COND ((EQ (NTH 1 state) 3) NIL)
        (T (LIST (NTH 0 state) 3))))

;; Fill 5 gallon jug from spout
(DEFUN f5 (state)
  (COND ((EQ (NTH 0 state) 5) NIL)
        (T (LIST 5 (NTH 1 state)))))

;; Pour 5 gallon jug into 3 gallon jug  
;; space left in 3 gallon = (3 - curr3)
;; pour either whats in the 5 gallon jug or (3 - curr3)
;; curr5 -= pourAmount
(DEFUN p53 (state)
  ;; can't pour empty jug
  (COND ((EQ (NTH 0 state) 0) NIL)
        ((< (NTH 0 state) (- 3 (NTH 1 state))) (validity (LIST 0 (+ (NTH 1 state) (NTH 0 state)))))
        (T (validity (LIST (- (NTH 0 state) (- 3 (NTH 1 state))) (+ (NTH 1 state) (- 3 (NTH 1 state))))))))

;; Pour 5 gallon jug into 3 gallon jug  
;; space left in 3 gallon = (3 - curr3)
;; pour either whats in the 5 gallon jug or (3 - curr3)
;; curr5 -= pourAmount
(DEFUN p35 (state)
  ;; can't pour empty jug
  (COND ((EQ (NTH 1 state) 0) NIL)
        ((< (NTH 1 state) (- 5 (NTH 0 state))) (validity (LIST (+ (NTH 0 state) (NTH 1 state)) 0)))
        (T (validity (LIST (+ (NTH 0 state) (- 5 (NTH 0 state))) (- (NTH 1 state) (- 5 (NTH 0 state))))))))