;;; ng-japanese-romaji.scm: Romaji composition rulesets for Japanese
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

;; See following pages for further information about romaji.
;;
;; http://en.wikipedia.org/wiki/Romaji
;; http://ja.wikipedia.org/wiki/%E3%83%AD%E3%83%BC%E3%83%9E%E5%AD%97

(require "ng-japanese.scm")


;;
;; double consonant: ¥��
;;

;;    (("k" "k")     (("��" "k")))
;;    (("k" "k" "a") (("��" "��")))
;;    ...
;;    (("k" "k" "o") (("��" "��")))
;;    (("k" "k" "z") ("you can use any kk* sequence"))

(define ja-romaji-double-consonant-alist
  (map (lambda (c)
	 (cons c ja-kana-xtsu))
       '("k" "g" "s" "z" "j" "t" "c" "d" "h" "f" "b" "p"
	 ;;"m"  ;; rk contains this rule
	 "y" "r" "v" "w")))

(define ja-romaji-generate-double-consonant-ruleset
  (lambda (romaji-ruleset)
    (append-map (lambda (entry)
		  (let ((letter (car entry))
			(kana (cdr entry)))
		    (filter-map (lambda (rule)
				  (let* ((seq (evmap-rule-event-seq rule))
					 (res (evmap-rule-action-seq rule))
					 (listified (map (lambda (elem)
							   (if (list? elem)
							       elem
							       (list elem)))
							 res)))
				    (and (string=? letter
						   (car seq))
					 (list (cons letter seq)
					       (map cons kana listified)))))
				romaji-ruleset)))
		ja-romaji-double-consonant-alist)))

(define ja-romaji-double-consonant-guide-ruleset
  (map (lambda (entry)
	 (let ((letter (car entry))
	       (kana (cdr entry)))
	   (list (list letter letter)
		 (map cons
		      kana
		      (make-list (length kana)
				 (list letter))))))
       ja-romaji-double-consonant-alist))

;;
;; the rulesets
;;

