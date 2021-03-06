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


;; These are tests for the 'Grammar' non-terminal
(Grammar ; <- This is the non-terminal's name

 ;; Following the name are pairs of input string and expected output. The
 ;; output is either the keyword 'pass', the keyword 'fail' or an AST. The AST
 ;; specifies the structure of the expected tree, the names of the nodes and
 ;; the individual characters. If you don't want to specify the whole tree,
 ;; just use the wild-card symbol '*' for the portion of the tree you want to
 ;; skip.

 "" ; <- This is the input
 (Grammar) ; <- This is the expected output

 "A <- 'a'"
 pass ; <- The keyword 'pass'

 "A"
 fail ; <- The keyword 'fail'

 "A <- 'a' B <- 'b'"
 (Grammar (Definition (Identifier #\A) *)  ; <- Here we skip some of
          (Definition (Identifier #\B) *)) ;    Definition's children

 "A <- 'a'"
 (Grammar (*)) ; <- Here we specify a child tree of any type

 "A <- [a-z] *[a-z0-9]"
 (Grammar (Definition (Identifier #\A) (LeftArrow) (Alternation *)))

 "A <- 'a'"
 (Grammar (Definition (Identifier #\A)
            (LeftArrow) (Alternation (Sequence (Unit (Literal (LChar #\a)))))))
 )


(Literal
 "'in'"
 (Literal (LChar #\i) (LChar #\n))

 "''"
 fail
 )


(Range
 ""
 fail

 "-"
 (Range (Char #\-))

 "a"
 (Range (Char #\a))

 "a-z"
 (Range (Char #\a) (Char #\z))

 "\\<0C>"
 (Range (Hex #\0 #\C))

 "\\<30>-\\<39>"
 (Range (Hex #\3 #\0) (Hex #\3 #\9))

 "0-\\<39>"
 (Range (Char #\0) (Hex #\3 #\9))

 "\\<30>-9"
 (Range (Hex #\3 #\0) (Char #\9))
 )


(Alt
 "|"
 pass

 "| "
 pass

 " | "
 fail
 )
