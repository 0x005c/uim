;;; ng-japanese-kana.scm: Kana composition rulesets for Japanese
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


(require "ng-japanese.scm")
(require "physical-key.scm")


;; character sensitive version
(define ja-kana-char-sensitive-core-ruleset
  '(
    (("3")      ("��" "��" "��"))
    (("e")      ("��" "��" "��"))
    (("4")      ("��" "��" "��"))
    (("5")      ("��" "��" "��"))
    (("6")      ("��" "��" "��"))

    (("t")      ("��" "��" "��"))
    (("g")      ("��" "��" "��"))
    (("h")      ("��" "��" "��"))
    ((":")      ("��" "��" "��"))
    (("b")      ("��" "��" "��"))

    (("x")      ("��" "��" "��"))
    (("d")      ("��" "��" "��"))
    (("r")      ("��" "��" "��"))
    (("p")      ("��" "��" "��"))
    (("c")      ("��" "��" "��"))

    (("q")      ("��" "��" "��"))
    (("a")      ("��" "��" "��"))
    (("z")      ("��" "��" "��"))
    (("w")      ("��" "��" "��"))
    (("s")      ("��" "��" "��"))

    (("u")      ("��" "��" "��"))
    (("i")      ("��" "��" "��"))
    (("1")      ("��" "��" "��"))
    ((",")      ("��" "��" "��"))
    (("k")      ("��" "��" "��"))

    (("f")      ("��" "��" "��"))
    (("v")      ("��" "��" "��"))
    (("2")      ("��" "��" "��"))
    (("^")      ("��" "��" "��"))
    (("-")      ("��" "��" "��"))

    (("j")      ("��" "��" "��"))
    (("n")      ("��" "��" "��"))
    (("]")      ("��" "��" "��"))  ;; be careful
    (("/")      ("��" "��" "��"))
    (("m")      ("��" "��" "��"))

    (("7")      ("��" "��" "��"))
    (("8")      ("��" "��" "��"))
    (("9")      ("��" "��" "��"))

    (("o")      ("��" "��" "��"))
    (("l")      ("��" "��" "��"))
    ((".")      ("��" "��" "��"))
    ((";")      ("��" "��" "��"))
    (("\\")     ("��" "��" "��"))  ;; be careful

    (("0")      ("��" "��" "��"))
    (("~")      ("��" "��" "��"))  ;; not proper key
    (("y")      ("��" "��" "��"))

    (("4" "@")  (("��" "��") "��" ("��" "��")))

    (("t" "@")  ("��" "��" ("��" "��")))
    (("g" "@")  ("��" "��" ("��" "��")))
    (("h" "@")  ("��" "��" ("��" "��")))
    ((":" "@")  ("��" "��" ("��" "��")))
    (("b" "@")  ("��" "��" ("��" "��")))

    (("x" "@")  ("��" "��" ("��" "��")))
    (("d" "@")  ("��" "��" ("��" "��")))
    (("r" "@")  ("��" "��" ("��" "��")))
    (("p" "@")  ("��" "��" ("��" "��")))
    (("c" "@")  ("��" "��" ("��" "��")))

    (("q" "@")  ("��" "��" ("��" "��")))
    (("a" "@")  ("��" "��" ("��" "��")))
    (("z" "@")  ("��" "��" ("��" "��")))
    (("w" "@")  ("��" "��" ("��" "��")))
    (("s" "@")  ("��" "��" ("��" "��")))

    (("f" "@")  ("��" "��" ("��" "��")))
    (("v" "@")  ("��" "��" ("��" "��")))
    (("2" "@")  ("��" "��" ("��" "��")))
    (("^" "@")  ("��" "��" ("��" "��")))
    (("-" "@")  ("��" "��" ("��" "��")))

    (("f" "[")  ("��" "��" ("��" "��")))
    (("v" "[")  ("��" "��" ("��" "��")))
    (("2" "[")  ("��" "��" ("��" "��")))
    (("^" "[")  ("��" "��" ("��" "��")))
    (("-" "[")  ("��" "��" ("��" "��")))

    (("#")      ("��" "��" "��"))
    (("E")      ("��" "��" "��"))
    (("$")      ("��" "��" "��"))
    (("%")      ("��" "��" "��"))
    (("&")      ("��" "��" "��"))

    (("'")      ("��" "��" "��"))
    (("(")      ("��" "��" "��"))
    ((")")      ("��" "��" "��"))

    (("Z")      ("��" "��" "��"))

    (("@")      ("��" "��" "��"))
    (("[")      ("��" "��" "��"))
    (("|")      ("��" "��" "��"))  ;; be careful, not proper key
    ((">")      ("��" "��" "��"))
    (("<")      ("��" "��" "��"))
    (("?")      ("��" "��" "��"))
    (("{")      ("��" "��" "��"))
    (("}")      ("��" "��" "��"))
    ))