(define ja-romaji-basic-ruleset
  '(
    ;; ����
    (("a")         ("��" "��" "��"))
    (("i")         ("��" "��" "��"))
    (("u")         ("��" "��" "��"))
    (("e")         ("��" "��" "��"))
    (("o")         ("��" "��" "��"))

    ;; ����
    (("k" "a")     ("��" "��" "��"))
    (("k" "i")     ("��" "��" "��"))
    (("k" "u")     ("��" "��" "��"))
    (("k" "e")     ("��" "��" "��"))
    (("k" "o")     ("��" "��" "��"))

    (("k" "y" "a") (("��" "��") ("��" "��") ("��" "��")))
    (("k" "y" "i") (("��" "��") ("��" "��") ("��" "��")))
    (("k" "y" "u") (("��" "��") ("��" "��") ("��" "��")))
    (("k" "y" "e") (("��" "��") ("��" "��") ("��" "��")))
    (("k" "y" "o") (("��" "��") ("��" "��") ("��" "��")))

    (("g" "a")     ("��" "��" ("��" "��")))
    (("g" "i")     ("��" "��" ("��" "��")))
    (("g" "u")     ("��" "��" ("��" "��")))
    (("g" "e")     ("��" "��" ("��" "��")))
    (("g" "o")     ("��" "��" ("��" "��")))

    (("g" "y" "a") (("��" "��") ("��" "��") ("��" "��" "��")))
    (("g" "y" "i") (("��" "��") ("��" "��") ("��" "��" "��")))
    (("g" "y" "u") (("��" "��") ("��" "��") ("��" "��" "��")))
    (("g" "y" "e") (("��" "��") ("��" "��") ("��" "��" "��")))
    (("g" "y" "o") (("��" "��") ("��" "��") ("��" "��" "��")))

    ;; ����
    (("s" "a")     ("��" "��" "��"))
    (("s" "i")     ("��" "��" "��"))
    (("s" "u")     ("��" "��" "��"))
    (("s" "e")     ("��" "��" "��"))
    (("s" "o")     ("��" "��" "��"))

    (("s" "y" "a") (("��" "��") ("��" "��") ("��" "��")))
    (("s" "y" "i") (("��" "��") ("��" "��") ("��" "��")))
    (("s" "y" "u") (("��" "��") ("��" "��") ("��" "��")))
    (("s" "y" "e") (("��" "��") ("��" "��") ("��" "��")))
    (("s" "y" "o") (("��" "��") ("��" "��") ("��" "��")))

    (("z" "a")     ("��" "��" ("��" "��")))
    (("z" "i")     ("��" "��" ("��" "��")))
    (("z" "u")     ("��" "��" ("��" "��")))
    (("z" "e")     ("��" "��" ("��" "��")))
    (("z" "o")     ("��" "��" ("��" "��")))

    (("z" "y" "a") (("��" "��") ("��" "��") ("��" "��" "��")))
    (("z" "y" "i") (("��" "��") ("��" "��") ("��" "��" "��")))
    (("z" "y" "u") (("��" "��") ("��" "��") ("��" "��" "��")))
    (("z" "y" "e") (("��" "��") ("��" "��") ("��" "��" "��")))
    (("z" "y" "o") (("��" "��") ("��" "��") ("��" "��" "��")))

    ;; ����
    (("t" "a")     ("��" "��" "��"))
    (("t" "i")     ("��" "��" "��"))
    (("t" "u")     ("��" "��" "��"))
    (("t" "e")     ("��" "��" "��"))
    (("t" "o")     ("��" "��" "��"))

    (("t" "y" "a") (("��" "��") ("��" "��") ("��" "��")))
    (("t" "y" "i") (("��" "��") ("��" "��") ("��" "��")))
    (("t" "y" "u") (("��" "��") ("��" "��") ("��" "��")))
    (("t" "y" "e") (("��" "��") ("��" "��") ("��" "��")))
    (("t" "y" "o") (("��" "��") ("��" "��") ("��" "��")))

    (("d" "a")     ("��" "��" ("��" "��")))
    (("d" "i")     ("��" "��" ("��" "��")))
    (("d" "u")     ("��" "��" ("��" "��")))
    (("d" "e")     ("��" "��" ("��" "��")))
    (("d" "o")     ("��" "��" ("��" "��")))

    (("d" "y" "a") (("��" "��") ("��" "��") ("��" "��" "��")))
    (("d" "y" "i") (("��" "��") ("��" "��") ("��" "��" "��")))
    (("d" "y" "u") (("��" "��") ("��" "��") ("��" "��" "��")))
    (("d" "y" "e") (("��" "��") ("��" "��") ("��" "��" "��")))
    (("d" "y" "o") (("��" "��") ("��" "��") ("��" "��" "��")))

    ;; �ʹ�
    (("n" "a")     ("��" "��" "��"))
    (("n" "i")     ("��" "��" "��"))
    (("n" "u")     ("��" "��" "��"))
    (("n" "e")     ("��" "��" "��"))
    (("n" "o")     ("��" "��" "��"))

    (("n" "y" "a") (("��" "��") ("��" "��") ("��" "��")))
    (("n" "y" "i") (("��" "��") ("��" "��") ("��" "��")))
    (("n" "y" "u") (("��" "��") ("��" "��") ("��" "��")))
    (("n" "y" "e") (("��" "��") ("��" "��") ("��" "��")))
    (("n" "y" "o") (("��" "��") ("��" "��") ("��" "��")))

    ;; �Ϲ�
    (("h" "a")     ("��" "��" "��"))
    (("h" "i")     ("��" "��" "��"))
    (("h" "u")     ("��" "��" "��"))
    (("h" "e")     ("��" "��" "��"))
    (("h" "o")     ("��" "��" "��"))

    (("h" "y" "a") (("��" "��") ("��" "��") ("��" "��")))
    (("h" "y" "i") (("��" "��") ("��" "��") ("��" "��")))
    (("h" "y" "u") (("��" "��") ("��" "��") ("��" "��")))
    (("h" "y" "e") (("��" "��") ("��" "��") ("��" "��")))
    (("h" "y" "o") (("��" "��") ("��" "��") ("��" "��")))

    (("f" "a")     (("��" "��") ("��" "��") ("��" "��")))
    (("f" "i")     (("��" "��") ("��" "��") ("��" "��")))
    (("f" "e")     (("��" "��") ("��" "��") ("��" "��")))
    (("f" "o")     (("��" "��") ("��" "��") ("��" "��")))

    (("b" "a")     ("��" "��" ("��" "��")))
    (("b" "i")     ("��" "��" ("��" "��")))
    (("b" "u")     ("��" "��" ("��" "��")))
    (("b" "e")     ("��" "��" ("��" "��")))
    (("b" "o")     ("��" "��" ("��" "��")))

    (("b" "y" "a") (("��" "��") ("��" "��") ("��" "��" "��")))
    (("b" "y" "i") (("��" "��") ("��" "��") ("��" "��" "��")))
    (("b" "y" "u") (("��" "��") ("��" "��") ("��" "��" "��")))
    (("b" "y" "e") (("��" "��") ("��" "��") ("��" "��" "��")))
    (("b" "y" "o") (("��" "��") ("��" "��") ("��" "��" "��")))

    (("p" "a")     ("��" "��" ("��" "��")))
    (("p" "i")     ("��" "��" ("��" "��")))
    (("p" "u")     ("��" "��" ("��" "��")))
    (("p" "e")     ("��" "��" ("��" "��")))
    (("p" "o")     ("��" "��" ("��" "��")))

    (("p" "y" "a") (("��" "��") ("��" "��") ("��" "��" "��")))
    (("p" "y" "i") (("��" "��") ("��" "��") ("��" "��" "��")))
    (("p" "y" "u") (("��" "��") ("��" "��") ("��" "��" "��")))
    (("p" "y" "e") (("��" "��") ("��" "��") ("��" "��" "��")))
    (("p" "y" "o") (("��" "��") ("��" "��") ("��" "��" "��")))

    ;; �޹�
    (("m" "a")     ("��" "��" "��"))
    (("m" "i")     ("��" "��" "��"))
    (("m" "u")     ("��" "��" "��"))
    (("m" "e")     ("��" "��" "��"))
    (("m" "o")     ("��" "��" "��"))

    (("m" "y" "a") (("��" "��") ("��" "��") ("��" "��")))
    (("m" "y" "i") (("��" "��") ("��" "��") ("��" "��")))
    (("m" "y" "u") (("��" "��") ("��" "��") ("��" "��")))
    (("m" "y" "e") (("��" "��") ("��" "��") ("��" "��")))
    (("m" "y" "o") (("��" "��") ("��" "��") ("��" "��")))

    ;; ���
    (("y" "a")     ("��" "��" "��"))
    (("y" "i")     ("��" "��" "��"))  ;; rk does not contain this rule
    (("y" "u")     ("��" "��" "��"))
    (("y" "e")     (("��" "��") ("��" "��") ("��" "��")))
    (("y" "o")     ("��" "��" "��"))

    ;; ���
    (("r" "a")     ("��" "��" "��"))
    (("r" "i")     ("��" "��" "��"))
    (("r" "u")     ("��" "��" "��"))
    (("r" "e")     ("��" "��" "��"))
    (("r" "o")     ("��" "��" "��"))

    (("r" "y" "a") (("��" "��") ("��" "��") ("��" "��")))
    (("r" "y" "i") (("��" "��") ("��" "��") ("��" "��")))
    (("r" "y" "u") (("��" "��") ("��" "��") ("��" "��")))
    (("r" "y" "e") (("��" "��") ("��" "��") ("��" "��")))
    (("r" "y" "o") (("��" "��") ("��" "��") ("��" "��")))

    ;; ���
    (("w" "a")     ("��" "��" "��"))
    (("w" "i")     (("��" "��") ("��" "��") ("��" "��")))
    (("w" "u")     ("��" "��" "��"))
    (("w" "e")     (("��" "��") ("��" "��") ("��" "��")))
    (("w" "o")     ("��" "��" "��"))

    ;; ����
    (("v" "a")     (("��" "��" "��") ("��" "��") ("��" "��" "��")))
    (("v" "i")     (("��" "��" "��") ("��" "��") ("��" "��" "��")))
    (("v" "u")     (("��" "��") "��" ("��" "��")))
    (("v" "e")     (("��" "��" "��") ("��" "��") ("��" "��" "��")))
    (("v" "o")     (("��" "��" "��") ("��" "��") ("��" "��" "��")))

    (("v" "y" "a") (("��" "��" "��") ("��" "��") ("��" "��" "��")))
    (("v" "y" "u") (("��" "��" "��") ("��" "��") ("��" "��" "��")))
    (("v" "y" "o") (("��" "��" "��") ("��" "��") ("��" "��" "��")))

    ;; ��
    (("n" (char-nonvowel press peek loopback)) ("��" "��" "��"))
    ;; must be placed after above "nk" rule
    (("n" "n")                        ("��" "��" "��"))
;;    (("n" (char-nonvowel press peek)) (("��" ($3 loopback))
;;				       ("��" ($3 loopback))
;;				       ("��"  ($3 loopback))))

    ;; ����
    (("-")         ("��" "��" "��"))
    (("[")         ("��" "��" "��"))
    (("]")         ("��" "��" "��"))
    ))

