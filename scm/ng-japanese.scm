;;; ng-japanese.scm: Character composition rulesets for Japanese
;;;
;;; Copyright (c) 2004-2005 uim Project http://uim.freedesktop.org/
;;;
;;; All rights reserved.
;;;
;;; Redistribution and use in source and binary forms, with or without
;;; modification, are permitted provided that the following conditions
;;; are met:
;;; 1. Redistributions of source code must retain the above copyright
;;;    notice, this list of conditions and the following disclaimer.
;;; 2. Redistributions in binary form must reproduce the above copyright
;;;    notice, this list of conditions and the following disclaimer in the
;;;    documentation and/or other materials provided with the distribution.
;;; 3. Neither the name of authors nor the names of its contributors
;;;    may be used to endorse or promote products derived from this software
;;;    without specific prior written permission.
;;;
;;; THIS SOFTWARE IS PROVIDED BY THE REGENTS AND CONTRIBUTORS ``AS IS'' AND
;;; ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
;;; IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
;;; ARE DISCLAIMED.  IN NO EVENT SHALL THE REGENTS OR CONTRIBUTORS BE LIABLE
;;; FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
;;; DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS
;;; OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
;;; HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
;;; LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
;;; OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF
;;; SUCH DAMAGE.
;;;;

(require "util.scm")
(require "ng-key.scm")
(require "evmap.scm")


;;
;; kana definitions
;;

(define-record 'ja-kana
  '((hiragana "")
    (katakana "")
    (halfkana "")  ;; JIS X 0201 kana
    ;;(manyou   "")  ;; Manyou-gana
    ;;(kusachu  "")  ;; kana representations for a closed community
    ;;(gal      "")  ;; kana representations for a closed community
    ))

