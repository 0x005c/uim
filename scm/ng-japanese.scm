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
;; temporary workaround for ja-immediate-commit-ruleset
(require-custom "japanese-romaji-custom.scm")


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
		   (if (pair? kana)
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
    ((("!" mod_ignore_Shift))  ("!"))
    ((("\"" mod_ignore_Shift)) ("\""))
    ((("#" mod_ignore_Shift))  ("#"))
    ((("$" mod_ignore_Shift))  ("$"))
    ((("%" mod_ignore_Shift))  ("%"))
    ((("&" mod_ignore_Shift))  ("&"))
    ((("'" mod_ignore_Shift))  ("'"))
    ((("(" mod_ignore_Shift))  ("("))
    (((")" mod_ignore_Shift))  (")"))
    ((("*" mod_ignore_Shift))  ("*"))
    ((("+" mod_ignore_Shift))  ("+"))
    ;;((("," mod_ignore_Shift))  (","))
    ;;((("-" mod_ignore_Shift))  ("-"))
    ;;((("." mod_ignore_Shift))  ("."))
    ((("/" mod_ignore_Shift))  ("/"))
    (((":" mod_ignore_Shift))  (":"))
    (((";" mod_ignore_Shift))  (";"))
    ((("<" mod_ignore_Shift))  ("<"))
    ((("=" mod_ignore_Shift))  ("="))
    (((">" mod_ignore_Shift))  (">"))
    ((("?" mod_ignore_Shift))  ("?"))
    ((("@" mod_ignore_Shift))  ("@"))
    ((("[" mod_ignore_Shift))  ("["))
    ((("\\" mod_ignore_Shift)) ("\\"))
    ((("]" mod_ignore_Shift))  ("]"))
    ((("^" mod_ignore_Shift))  ("^"))
    ((("_" mod_ignore_Shift))  ("_"))
    ((("`" mod_ignore_Shift))  ("`"))
    ((("{" mod_ignore_Shift))  ("{"))
    ((("|" mod_ignore_Shift))  ("|"))
    ((("}" mod_ignore_Shift))  ("}"))
    ((("~" mod_ignore_Shift))  ("~"))
    ))

(define ja-fullwidth-basic-symbol-ruleset
  '(
    ;;((" ")  ("��"))
    ((("!" mod_ignore_Shift))  ("��"))
    ((("\"" mod_ignore_Shift)) ("��"))
    ((("#" mod_ignore_Shift))  ("��"))
    ((("$" mod_ignore_Shift))  ("��"))
    ((("%" mod_ignore_Shift))  ("��"))
    ((("&" mod_ignore_Shift))  ("��"))
    ((("'" mod_ignore_Shift))  ("��"))
    ((("(" mod_ignore_Shift))  ("��"))
    (((")" mod_ignore_Shift))  ("��"))
    ((("*" mod_ignore_Shift))  ("��"))
    ((("+" mod_ignore_Shift))  ("��"))
    ;;((("," mod_ignore_Shift))  ("��"))
    ;;((("-" mod_ignore_Shift))  ("��"))
    ;;((("." mod_ignore_Shift))  ("��"))
    ((("/" mod_ignore_Shift))  ("��"))
    (((":" mod_ignore_Shift))  ("��"))
    (((";" mod_ignore_Shift))  ("��"))
    ((("<" mod_ignore_Shift))  ("��"))
    ((("=" mod_ignore_Shift))  ("��"))
    (((">" mod_ignore_Shift))  ("��"))
    ((("?" mod_ignore_Shift))  ("��"))
    ((("@" mod_ignore_Shift))  ("��"))
    ((("[" mod_ignore_Shift))  ("��"))
    ((("\\" mod_ignore_Shift)) ("��"))
    ((("]" mod_ignore_Shift))  ("��"))
    ((("^" mod_ignore_Shift))  ("��"))
    ((("_" mod_ignore_Shift))  ("��"))
    ((("`" mod_ignore_Shift))  ("��"))
    ((("{" mod_ignore_Shift))  ("��"))
    ((("|" mod_ignore_Shift))  ("��"))
    ((("}" mod_ignore_Shift))  ("��"))
    ((("~" mod_ignore_Shift))  ("��"))
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
  '(((("a" mod_ignore_Shift)) ("a"))
    ((("b" mod_ignore_Shift)) ("b"))
    ((("c" mod_ignore_Shift)) ("c"))
    ((("d" mod_ignore_Shift)) ("d"))
    ((("e" mod_ignore_Shift)) ("e"))
    ((("f" mod_ignore_Shift)) ("f"))
    ((("g" mod_ignore_Shift)) ("g"))
    ((("h" mod_ignore_Shift)) ("h"))
    ((("i" mod_ignore_Shift)) ("i"))
    ((("j" mod_ignore_Shift)) ("j"))
    ((("k" mod_ignore_Shift)) ("k"))
    ((("l" mod_ignore_Shift)) ("l"))
    ((("m" mod_ignore_Shift)) ("m"))
    ((("n" mod_ignore_Shift)) ("n"))
    ((("o" mod_ignore_Shift)) ("o"))
    ((("p" mod_ignore_Shift)) ("p"))
    ((("q" mod_ignore_Shift)) ("q"))
    ((("r" mod_ignore_Shift)) ("r"))
    ((("s" mod_ignore_Shift)) ("s"))
    ((("t" mod_ignore_Shift)) ("t"))
    ((("u" mod_ignore_Shift)) ("u"))
    ((("v" mod_ignore_Shift)) ("v"))
    ((("w" mod_ignore_Shift)) ("w"))
    ((("x" mod_ignore_Shift)) ("x"))
    ((("y" mod_ignore_Shift)) ("y"))
    ((("z" mod_ignore_Shift)) ("z"))

    ((("A" mod_ignore_Shift)) ("A"))
    ((("B" mod_ignore_Shift)) ("B"))
    ((("C" mod_ignore_Shift)) ("C"))
    ((("D" mod_ignore_Shift)) ("D"))
    ((("E" mod_ignore_Shift)) ("E"))
    ((("F" mod_ignore_Shift)) ("F"))
    ((("G" mod_ignore_Shift)) ("G"))
    ((("H" mod_ignore_Shift)) ("H"))
    ((("I" mod_ignore_Shift)) ("I"))
    ((("J" mod_ignore_Shift)) ("J"))
    ((("K" mod_ignore_Shift)) ("K"))
    ((("L" mod_ignore_Shift)) ("L"))
    ((("M" mod_ignore_Shift)) ("M"))
    ((("N" mod_ignore_Shift)) ("N"))
    ((("O" mod_ignore_Shift)) ("O"))
    ((("P" mod_ignore_Shift)) ("P"))
    ((("Q" mod_ignore_Shift)) ("Q"))
    ((("R" mod_ignore_Shift)) ("R"))
    ((("S" mod_ignore_Shift)) ("S"))
    ((("T" mod_ignore_Shift)) ("T"))
    ((("U" mod_ignore_Shift)) ("U"))
    ((("V" mod_ignore_Shift)) ("V"))
    ((("W" mod_ignore_Shift)) ("W"))
    ((("X" mod_ignore_Shift)) ("X"))
    ((("Y" mod_ignore_Shift)) ("Y"))
    ((("Z" mod_ignore_Shift)) ("Z"))))