(define ja-romaji-basic-double-consonant-ruleset
  (ja-romaji-generate-double-consonant-ruleset
   ja-romaji-basic-ruleset))

(define ja-romaji-x-prefixed-small-kana-ruleset
  '((("x" "a")         ("��" "��" "��"))
    (("x" "i")         ("��" "��" "��"))
    (("x" "u")         ("��" "��" "��"))
    (("x" "e")         ("��" "��" "��"))
    (("x" "o")         ("��" "��" "��"))

    (("x" "y" "a")     ("��" "��" "��"))
    (("x" "y" "i")     ("��" "��" "��"))
    (("x" "y" "u")     ("��" "��" "��"))
    (("x" "y" "e")     ("��" "��" "��"))
    (("x" "y" "o")     ("��" "��" "��"))

    (("x" "t" "u")     ("��" "��" "��"))
    (("x" "t" "s" "u") ("��" "��" "��"))))

(define ja-romaji-l-prefixed-small-kana-ruleset
  '((("l" "a")         ("��" "��" "��"))
    (("l" "i")         ("��" "��" "��"))
    (("l" "u")         ("��" "��" "��"))
    (("l" "e")         ("��" "��" "��"))
    (("l" "o")         ("��" "��" "��"))

    ;; rk does not contain these rules
    (("l" "y" "a")     ("��" "��" "��"))
    (("l" "y" "i")     ("��" "��" "��"))
    (("l" "y" "u")     ("��" "��" "��"))
    (("l" "y" "e")     ("��" "��" "��"))
    (("l" "y" "o")     ("��" "��" "��"))

    (("l" "t" "u")     ("��" "��" "��"))
    (("l" "t" "s" "u") ("��" "��" "��"))))

