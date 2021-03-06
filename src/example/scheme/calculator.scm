;;; Waxeye Parser Generator
;;; www.waxeye.org
;;; Copyright (C) 2008 Orlando D. A. R. Hill
;;;
;;; Permission is hereby granted, free of charge, to any person obtaining a copy of
;;; this software and associated documentation files (the "Software"), to deal in
;;; the Software without restriction, including without limitation the rights to
;;; use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies
;;; of the Software, and to permit persons to whom the Software is furnished to do
;;; so, subject to the following conditions:
;;;
;;; The above copyright notice and this permission notice shall be included in all
;;; copies or substantial portions of the Software.
;;;
;;; THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
;;; IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
;;; FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
;;; AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
;;; LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
;;; OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
;;; SOFTWARE.

(module
calculator
mzscheme

(require "parser.scm")

;; A commandline arithmetic calculator.

(define (calc input)
  (let ((ast (parser input)))
    (if (ast? ast)
        (begin (display (sum (car (ast-c ast))))
               (newline))
        (display-parse-error ast))))


(define (bin-op ast fn ch op1 op2)
  (let* ((chil (list->vector (ast-c ast)))
         (val (fn (vector-ref chil 0))))
    (let loop ((i 1))
      (unless (= i (vector-length chil))
              ;; Increment val by the operator applied to val and the operand
              (set! val ((if (equal? (vector-ref chil i) ch) op1 op2)
                         val (fn (vector-ref chil (+ i 1)))))
              (loop (+ i 2))))
    val))


(define (sum ast)
  (bin-op ast prod #\+ + -))


(define (prod ast)
  (bin-op ast unary #\* * /))


(define (unary ast)
  (case (ast-t ast)
    ((unary) (- (unary (cadr (ast-c ast)))))
    ((sum) (sum ast))
    (else (num ast))))


(define (num ast)
  (string->number (list->string (ast-c ast))))


(define (rl)
  (display "calc> ")
  (read-line (current-input-port)))


(let loop ((input (rl)))
  (if (eof-object? input)
      (newline)
      (begin (calc input)
             (loop (rl)))))

)
