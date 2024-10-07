(0 0) ; 5 gallon jug 3 gallon jug 
      ; invariants:
      ; first jug cannot go over 5
      ; second jug cannot go over 3

; goal (4 x)

; Moves
; pour all of 5 gallon jug out
; pour all of 3 gallon jug out
; fill 5 gallon jug all
; fill 3 gallon jug all
; pour 3 gallon jug in 5 gallon jug, add rest of 3 gallon into 5 gallon. Eg. curr5 = curr5 + curr3; cap at 5?; curr3 = 5 - curr5 || 0
; pour 5 gallong jug in 3 gallon jug, 2 gallons left in 5 gallon, 3 gallon full.