;;;; This file is project 1 for CS 314 for Fall 2013, taught by Prof. Steinberg

;;;; The assignment is to fill in the definitions below, adding your code where ever you see
;;;; the comment 
     ;;  fill in here
;;;; to make each function do what its comments say it should do
;;;; You may also add your own functions, as long as each function has a comment like the ones below.
;;;; You may not make any other changes to this code.

;;;; See the assignment on Sakai for examples and further information, including due date.

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
  ;; fill in here
  )

;;; range-check takes 4 arguments:  row, numrows, col, numcols. It checks if
;;;  0 <= row < numrows and similarly for col and numcols.  If both row and col are in range
;;;  range-check returns #t, otherwise #f
(define (range-check row numrows col numcols)
  ;; fill in here
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
  (make-pattern (pattern-numrows pattern) 
                (* nrepeats (pattern-numcols pattern)) 
                ; the function just calls the function repeat-cols received, but 
                ; uses modulo to select the right position.
                (lambda (row col) ((pattern-fn pattern) row (modulo col (pattern-numcols pattern)))) ))

;;; repeat-rows returns a pattern made up of nrepeats copies of
;;; pattern, appended vertically (above and below each other)
(define (repeat-rows nrepeats pattern)
  ;; fill in  here
  )

;;; append cols returns the pattern made by appending pattern2 to the right of pattern1
;;; the number of rows in the resulting pattern is the smaller of the number of rows in pattern1 and patten2
(define (append-cols pattern1 pattern2)
  ;; fill in here
  )

;;; append-rows returns the pattern made by appending pattern2 to the below pattern1
;;; the number of columns in the resulting pattern is the smaller of the number of columns in pattern1 and patten2
(define (append-rows pattern1 pattern2)
  ;;fill in here
  )

;;; flip-cols returns a pattern that is the left-right mirror image of pattern
(define (flip-cols pattern)
  ;;fill in here
  )

;;; flip-rows returns a pattern that is the up-down mirror image of pattern
(define (flip-rows pattern)
  ;; fill  in here
  )