;; physical key sensitive version
(define ja-kana-core-ruleset
  '(
    ((pkey_jp106_3)            ("��" "��" "��"))
    ((pkey_jp106_e)            ("��" "��" "��"))
    ((pkey_jp106_4)            ("��" "��" "��"))
    ((pkey_jp106_5)            ("��" "��" "��"))
    ((pkey_jp106_6)            ("��" "��" "��"))

    ((pkey_jp106_t)            ("��" "��" "��"))
    ((pkey_jp106_g)            ("��" "��" "��"))
    ((pkey_jp106_h)            ("��" "��" "��"))
    ((pkey_jp106_colon)        ("��" "��" "��"))
    ((pkey_jp106_b)            ("��" "��" "��"))

    ((pkey_jp106_x)            ("��" "��" "��"))
    ((pkey_jp106_d)            ("��" "��" "��"))
    ((pkey_jp106_r)            ("��" "��" "��"))
    ((pkey_jp106_p)            ("��" "��" "��"))
    ((pkey_jp106_c)            ("��" "��" "��"))

    ((pkey_jp106_q)            ("��" "��" "��"))
    ((pkey_jp106_a)            ("��" "��" "��"))
    ((pkey_jp106_z)            ("��" "��" "��"))
    ((pkey_jp106_w)            ("��" "��" "��"))
    ((pkey_jp106_s)            ("��" "��" "��"))

    ((pkey_jp106_u)            ("��" "��" "��"))
    ((pkey_jp106_i)            ("��" "��" "��"))
    ((pkey_jp106_1)            ("��" "��" "��"))
    ((pkey_jp106_comma)        ("��" "��" "��"))
    ((pkey_jp106_k)            ("��" "��" "��"))

    ((pkey_jp106_f)            ("��" "��" "��"))
    ((pkey_jp106_v)            ("��" "��" "��"))
    ((pkey_jp106_2)            ("��" "��" "��"))
    ((pkey_jp106_asciicircum)  ("��" "��" "��"))
    ((pkey_jp106_minus)        ("��" "��" "��"))

    ((pkey_jp106_j)            ("��" "��" "��"))
    ((pkey_jp106_n)            ("��" "��" "��"))
    ((pkey_jp106_bracketright) ("��" "��" "��"))  ;; be careful
    ((pkey_jp106_slash)        ("��" "��" "��"))
    ((pkey_jp106_m)            ("��" "��" "��"))

    ((pkey_jp106_7)            ("��" "��" "��"))
    ((pkey_jp106_8)            ("��" "��" "��"))
    ((pkey_jp106_9)            ("��" "��" "��"))

    ((pkey_jp106_o)            ("��" "��" "��"))
    ((pkey_jp106_l)            ("��" "��" "��"))
    ((pkey_jp106_period)       ("��" "��" "��"))
    ((pkey_jp106_semicolon)    ("��" "��" "��"))
    ((pkey_jp106_backslash)    ("��" "��" "��"))  ;; be careful

    ((pkey_jp106_0)            ("��" "��" "��"))
    ((pkey_jp106_0 mod_shift)  ("��" "��" "��"))
    ((pkey_jp106_y)            ("��" "��" "��"))

    ((pkey_jp106_4           pkey_jp106_at) (("��" "��") "��" ("��" "��")))

    ((pkey_jp106_t           pkey_jp106_at) ("��" "��" ("��" "��")))
    ((pkey_jp106_g           pkey_jp106_at) ("��" "��" ("��" "��")))
    ((pkey_jp106_h           pkey_jp106_at) ("��" "��" ("��" "��")))
    ((pkey_jp106_colon       pkey_jp106_at) ("��" "��" ("��" "��")))
    ((pkey_jp106_b           pkey_jp106_at) ("��" "��" ("��" "��")))

    ((pkey_jp106_x           pkey_jp106_at) ("��" "��" ("��" "��")))
    ((pkey_jp106_d           pkey_jp106_at) ("��" "��" ("��" "��")))
    ((pkey_jp106_r           pkey_jp106_at) ("��" "��" ("��" "��")))
    ((pkey_jp106_p           pkey_jp106_at) ("��" "��" ("��" "��")))
    ((pkey_jp106_c           pkey_jp106_at) ("��" "��" ("��" "��")))

    ((pkey_jp106_q           pkey_jp106_at) ("��" "��" ("��" "��")))
    ((pkey_jp106_a           pkey_jp106_at) ("��" "��" ("��" "��")))
    ((pkey_jp106_z           pkey_jp106_at) ("��" "��" ("��" "��")))
    ((pkey_jp106_w           pkey_jp106_at) ("��" "��" ("��" "��")))
    ((pkey_jp106_s           pkey_jp106_at) ("��" "��" ("��" "��")))

    ((pkey_jp106_f           pkey_jp106_at) ("��" "��" ("��" "��")))
    ((pkey_jp106_v           pkey_jp106_at) ("��" "��" ("��" "��")))
    ((pkey_jp106_2           pkey_jp106_at) ("��" "��" ("��" "��")))
    ((pkey_jp106_asciicircum pkey_jp106_at) ("��" "��" ("��" "��")))
    ((pkey_jp106_minus       pkey_jp106_at) ("��" "��" ("��" "��")))

    ((pkey_jp106_f           pkey_jp106_bracketleft) ("��" "��" ("��" "��")))
    ((pkey_jp106_v           pkey_jp106_bracketleft) ("��" "��" ("��" "��")))
    ((pkey_jp106_2           pkey_jp106_bracketleft) ("��" "��" ("��" "��")))
    ((pkey_jp106_asciicircum pkey_jp106_bracketleft) ("��" "��" ("��" "��")))
    ((pkey_jp106_minus       pkey_jp106_bracketleft) ("��" "��" ("��" "��")))

    ((pkey_jp106_3           mod_shift)     ("��" "��" "��"))
    ((pkey_jp106_e           mod_shift)     ("��" "��" "��"))
    ((pkey_jp106_4           mod_shift)     ("��" "��" "��"))
    ((pkey_jp106_5           mod_shift)     ("��" "��" "��"))
    ((pkey_jp106_6           mod_shift)     ("��" "��" "��"))

    ((pkey_jp106_7           mod_shift)     ("��" "��" "��"))
    ((pkey_jp106_8           mod_shift)     ("��" "��" "��"))
    ((pkey_jp106_9           mod_shift)     ("��" "��" "��"))

    ((pkey_jp106_z           mod_shift)     ("��" "��" "��"))

    ((pkey_jp106_at)                        ("��" "��" "��"))
    ((pkey_jp106_bracketleft)               ("��" "��" "��"))
    ((pkey_jp106_yen)                       ("��" "��" "��"))  ;; be careful
    ((pkey_jp106_period       mod_shift)    ("��" "��" "��"))
    ((pkey_jp106_comma        mod_shift)    ("��" "��" "��"))
    ((pkey_jp106_slash        mod_shift)    ("��" "��" "��"))
    ((pkey_jp106_bracketleft  mod_shift)    ("��" "��" "��"))
    ((pkey_jp106_bracketright mod_shift)    ("��" "��" "��"))  ;; be careful
    ))

(define ja-kana-ruleset-name-list
  '(char-sensitive-core
    core))

(ja-define-dedicated-rulesets 'ja-kana ja-kana-ruleset-name-list)

(define ja-kana-hiragana-ruleset ja-kana-hiragana-core-ruleset)
(define ja-kana-katakana-ruleset ja-kana-katakana-core-ruleset)
(define ja-kana-halfkana-ruleset ja-kana-halfkana-core-ruleset)