(define ja-fullwidth-alphabet-ruleset
  '(((("a" mod_ignore_Shift)) ("��"))
    ((("b" mod_ignore_Shift)) ("��"))
    ((("c" mod_ignore_Shift)) ("��"))
    ((("d" mod_ignore_Shift)) ("��"))
    ((("e" mod_ignore_Shift)) ("��"))
    ((("f" mod_ignore_Shift)) ("��"))
    ((("g" mod_ignore_Shift)) ("��"))
    ((("h" mod_ignore_Shift)) ("��"))
    ((("i" mod_ignore_Shift)) ("��"))
    ((("j" mod_ignore_Shift)) ("��"))
    ((("k" mod_ignore_Shift)) ("��"))
    ((("l" mod_ignore_Shift)) ("��"))
    ((("m" mod_ignore_Shift)) ("��"))
    ((("n" mod_ignore_Shift)) ("��"))
    ((("o" mod_ignore_Shift)) ("��"))
    ((("p" mod_ignore_Shift)) ("��"))
    ((("q" mod_ignore_Shift)) ("��"))
    ((("r" mod_ignore_Shift)) ("��"))
    ((("s" mod_ignore_Shift)) ("��"))
    ((("t" mod_ignore_Shift)) ("��"))
    ((("u" mod_ignore_Shift)) ("��"))
    ((("v" mod_ignore_Shift)) ("��"))
    ((("w" mod_ignore_Shift)) ("��"))
    ((("x" mod_ignore_Shift)) ("��"))
    ((("y" mod_ignore_Shift)) ("��"))
    ((("z" mod_ignore_Shift)) ("��"))

    ((("A" mod_ignore_Shift)) ("��"))
    ((("B" mod_ignore_Shift)) ("��"))
    ((("C" mod_ignore_Shift)) ("��"))
    ((("D" mod_ignore_Shift)) ("��"))
    ((("E" mod_ignore_Shift)) ("��"))
    ((("F" mod_ignore_Shift)) ("��"))
    ((("G" mod_ignore_Shift)) ("��"))
    ((("H" mod_ignore_Shift)) ("��"))
    ((("I" mod_ignore_Shift)) ("��"))
    ((("J" mod_ignore_Shift)) ("��"))
    ((("K" mod_ignore_Shift)) ("��"))
    ((("L" mod_ignore_Shift)) ("��"))
    ((("M" mod_ignore_Shift)) ("��"))
    ((("N" mod_ignore_Shift)) ("��"))
    ((("O" mod_ignore_Shift)) ("��"))
    ((("P" mod_ignore_Shift)) ("��"))
    ((("Q" mod_ignore_Shift)) ("��"))
    ((("R" mod_ignore_Shift)) ("��"))
    ((("S" mod_ignore_Shift)) ("��"))
    ((("T" mod_ignore_Shift)) ("��"))
    ((("U" mod_ignore_Shift)) ("��"))
    ((("V" mod_ignore_Shift)) ("��"))
    ((("W" mod_ignore_Shift)) ("��"))
    ((("X" mod_ignore_Shift)) ("��"))
    ((("Y" mod_ignore_Shift)) ("��"))
    ((("Z" mod_ignore_Shift)) ("��"))))

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

(define ja-direct-ruleset '())

;; Although the ruleset contains 'romaji' participants, this ruleset
;; is prepared for all japanese rulsets. It should be reorganized as
;; appropriately.
(define ja-immediate-commit-ruleset
  (append
   (symbol-value ja-romaji-fullwidth-space-ruleset)
   ;;(symbol-value ja-romaji-fullwidth-basic-symbol-ruleset)
   ;;(symbol-value ja-romaji-fullwidth-number-ruleset)
   ))

(define ja-halfwidth-alphanumeric-ruletree
  (evmap-parse-ruleset ja-halfwidth-alphanumeric-ruleset))

(define ja-fullwidth-alphanumeric-ruletree
  (evmap-parse-ruleset ja-fullwidth-alphanumeric-ruleset))

(define ja-direct-ruletree
  (evmap-parse-ruleset ja-direct-ruleset))

(define ja-immediate-commit-ruletree
  (evmap-parse-ruleset ja-immediate-commit-ruleset))