;; rk contains these rules
(define ja-romaji-minor-ruleset
  '(
    (("d" "s" "u") ("��" "��" ("��" "��")))

    (("x" "w" "a") ("��" "��" "��"))
    (("x" "w" "i") ("��" "��" "��"))
    (("x" "w" "e") ("��" "��" "��"))
		   
    ;; "�����", "10����"
    (("x" "c" "a") ("��" "��" ""))
    (("x" "k" "a") ("��" "��" ""))
    (("x" "k" "e") ("��" "��" ""))
    ))

;; ٹ��
(define ja-romaji-minor-contracted-ruleset
  '(
    (("j" "y" "a") (("��" "��") ("��" "��") ("��" "��" "��")))
    (("j" "y" "i") (("��" "��") ("��" "��") ("��" "��" "��")))
    (("j" "y" "u") (("��" "��") ("��" "��") ("��" "��" "��")))
    (("j" "y" "e") (("��" "��") ("��" "��") ("��" "��" "��")))
    (("j" "y" "o") (("��" "��") ("��" "��") ("��" "��" "��")))

    (("t" "s" "a") (("��" "��") ("��" "��") ("��" "��")))
    (("t" "s" "i") (("��" "��") ("��" "��") ("��" "��")))
    (("t" "s" "e") (("��" "��") ("��" "��") ("��" "��")))
    (("t" "s" "o") (("��" "��") ("��" "��") ("��" "��")))

    (("c" "y" "a") (("��" "��") ("��" "��") ("��" "��")))
    (("c" "y" "i") (("��" "��") ("��" "��") ("��" "��")))
    (("c" "y" "u") (("��" "��") ("��" "��") ("��" "��")))
    (("c" "y" "e") (("��" "��") ("��" "��") ("��" "��")))
    (("c" "y" "o") (("��" "��") ("��" "��") ("��" "��")))

    (("f" "y" "a") (("��" "��") ("��" "��") ("��" "��")))
    (("f" "y" "i") (("��" "��") ("��" "��") ("��" "��")))
    (("f" "y" "u") (("��" "��") ("��" "��") ("��" "��")))
    (("f" "y" "e") (("��" "��") ("��" "��") ("��" "��")))
    (("f" "y" "o") (("��" "��") ("��" "��") ("��" "��")))

    ;; rk contains these rules. but it conflicts with
    ;; ja-romaji-l-prefixed-small-kana-ruleset
    ;;(("l" "y" "a") (("��" "��") ("��" "��") ("��" "��")))
    ;;(("l" "y" "i") (("��" "��") ("��" "��") ("��" "��")))
    ;;(("l" "y" "u") (("��" "��") ("��" "��") ("��" "��")))
    ;;(("l" "y" "e") (("��" "��") ("��" "��") ("��" "��")))
    ;;(("l" "y" "o") (("��" "��") ("��" "��") ("��" "��")))

    (("w" "h" "a") (("��" "��") ("��" "��") ("��" "��")))
    (("w" "h" "i") (("��" "��") ("��" "��") ("��" "��")))
    (("w" "h" "u") ("��" "��" "��"))
    (("w" "h" "e") (("��" "��") ("��" "��") ("��" "��")))
    (("w" "h" "o") (("��" "��") ("��" "��") ("��" "��")))

    (("d" "h" "a") (("��" "��") ("��" "��") ("��" "��" "��")))
    (("d" "h" "i") (("��" "��") ("��" "��") ("��" "��" "��")))
    (("d" "h" "u") (("��" "��") ("��" "��") ("��" "��" "��")))
    (("d" "h" "e") (("��" "��") ("��" "��") ("��" "��" "��")))
    (("d" "h" "o") (("��" "��") ("��" "��") ("��" "��" "��")))

    (("d" "w" "a") (("��" "��") ("��" "��") ("��" "��" "��")))
    (("d" "w" "i") (("��" "��") ("��" "��") ("��" "��" "��")))
    (("d" "w" "u") (("��" "��") ("��" "��") ("��" "��" "��")))
    (("d" "w" "e") (("��" "��") ("��" "��") ("��" "��" "��")))
    (("d" "w" "o") (("��" "��") ("��" "��") ("��" "��" "��")))

    (("k" "w" "a") (("��" "��") ("��" "��") ("��" "��")))
    (("k" "w" "i") (("��" "��") ("��" "��") ("��" "��")))
    (("k" "w" "u") (("��" "��") ("��" "��") ("��" "��")))
    (("k" "w" "e") (("��" "��") ("��" "��") ("��" "��")))
    (("k" "w" "o") (("��" "��") ("��" "��") ("��" "��")))

    (("s" "w" "a") (("��" "��") ("��" "��") ("��" "��")))
    (("s" "w" "i") (("��" "��") ("��" "��") ("��" "��")))
    (("s" "w" "u") (("��" "��") ("��" "��") ("��" "��")))
    (("s" "w" "e") (("��" "��") ("��" "��") ("��" "��")))
    (("s" "w" "o") (("��" "��") ("��" "��") ("��" "��")))

    (("t" "w" "a") (("��" "��") ("��" "��") ("��" "��")))
    (("t" "w" "i") (("��" "��") ("��" "��") ("��" "��")))
    (("t" "w" "u") (("��" "��") ("��" "��") ("��" "��")))
    (("t" "w" "e") (("��" "��") ("��" "��") ("��" "��")))
    (("t" "w" "o") (("��" "��") ("��" "��") ("��" "��")))

    (("t" "h" "a") (("��" "��") ("��" "��") ("��" "��")))
    (("t" "h" "i") (("��" "��") ("��" "��") ("��" "��")))
    (("t" "h" "u") (("��" "��") ("��" "��") ("��" "��")))
    (("t" "h" "e") (("��" "��") ("��" "��") ("��" "��")))
    (("t" "h" "o") (("��" "��") ("��" "��") ("��" "��")))

    (("h" "w" "a") (("��" "��") ("��" "��") ("��" "��")))
    (("h" "w" "i") (("��" "��") ("��" "��") ("��" "��")))
    (("h" "w" "e") (("��" "��") ("��" "��") ("��" "��")))
    (("h" "w" "o") (("��" "��") ("��" "��") ("��" "��")))

    (("f" "w" "a") (("��" "��") ("��" "��") ("��" "��")))
    (("f" "w" "i") (("��" "��") ("��" "��") ("��" "��")))
    (("f" "w" "u") (("��" "��") ("��" "��") ("��" "��")))
    (("f" "w" "e") (("��" "��") ("��" "��") ("��" "��")))
    (("f" "w" "o") (("��" "��") ("��" "��") ("��" "��")))

    (("q" "w" "a") (("��" "��") ("��" "��") ("��" "��")))
    (("q" "w" "i") (("��" "��") ("��" "��") ("��" "��")))
    (("q" "w" "u") (("��" "��") ("��" "��") ("��" "��")))
    (("q" "w" "e") (("��" "��") ("��" "��") ("��" "��")))
    (("q" "w" "o") (("��" "��") ("��" "��") ("��" "��")))

    (("q" "y" "a") (("��" "��") ("��" "��") ("��" "��")))
    (("q" "y" "i") (("��" "��") ("��" "��") ("��" "��")))
    (("q" "y" "u") (("��" "��") ("��" "��") ("��" "��")))
    (("q" "y" "e") (("��" "��") ("��" "��") ("��" "��")))
    (("q" "y" "o") (("��" "��") ("��" "��") ("��" "��")))

    (("g" "w" "a") (("��" "��") ("��" "��") ("��" "��" "��")))
    (("g" "w" "i") (("��" "��") ("��" "��") ("��" "��" "��")))
    (("g" "w" "u") (("��" "��") ("��" "��") ("��" "��" "��")))
    (("g" "w" "e") (("��" "��") ("��" "��") ("��" "��" "��")))
    (("g" "w" "o") (("��" "��") ("��" "��") ("��" "��" "��")))
    ))

