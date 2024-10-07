;; This program uses a Binary Search Algorithm to guess a specific number
;; Defines a variable called *small* and initializes it to 1
(defparameter *small* 1)
;; Defines a variable called *big* and initializes it to 100
(defparameter *big* 100)

;; Defines a function called guess-my-number
(defun guess-my-number ()
     ;; Does an arithmetic right shift on the sum of *small* and *big*
     ;; This effectively translates to (*small* + *big*)/2 
     ;; Which finds the midpoint between the current values of *small* and *big*
     (ash (+ *small* *big*) -1))

;; Defines a function called smaller
(defun smaller ()
     ;; Subtracts 1 from *big* then calls the function guess-my-number
     (setf *big* (1- (guess-my-number)))
     (guess-my-number))

(defun bigger ()
     ;; Adds  1 from *small* then calls the function guess-my-number
     (setf *small* (1+ (guess-my-number)))
     (guess-my-number))

;; Defines a function to reset the values of *small* and *big* then calls guess-my-number to restart
(defun start-over ()
   (setf *small* 1)
   (setf *big* 100)
  (guess-my-number))