(define-record 'ja-kana-props
  '((id            #f)
    (extractor     #f)
    (indication-id #f)
    (label         "")
    (short-desc    "")))

(define ja-kana-props-alist
  (list
   (list 'hiragana
	 ja-kana-hiragana
	 'figure_ja_hiragana
	 "Hiragana"
	 "")
   (list 'katakana
	 ja-kana-katakana
	 'figure_ja_katakana
	 "Katakana"
	 "")
   (list 'halfkana
	 ja-kana-halfkana
	 'figure_ja_halfkana
	 "Halfwidth katakana"
	 "")
;;   (list 'manyou
;;	 ja-kana-manyou
;;	 'figure_ja_manyou
;;	 "Manyou-gana"
;;	 "")
;;   (list 'kusachu
;;	 ja-kana-kusachu
;;	 'figure_ja_kusachu
;;	 "Kusachu ideographs"
;;	 "")
;;   (list 'gal
;;	 ja-kana-gal
;;	 'figure_ja_gal
;;	 "Gal ideographs"
;;	 "")
   ))

;; Japanese kana composition rulesets will be rewritten using
;; following symbolic kana references in future version of uim to
;; modify kana representations easily, reduce memory consumptions, and
;; to prevent human errors when copying each definitions into
;; rulesets.

;; ����
(define ja-kana-a    '("��" "��" "��"))
(define ja-kana-i    '("��" "��" "��"))
(define ja-kana-u    '("��" "��" "��"))
(define ja-kana-e    '("��" "��" "��"))
(define ja-kana-o    '("��" "��" "��"))

;;����		     
(define ja-kana-ka   '("��" "��" "��"))
(define ja-kana-ki   '("��" "��" "��"))
(define ja-kana-ku   '("��" "��" "��"))
(define ja-kana-ke   '("��" "��" "��"))
(define ja-kana-ko   '("��" "��" "��"))

(define ja-kana-kya  '(("��" "��") ("��" "��") ("��" "��")))
(define ja-kana-kyi  '(("��" "��") ("��" "��") ("��" "��")))
(define ja-kana-kyu  '(("��" "��") ("��" "��") ("��" "��")))
(define ja-kana-kye  '(("��" "��") ("��" "��") ("��" "��")))
(define ja-kana-kyo  '(("��" "��") ("��" "��") ("��" "��")))

(define ja-kana-ga   '("��" "��" ("��" "��")))
(define ja-kana-gi   '("��" "��" ("��" "��")))
(define ja-kana-gu   '("��" "��" ("��" "��")))
(define ja-kana-ge   '("��" "��" ("��" "��")))
(define ja-kana-go   '("��" "��" ("��" "��")))

(define ja-kana-gya  '(("��" "��") ("��" "��") ("��" "��" "��")))
(define ja-kana-gyi  '(("��" "��") ("��" "��") ("��" "��" "��")))
(define ja-kana-gyu  '(("��" "��") ("��" "��") ("��" "��" "��")))
(define ja-kana-gye  '(("��" "��") ("��" "��") ("��" "��" "��")))
(define ja-kana-gyo  '(("��" "��") ("��" "��") ("��" "��" "��")))

(define ja-kana-xtsu '("��" "��" "��"))

;; Can be extended as follows if you want
;;(define ja-kana-sa '("��" "��" "��" "��" "��" "��"))
;;(define ja-kana-de '("��" "��" ("��" "��") "ť" "��~" "�ӡ�"))

;;
;; Japanese ruleset generator
;;

(define ja-extract-dedicated-ruleset
  (lambda (ruleset kana-extractor)
    (map (lambda (rule)
	   (let ((kana (kana-extractor (evmap-rule-action-seq rule))))
	     (list (evmap-rule-event-seq rule)
		   (if (list? kana)
		       kana
		       (list kana)))))
	 ruleset)))

(define ja-define-dedicated-ruleset
  (lambda (prefix name kana)
    (let* ((ruleset-name (symbolconc prefix '- kana '- name '-ruleset))
	   (src-ruleset-name (symbolconc prefix '- name '-ruleset))
	   (src-ruleset (symbol-value src-ruleset-name))
	   (kana-extractor (ja-kana-props-extractor
			    (assq kana ja-kana-props-alist)))
	   (extracted-ruleset (ja-extract-dedicated-ruleset
			       src-ruleset
			       kana-extractor)))
      (eval (list 'define ruleset-name (list 'quote extracted-ruleset))
	    toplevel-env))))

(define ja-define-dedicated-rulesets
  (lambda (prefix ruleset-name-list)
    (for-each (lambda (ruleset-name)
		(for-each (lambda (kana)
			    (ja-define-dedicated-ruleset
			     prefix ruleset-name kana))
			  (map ja-kana-props-id ja-kana-props-alist)))
	      ruleset-name-list)))


;;
;; symbols and punctuations
;;

;; space
(define ja-halfwidth-space-ruleset
  '(((" ") (" "))))

(define ja-fullwidth-space-ruleset
  '(((" ") ("��"))))

;; hyphen
(define ja-halfwidth-hyphen-ruleset
  '((("-") ("-"))))

(define ja-fullwidth-hyphen-ruleset
  '((("-") ("��"))))

;; comma
;; Should be replaced with more elaborated configuration method.
(define ja-halfwidth-comma-ruleset
  '(((",") (","))))

(define ja-fullwidth-comma-ruleset
  '(((",") ("��"))))

(define ja-fullwidth-kana-comma-ruleset
  '(((",") ("��"))))

(define ja-halfwidth-kana-comma-ruleset
  '(((",") ("��"))))

;; period
;; Should be replaced with more elaborated configuration method.
(define ja-halfwidth-period-ruleset
  '(((".") ("."))))

(define ja-fullwidth-period-ruleset
  '(((".") ("��"))))

(define ja-fullwidth-kana-period-ruleset
  '(((".") ("��"))))

(define ja-halfwidth-kana-period-ruleset
  '(((".") ("��"))))

;; basic symbols
;; separate these entries into appropriate classes on demand.
;;   (map (compose print (lambda (s) (list s s)) list charcode->string)
;;        (append (iota 48 33) (iota 65 58) (iota 97 91)  (iota 127 123)))
(define ja-halfwidth-basic-symbol-ruleset
  '(
    ;;((" ") (" "))
    (("!")  ("!"))
    (("\"") ("\""))
    (("#")  ("#"))
    (("$")  ("$"))
    (("%")  ("%"))
    (("&")  ("&"))
    (("'")  ("'"))
    (("(")  ("("))
    ((")")  (")"))
    (("*")  ("*"))
    (("+")  ("+"))
    ;;((",")  (","))
    ;;(("-")  ("-"))
    ;;((".")  ("."))
    (("/")  ("/"))
    ((":")  (":"))
    ((";")  (";"))
    (("<")  ("<"))
    (("=")  ("="))
    ((">")  (">"))
    (("?")  ("?"))
    (("@")  ("@"))
    (("[")  ("["))
    (("\\") ("\\"))
    (("]")  ("]"))
    (("^")  ("^"))
    (("_")  ("_"))
    (("`")  ("`"))
    (("{")  ("{"))
    (("|")  ("|"))
    (("}")  ("}"))
    (("~")  ("~"))
    ))

(define ja-fullwidth-basic-symbol-ruleset
  '(
    ;;((" ")  ("��"))
    (("!")  ("��"))
    (("\"") ("��"))
    (("#")  ("��"))
    (("$")  ("��"))
    (("%")  ("��"))
    (("&")  ("��"))
    (("'")  ("��"))
    (("(")  ("��"))
    ((")")  ("��"))
    (("*")  ("��"))
    (("+")  ("��"))
    ;;((",")  ("��"))
    ;;(("-")  ("��"))
    ;;((".")  ("��"))
    (("/")  ("��"))
    ((":")  ("��"))
    ((";")  ("��"))
    (("<")  ("��"))
    (("=")  ("��"))
    ((">")  ("��"))
    (("?")  ("��"))
    (("@")  ("��"))
    (("[")  ("��"))
    (("\\") ("��"))
    (("]")  ("��"))
    (("^")  ("��"))
    (("_")  ("��"))
    (("`")  ("��"))
    (("{")  ("��"))
    (("|")  ("��"))
    (("}")  ("��"))
    (("~")  ("��"))
    ))

;; numbers
(define ja-halfwidth-number-ruleset
  '((("1") ("1"))
    (("2") ("2"))
    (("3") ("3"))
    (("4") ("4"))
    (("5") ("5"))
    (("6") ("6"))
    (("7") ("7"))
    (("8") ("8"))
    (("9") ("9"))
    (("0") ("0"))))

(define ja-fullwidth-number-ruleset
  '((("1") ("��"))
    (("2") ("��"))
    (("3") ("��"))
    (("4") ("��"))
    (("5") ("��"))
    (("6") ("��"))
    (("7") ("��"))
    (("8") ("��"))
    (("9") ("��"))
    (("0") ("��"))))

;; alphabets
(define ja-halfwidth-alphabet-ruleset
  '((("a") ("a"))
    (("b") ("b"))
    (("c") ("c"))
    (("d") ("d"))
    (("e") ("e"))
    (("f") ("f"))
    (("g") ("g"))
    (("h") ("h"))
    (("i") ("i"))
    (("j") ("j"))
    (("k") ("k"))
    (("l") ("l"))
    (("m") ("m"))
    (("n") ("n"))
    (("o") ("o"))
    (("p") ("p"))
    (("q") ("q"))
    (("r") ("r"))
    (("s") ("s"))
    (("t") ("t"))
    (("u") ("u"))
    (("v") ("v"))
    (("w") ("w"))
    (("x") ("x"))
    (("y") ("y"))
    (("z") ("z"))

    (("A") ("A"))
    (("B") ("B"))
    (("C") ("C"))
    (("D") ("D"))
    (("E") ("E"))
    (("F") ("F"))
    (("G") ("G"))
    (("H") ("H"))
    (("I") ("I"))
    (("J") ("J"))
    (("K") ("K"))
    (("L") ("L"))
    (("M") ("M"))
    (("N") ("N"))
    (("O") ("O"))
    (("P") ("P"))
    (("Q") ("Q"))
    (("R") ("R"))
    (("S") ("S"))
    (("T") ("T"))
    (("U") ("U"))
    (("V") ("V"))
    (("W") ("W"))
    (("X") ("X"))
    (("Y") ("Y"))
    (("Z") ("Z"))))

(define ja-fullwidth-alphabet-ruleset
  '((("a") ("��"))
    (("b") ("��"))
    (("c") ("��"))
    (("d") ("��"))
    (("e") ("��"))
    (("f") ("��"))
    (("g") ("��"))
    (("h") ("��"))
    (("i") ("��"))
    (("j") ("��"))
    (("k") ("��"))
    (("l") ("��"))
    (("m") ("��"))
    (("n") ("��"))
    (("o") ("��"))
    (("p") ("��"))
    (("q") ("��"))
    (("r") ("��"))
    (("s") ("��"))
    (("t") ("��"))
    (("u") ("��"))
    (("v") ("��"))
    (("w") ("��"))
    (("x") ("��"))
    (("y") ("��"))
    (("z") ("��"))

    (("A") ("��"))
    (("B") ("��"))
    (("C") ("��"))
    (("D") ("��"))
    (("E") ("��"))
    (("F") ("��"))
    (("G") ("��"))
    (("H") ("��"))
    (("I") ("��"))
    (("J") ("��"))
    (("K") ("��"))
    (("L") ("��"))
    (("M") ("��"))
    (("N") ("��"))
    (("O") ("��"))
    (("P") ("��"))
    (("Q") ("��"))
    (("R") ("��"))
    (("S") ("��"))
    (("T") ("��"))
    (("U") ("��"))
    (("V") ("��"))
    (("W") ("��"))
    (("X") ("��"))
    (("Y") ("��"))
    (("Z") ("��"))))

(define ja-direct-ruleset '())

;; This ruleset will not be used in ordinary input method. Direct
;; input mode passes through almost of key events instead of using
;; this ruleset.
(define ja-halfwidth-alphanumeric-ruleset
  (append
   ja-halfwidth-space-ruleset
   ja-halfwidth-hyphen-ruleset
   ja-halfwidth-comma-ruleset
   ja-halfwidth-period-ruleset
   ja-halfwidth-basic-symbol-ruleset
   ja-halfwidth-number-ruleset
   ja-halfwidth-alphabet-ruleset))

(define ja-fullwidth-alphanumeric-ruleset
  (append
   ja-fullwidth-space-ruleset
   ja-fullwidth-hyphen-ruleset
   ja-fullwidth-comma-ruleset
   ja-fullwidth-period-ruleset
   ja-fullwidth-basic-symbol-ruleset
   ja-fullwidth-number-ruleset
   ja-fullwidth-alphabet-ruleset))

(define ja-direct-ruletree
  (evmap-parse-ruleset ja-direct-ruleset))

(define ja-halfwidth-alphanumeric-ruletree
  (evmap-parse-ruleset ja-halfwidth-alphanumeric-ruleset))

(define ja-fullwidth-alphanumeric-ruletree
  (evmap-parse-ruleset ja-fullwidth-alphanumeric-ruleset))