(define ja-romaji-minor-contracted-double-consonant-ruleset
  (ja-romaji-generate-double-consonant-ruleset
   ja-romaji-minor-contracted-ruleset))

(define ja-romaji-skk-like-symbol-ruleset
  '((("z" "k") ("��" "��" ""))
    (("z" "j") ("��" "��" ""))
    (("z" "h") ("��" "��" ""))
    (("z" "l") ("��" "��" ""))
    (("z" "-") ("��" "��" ""))
    (("z" "[") ("��" "��" ""))
    (("z" "]") ("��" "��" ""))
    (("z" ",") ("��" "��" ("��" "��")))
    (("z" ".") ("��" "��" ("��" "��" "��")))
    (("z" "/") ("��" "��" "��"))))

;;
;; Hepburn style romaji: �إܥ󼰥��޻�
;;

(define ja-romaji-hepburn-ruleset
  '(
    (("s" "h" "a") (("��" "��") ("��" "��") ("��" "��")))
    (("s" "h" "i") ("��" "��" "��"))
    (("s" "h" "u") (("��" "��") ("��" "��") ("��" "��")))
    (("s" "h" "e") (("��" "��") ("��" "��") ("��" "��")))
    (("s" "h" "o") (("��" "��") ("��" "��") ("��" "��")))
		   
    (("j" "a")     (("��" "��") ("��" "��") ("��" "��" "��")))
    (("j" "i")     ("��" "��" ("��" "��")))
    (("j" "u")     (("��" "��") ("��" "��") ("��" "��" "��")))
    (("j" "e")     (("��" "��") ("��" "��") ("��" "��" "��")))
    (("j" "o")     (("��" "��") ("��" "��") ("��" "��" "��")))

    (("t" "s" "u") ("��" "��" "��"))

    (("c" "h" "a") (("��" "��") ("��" "��") ("��" "��")))
    (("c" "h" "i") ("��" "��" "��"))
    (("c" "h" "u") (("��" "��") ("��" "��") ("��" "��")))
    (("c" "h" "e") (("��" "��") ("��" "��") ("��" "��")))
    (("c" "h" "o") (("��" "��") ("��" "��") ("��" "��")))
		   
    (("f" "u")     ("��" "��" "��"))
    ))

