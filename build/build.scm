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
build
mzscheme

(require "make.scm" "../src/waxeye/version.scm")

(define *name* "waxeye")
(define *doc-book* "/usr/local/docbook")
(define *gem-name* (++ *name* "-" *version* ".gem"))


(target clean (clean-book clean-gem clean-dist clean-unix)
        (^ ant -f build/ant.xml clean-all)
        (^ rm -rf tmp))


(target book (book-html))


(target book-html ()
        (^ asciidoc -a toc -n -o docs/manual.html docs/book/book))


(target book-pdf ()
        (^ mkdir -p tmp/book)
        (^ asciidoc -a toc -b docbook --doctype=book -o tmp/book/book.xml docs/book/book)
        ($ xsltproc '-o 'tmp/book/book.fo (++ *doc-book* "/fo/docbook.xsl") 'tmp/book/book.xml)
        (^ fop tmp/book/book.fo docs/manual.pdf))


(target clean-book ()
        (^ rm -rf tmp/book)
        (^ rm -f docs/manual.html docs/manual.pdf))


(target gem ()
        (^ mkdir -p lib)
        (^ mkdir -p tmp/gem/lib)
        (^ cp src/ruby/waxeye.rb tmp/gem/lib/)
        (^ cp docs/LICENSE tmp/gem/)
        (^ cp README tmp/gem/)
        (cd tmp/gem
            (^ gem build ../../src/ruby/gem.gemspec))
        ($ mv (++ "tmp/gem/" *gem-name*) 'lib/))


(target clean-gem ()
        (^ rm -rf tmp/gem)
        ($ rm '-f (++ "lib/" *gem-name*)))


(target dist (clean dist-src dist-unix))


(define (cp-dist from)
  ($ cp '-r from (++ "dist/waxeye-" *version* "/")))


(target dist-base (book gem)

 ($ mkdir '-p (++ "dist/waxeye-" *version*))
 (^ ant -f build/ant.xml jar javadoc)

 (cp-dist "build")
 (cp-dist ".classpath")
 (cp-dist "docs")
 (cp-dist "grammars")
 (cp-dist "lib")
 (cp-dist ".project")
 (cp-dist "README")
 (cp-dist "src")
 (cp-dist "test")

 ($ chmod '755 (++ "dist/waxeye-" *version* "/build/make"))
 ($ chmod '755 (++ "dist/waxeye-" *version* "/build/unix"))
 ($ chmod '755 (++ "dist/waxeye-" *version* "/build/waxeye")))


(target dist-src (dist-base)
        (cd dist
            ($ zip '-r (++ "waxeye-" *version* "-src.zip waxeye-" *version*))
            ($ tar 'cjf (++ "waxeye-" *version* "-src.tar.bz2 waxeye-" *version*))))


(target dist-unix (dist-base)
        (cd$ (++ "dist/waxeye-" *version*)
             (^ ./build/unix))
        (cd dist
            ($ tar 'czf (++ "waxeye-" *version* "-unix.tar.gz waxeye-" *version*))
            ($ tar 'cjf (++ "waxeye-" *version* "-unix.tar.bz2 waxeye-" *version*))))


(target clean-dist ()
        (^ rm -rf dist))


(target clean-unix ()
        (^ rm -rf bin lib))


(run-make)
)
