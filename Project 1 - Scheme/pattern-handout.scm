#lang scheme

;;;; code for a program to create closures that generate ascii patterns

;;; patterns: a pattern is represented by a list of 4 elements:  pattern, numrows, numcols and fn
;;; where:
;;;   pattern is just the symbol pattern
;;;   fn is a function (ie a closure) of two parameters:  row, column that returns the character
;;;     at the given row and column of the pattern.  If row is out of bounds ie row<0 or 
;;;     row>=numrows, or similarly for col, fn returns the character #\. (a period character)
;;;   numrows is the number of rows in the pattern
;;;   numcols is the number of columns in the pattern
;;; the following are functions to create and access a pattern
;;; note that make-pattern adds bounds checking to fn
(define (make-pattern numrows numcols fn)
  (list 'pattern numrows numcols (add-check fn numrows numcols)))
(define (pattern-numrows pattern)(cadr pattern))
(define (pattern-numcols pattern)(caddr pattern))
(define (pattern-fn pattern) (cadddr pattern))

;;; for-n takes three arguments:  start and stop, which are numbers, and fn 
;;; which is a function of one argument
;;; for-n calls fn several times, first with the argument start, then with start+1
;;; then ... finally with stop.  It returns a list of the values of the calls. 
;;; If start>stop, for-n simply returns the empty list without doing any calls to fn.
(define (for-n start stop fn)
    (if (> start stop) ; condition defined in comment above
        '() ; empty list for base case
        (append (list (fn start)) (for-n (+ start 1) stop fn))
        ; taking whatever list(fn(start)) is and appending to
        ; it the next for-n
    )
)

;;; range-check takes 4 arguments:  row, numrows, col, numcols. It checks if
;;;  0 <= row < numrows and similarly for col and numcols.  If both row and col are in range
;;;  range-check returns #t, otherwise #f
(define (range-check row numrows col numcols)
  (and ; all conditions must be true
   (<= 0 row) 
   (<= 0 col) 
   (< row numrows) 
   (< col numcols)
   )
)

;;; add-check takes 3 arguments: fn, numrows and numcols.  Fn is a
;;; function of two numbers, row and col add-check returns a new
;;; function fn2.  fn2 also takes a number of rows and a number of
;;; columns as arguments.  fn2 first does a range check on these
;;; numbers and if row or col is out of range fn2 returns #\., else it
;;; returns the result of (fn row col)
(define (add-check fn numrows numcols)
  (lambda (row col)
    (if (range-check row numrows col numcols)
        (fn row col)
        #\.)))

;;; display-window prints out the characters that make up a rectangular segment of the pattern
;;;    startrow and endrow are the first and last rows to print, similarly for startcol and endcol
;;; The last thing display-window does is to call (newline) to print a blank line under the pattern segment
(define (display-window start-row stop-row start-col stop-col pattern)
  (for-n start-row stop-row 
         (lambda (r)
           (for-n start-col stop-col 
                  (lambda (c)
                    (display ((pattern-fn pattern) r c))))
           (newline)))
  (newline))

;;; charpat take one argument, a character, and returns a 1-row, 1-column pattern consisting of that character
(define (charpat char)
  (make-pattern 1 1 (lambda (row col)
                      char)))

;;; sw-corner returns a pattern that is a size x size square, in which
;;; the top-left to bottom-right diagonal and everything under it is
;;; the chracter * and everything above the diagonal is a space
;;; character
(define (sw-corner size)
  (make-pattern size
                size
                (lambda (row col)
                  (if (>= row col)
                      #\*
                      #\space))))


;;; repeat-cols returns a pattern made up of nrepeats copies of
;;; pattern, appended horizontally (left and right of each other)
(define (repeat-cols nrepeats pattern)
  (make-pattern 
   (pattern-numrows pattern)
   (* nrepeats (pattern-numcols pattern))
   (lambda (row col) ((pattern-fn pattern) row (modulo col (pattern-numcols pattern)))) 
   )
  )

;;; repeat-rows returns a pattern made up of nrepeats copies of
;;; pattern, appended vertically (above and below each other)
(define (repeat-rows nrepeats pattern)
  ; (make-pattern numrows numcols fn)
    (make-pattern 
     (pattern-numcols pattern) 
     (* nrepeats (pattern-numrows pattern)) ; rows not cols
     (lambda (row col) ((pattern-fn pattern) (modulo row (pattern-numrows pattern)) col))
     )
  )

; takes two patterns and adds the number of rows
(define (get-row-length-of pattern1 pattern2)
  (+ (pattern-numrows pattern1) (pattern-numrows pattern2))
  )

; takes two patterns and adds the number of cols
(define (get-col-length-of pattern1 pattern2)
  (+ (pattern-numcols pattern1) (pattern-numcols pattern2))
  )

; takes two patterns and finds the minimum of the rows
(define (min-row-length-of pattern1 pattern2)
  (min (pattern-numrows pattern1) (pattern-numrows pattern2))
  )

; takes two patterns and finds the minimum of the cols
(define (min-col-length-of pattern1 pattern2)
  (min (pattern-numcols pattern1) (pattern-numcols pattern2))
  )

;;; append cols returns the pattern made by appending pattern2 to the right of pattern1
;;; the number of rows in the resulting pattern is the smaller of the number of rows in pattern1 and patten2
(define (append-cols pattern1 pattern2)
  (make-pattern
   (min-row-length-of pattern1 pattern2) 
   (get-col-length-of pattern1 pattern2)
   (lambda (row col)
     (if (> (pattern-numcols pattern1) col)
         ((pattern-fn pattern1) row col)
         ((pattern-fn pattern2) row (- col (pattern-numcols pattern1)))
         )
     )
   )
  )

;;; append-rows returns the pattern made by appending pattern2 to the below pattern1
;;; the number of columns in the resulting pattern is the smaller of the number of columns in pattern1 and patten2
(define (append-rows pattern1 pattern2)
  (make-pattern
   (get-row-length-of pattern1 pattern2) 
   (min-col-length-of pattern1 pattern2)
   (lambda (row col)
     (if (> (pattern-numrows pattern1) row)
         ((pattern-fn pattern1) row col)
         ((pattern-fn pattern2)(- row (pattern-numrows pattern1))col)
         )
     )
   )
  )

;;; flip-cols returns a pattern that is the left-right mirror image of pattern
(define (flip-cols pattern)
(make-pattern
 (pattern-numrows pattern)
 (pattern-numcols pattern)
 (lambda (row col)
   ((pattern-fn pattern)
    row
    (- (pattern-numcols pattern) (+ col 1) )
    )
   )
 )
)

;;; flip-rows returns a pattern that is the up-down mirror image of pattern
(define (flip-rows pattern)
  (make-pattern
   (pattern-numrows pattern)
   (pattern-numcols pattern)
   (lambda (row col)
     ((pattern-fn pattern) 
      (- (pattern-numrows pattern) (+ row 1) ) 
      col
      )
     )
   )
  )