(define ja-romaji-hepburn-double-consonant-ruleset
  (ja-romaji-generate-double-consonant-ruleset
   ja-romaji-hepburn-ruleset))

;; ��
(define ja-romaji-hepburn-n-ruleset
  '(
    ;; "namba" �� "�ʤ��"
    (("m" ("b" press peek)) (("��" ($3 loopback))
			     ("��" ($3 loopback))
			     ("��"  ($3 loopback))))

    ;; "homma" �� "�ۤ��"
    (("m" ("m" press peek)) (("��" ($3 loopback))
			     ("��" ($3 loopback))
			     ("��"  ($3 loopback))))

    ;; "kampo" �� "�����"
    (("m" ("p" press peek)) (("��" ($3 loopback))
			     ("��" ($3 loopback))
			     ("��"  ($3 loopback))))))

;; ���������� (experimental)
(define ja-romaji-hepburn-oh-ruleset
  '((("o" "h"     (char-nonvowel press peek)) (("��" "��" ($5 loopback))
					       ("��" "��" ($5 loopback))
					       ("��" "��"   ($5 loopback))))
    (("k" "o" "h" (char-nonvowel press peek)) (("��" "��" ($7 loopback))
					       ("��" "��" ($7 loopback))
					       ("��" "��"   ($7 loopback))))
    (("g" "o" "h" (char-nonvowel press peek)) (("��" "��" ($7 loopback))
					       ("��" "��" ($7 loopback))
					       ("��" "��" "��" ($7 loopback))))
    (("s" "o" "h" (char-nonvowel press peek)) (("��" "��" ($7 loopback))
					       ("��" "��" ($7 loopback))
					       ("��" "��"   ($7 loopback))))
    (("z" "o" "h" (char-nonvowel press peek)) (("��" "��" ($7 loopback))
					       ("��" "��" ($7 loopback))
					       ("��" "��" "��" ($7 loopback))))
    (("j" "o" "h" (char-nonvowel press peek)) (("��" "��" "��" ($7 loopback))
					       ("��" "��" "��" ($7 loopback))
					       ("��" "��" "��" "��" ($7 loopback))))
    (("t" "o" "h" (char-nonvowel press peek)) (("��" "��" ($7 loopback))
					       ("��" "��" ($7 loopback))
					       ("��" "��"   ($7 loopback))))
    (("d" "o" "h" (char-nonvowel press peek)) (("��" "��" ($7 loopback))
					       ("��" "��" ($7 loopback))
					       ("��" "��" "��" ($7 loopback))))
    (("n" "o" "h" (char-nonvowel press peek)) (("��" "��" ($7 loopback))
					       ("��" "��" ($7 loopback))
					       ("��" "��"   ($7 loopback))))
    (("h" "o" "h" (char-nonvowel press peek)) (("��" "��" ($7 loopback))
					       ("��" "��" ($7 loopback))
					       ("��" "��"   ($7 loopback))))
