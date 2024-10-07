;;;; The Depth First Search algorithm that is problem agnostic

;;;; Nodes are defined as such (CurrentState ((PrevParent) (PrevParent) (PrevParent))


;;; Initial starter function
(DEFUN depth-first (start goals moves)
  ;; provide the open list (with initial node), 
  ;; the closed list (initially empty), goals and moves
  (dfs (LIST (LIST start '())) '() goals moves)
  T)

;;; Helper DFS function that can pass through the open and closed lists
(DEFUN dfs (open close goals moves)
  ;; If the open list is empty then no solution?
  (COND ((NULL open) NIL)
        ;; Prints the first node on the open list
        ;; If the current state is in the goals list we are done. Return the first node on the open list
        ((mymember (CAR (CAR open)) goals) (FORMAT t "First node on open list: ~S~%Found goal: ~S.~% Solution path: ~S.~% Length of open list: ~D.~% Length of closed list: ~D~%" (CAR open) goals (REVERSE (CONS (CAR (CAR open)) (CAR (CDR (CAR open))))) (LENGTH open) (LENGTH close))  T)
        ;; If the current state is in the closed list, move on without the current state
        ((mymember (CAR (CAR open)) close) (FORMAT t "First node on open list: ~S~%" (CAR open)) (dfs (CDR open) close goals moves))
        ;; If the current state is in the rest of the open state, move on without the current state
        ((mymember (CAR (CAR open)) (CDR open)) (FORMAT t "First node on open list: ~S~%" (CAR open)) (dfs (CDR open) close goals moves))
        ;; Else, generate the children and add them to the FRONT of the open list
        (T (FORMAT t "First node on open list: ~S~%" (CAR open))
           ;; 1. Call generate-chidren on the current node (generate-children (CAR open) moves)
           ;; 2. Add it to the FRONT of the open list, while getting rid of the current node (CDR open)
           ;; 3. Add the current node to the closed list. (CONS (CAR open) close)
           ;; 4. Pass the same goals and moves
           ;; 5. Recursively call the bfs with the new open and closed lists. 
           (dfs (APPEND (generate-children (CAR open) moves) (CDR open))
                (CONS (CAR open) close) goals moves))))


;;;; The Breadth First Search algorithm that is problem agnostic

;;; Initial starter function
(DEFUN breadth-first (start goals moves)
  ;; provide the open list (with initial node), 
  ;; the closed list (initially empty), goals and moves
  (bfs (LIST (LIST start '())) '() goals moves))

;;; Helper BFS function that can pass through the open and closed lists
(DEFUN bfs (open close goals moves)
  ;; If the open list is empty then no solution?
  (COND ((NULL open) NIL)
        ;; If the current state is in the goals list we are done. Return the first node on the open list
        ((mymember (CAR (CAR open)) goals) (FORMAT t "First node on open list: ~S~%Found goal: ~S.~% Solution path: ~S.~% Length of open list: ~D.~% Length of closed list: ~D~%" (CAR open) goals (REVERSE (CONS (CAR (CAR open)) (CAR (CDR (CAR open))))) (LENGTH open) (LENGTH close))  T)
        ;; If the current state is in the closed list, move on without the current state
        ((mymember (CAR (CAR open)) close) (FORMAT t "First node on open list: ~S~%" (CAR open)) (bfs (CDR open) close goals moves))
        ;; If the current state is in the rest of the open state, move on without the current state
        ((mymember (CAR (CAR open)) (CDR open)) (FORMAT t "First node on open list: ~S~%" (CAR open)) (bfs (CDR open) close goals moves))
        ;; Else, generate the children and add them to the END of the open list
        (T (FORMAT t "First node on open list: ~S~%" (CAR open))
           ;; 1. Call generate-chidren on the current node (generate-children (CAR open) moves)
           ;; 2. Add it to the END of the open list, while getting rid of the current node (CDR open)
           ;; 3. Add the current node to the closed list. (CONS (CAR open) close)
           ;; 4. Pass the same goals and moves
           ;; 5. Recursively call the bfs with the new open and closed lists. 
           (bfs (APPEND (CDR open) (generate-children (CAR open) moves))
                (CONS (CAR open) close) goals moves))))


;;; Helper function to generate the valid children from a given node
(DEFUN generate-children (node moves)
  (COND
   ;; Base case: no more moves, return NIL
   ((NULL moves) NIL) 
   ;; If the result of applying the move is NIL, continue with the next move
   ((NULL (FUNCALL (CAR moves) (CAR node))) (generate-children node (CDR moves)))
   ;; Must have the node in the correct format specified above (Line 9)
   ;; 1. Use FUNCALL to call the first move on the current state. (FUNCALL (CAR moves) (CAR node)
   ;; 2. Add the current state to the previous path (CONS (CAR node) (CAR (CDR node)))
   ;; 3. Add the state after applying move to the front of the node (CONS (FUNCALL (CAR moves) (CAR node)) (LIST (CONS (CAR node) (CAR (CDR node)))))
   ;; 4. Call generate-children with the rest of the moves
   ;; 5. Return a list of all the generated nodes
   (T (CONS (CONS (FUNCALL (CAR moves) (CAR node))
                  (LIST (CONS (CAR node) (CAR (CDR node))))) 
            (generate-children node (CDR moves))))))

;;; Helper function myMember to check if an item is in a list
(DEFUN myMEMBER (look in)
  ;; If the list we are looking for in is empty then return NIL
  (COND ((NULL in) NIL)
        ;; If this is the item return true
        ((EQUAL look (CAR in)) T)
        ;; If the first item of "in" is then call myMember on list and the rest of the list
        ;; If either of these return true then the item is in the list
        ((listp (car in)) (OR (myMember look (car in)) (myMember look (cdr in))))
        ;; Look through the rest of the list
        (T (myMEMBER look (CDR in)))))