;;    (("f" "o" "h" (char-nonvowel press peek)) (("��" "��" "��" ($7 loopback))
;;					       ("��" "��" "��" ($7 loopback))
;;					       ("��" "��" "��"    ($7 loopback))))
    (("b" "o" "h" (char-nonvowel press peek)) (("��" "��" ($7 loopback))
					       ("��" "��" ($7 loopback))
					       ("��" "��" "��" ($7 loopback))))
    (("p" "o" "h" (char-nonvowel press peek)) (("��" "��" ($7 loopback))
					       ("��" "��" ($7 loopback))
					       ("��" "��" "��" ($7 loopback))))
    (("m" "o" "h" (char-nonvowel press peek)) (("��" "��" ($7 loopback))
					       ("��" "��" ($7 loopback))
					       ("��" "��"   ($7 loopback))))
    (("y" "o" "h" (char-nonvowel press peek)) (("��" "��" ($7 loopback))
					       ("��" "��" ($7 loopback))
					       ("��" "��"   ($7 loopback))))
    (("r" "o" "h" (char-nonvowel press peek)) (("��" "��" ($7 loopback))
					       ("��" "��" ($7 loopback))
					       ("��" "��"   ($7 loopback))))))

;; ��§¥�� �Ѵ���ɽ��
(define ja-romaji-hepburn-irregular-double-consonant-guide-ruleset
  '((("t" "c")         (("��" "c") ("��" "c") ("��" "c")))))

;; ��§¥��
(define ja-romaji-hepburn-irregular-double-consonant-ruleset
  '((("t" "c" "h" "a") (("��" "��" "��") ("��" "��" "��") ("��" "��" "��")))
    (("t" "c" "h" "i") (("��" "��" "��") ("��" "��" "��") ("��" "��" "��")))
    (("t" "c" "h" "u") (("��" "��" "��") ("��" "��" "��") ("��" "��" "��")))
    ;;(("t" "c" "h" "e") (("��" "��" "��") ("��" "��" "��") ("��" "��" "��")))
    (("t" "c" "h" "o") (("��" "��" "��") ("��" "��" "��") ("��" "��" "��")))))


;; separate romaji rulesets into 3 parts dedicated for hiragana,
;; katakana and halfkana
(define ja-romaji-ruleset-name-list
  '(double-consonant-guide
    basic
    basic-double-consonant
    x-prefixed-small-kana
    l-prefixed-small-kana
    minor
    minor-contracted
    minor-contracted-double-consonant
    skk-like-symbol
    hepburn
    hepburn-double-consonant
    hepburn-n
    hepburn-oh
    hepburn-irregular-double-consonant-guide
    hepburn-irregular-double-consonant))

(ja-define-dedicated-rulesets 'ja-romaji ja-romaji-ruleset-name-list)
		      

;; may be replaced with more efficient way for ruleset composition(merging)
(define ja-romaji-hiragana-ruleset
  (append
   ja-fullwidth-space-ruleset
   ja-fullwidth-kana-period-ruleset
   ja-fullwidth-kana-comma-ruleset
   ja-fullwidth-basic-symbol-ruleset
   ja-fullwidth-number-ruleset
   ja-fullwidth-alphabet-ruleset
   ja-romaji-hiragana-basic-ruleset
   ja-romaji-hiragana-double-consonant-guide-ruleset
   ja-romaji-hiragana-basic-double-consonant-ruleset
   ja-romaji-hiragana-x-prefixed-small-kana-ruleset
   ja-romaji-hiragana-l-prefixed-small-kana-ruleset
   ja-romaji-hiragana-minor-ruleset
   ja-romaji-hiragana-minor-contracted-ruleset
   ja-romaji-hiragana-minor-contracted-double-consonant-ruleset
   ja-romaji-hiragana-hepburn-ruleset
   ja-romaji-hiragana-hepburn-double-consonant-ruleset
   ja-romaji-hiragana-hepburn-n-ruleset
   ja-romaji-hiragana-hepburn-oh-ruleset
   ja-romaji-hiragana-hepburn-irregular-double-consonant-guide-ruleset
   ja-romaji-hiragana-hepburn-irregular-double-consonant-ruleset
   ja-romaji-hiragana-skk-like-symbol-ruleset))

(define ja-romaji-katakana-ruleset
  (append
   ja-fullwidth-space-ruleset
   ja-fullwidth-kana-period-ruleset
   ja-fullwidth-kana-comma-ruleset
   ja-fullwidth-basic-symbol-ruleset
   ja-fullwidth-number-ruleset
   ja-fullwidth-alphabet-ruleset
   ja-romaji-katakana-basic-ruleset
   ja-romaji-katakana-double-consonant-guide-ruleset
   ja-romaji-katakana-basic-double-consonant-ruleset
   ja-romaji-katakana-x-prefixed-small-kana-ruleset
   ja-romaji-katakana-l-prefixed-small-kana-ruleset
   ja-romaji-katakana-minor-ruleset
   ja-romaji-katakana-minor-contracted-ruleset
   ja-romaji-katakana-minor-contracted-double-consonant-ruleset
   ja-romaji-katakana-hepburn-ruleset
   ja-romaji-katakana-hepburn-double-consonant-ruleset
   ja-romaji-katakana-hepburn-n-ruleset
   ja-romaji-katakana-hepburn-oh-ruleset
   ja-romaji-katakana-hepburn-irregular-double-consonant-guide-ruleset
   ja-romaji-katakana-hepburn-irregular-double-consonant-ruleset
   ja-romaji-katakana-skk-like-symbol-ruleset))

(define ja-romaji-halfkana-ruleset
  (append
   ja-halfwidth-space-ruleset
   ja-halfwidth-kana-period-ruleset
   ja-halfwidth-kana-comma-ruleset
   ja-halfwidth-basic-symbol-ruleset
   ja-halfwidth-number-ruleset
   ja-halfwidth-alphabet-ruleset
   ja-romaji-halfkana-basic-ruleset
   ja-romaji-halfkana-double-consonant-guide-ruleset
   ja-romaji-halfkana-basic-double-consonant-ruleset
   ja-romaji-halfkana-x-prefixed-small-kana-ruleset
   ja-romaji-halfkana-l-prefixed-small-kana-ruleset
   ja-romaji-halfkana-minor-ruleset
   ja-romaji-halfkana-minor-contracted-ruleset
   ja-romaji-halfkana-minor-contracted-double-consonant-ruleset
   ja-romaji-halfkana-hepburn-ruleset
   ja-romaji-halfkana-hepburn-double-consonant-ruleset
   ja-romaji-halfkana-hepburn-n-ruleset
   ja-romaji-halfkana-hepburn-oh-ruleset
   ja-romaji-halfkana-hepburn-irregular-double-consonant-guide-ruleset
   ja-romaji-halfkana-hepburn-irregular-double-consonant-ruleset
   ja-romaji-halfkana-skk-like-symbol-ruleset))

(define ja-romaji-hiragana-ruletree
  (evmap-parse-ruleset ja-romaji-hiragana-ruleset))

(define ja-romaji-katakana-ruletree
  (evmap-parse-ruleset ja-romaji-katakana-ruleset))

(define ja-romaji-halfkana-ruletree
  (evmap-parse-ruleset ja-romaji-halfkana-ruleset))
