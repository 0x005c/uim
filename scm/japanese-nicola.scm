;;; japanese-nicola.scm: NICOLA composition rulesets for Japanese
;;;
;;; Copyright (c) 2005 uim Project http://uim.freedesktop.org/
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

;; See following pages for further information about the NICOLA kana
;; input method
;;
;; Draft JIS specification (Japanese)
;; http://nicola.sunicom.co.jp/spec/jisdraft.htm
;;
;; Specification (Japanese)
;; http://nicola.sunicom.co.jp/spec/kikaku.htm
;;
;; Keyboard layout variations
;; http://nicola.sunicom.co.jp/info2.html


;; The key mappings coded in this file are transcribed from the NICOLA
;; specifications by hand. No other copyrighted data are included.
;;   -- YamaKen 2005-02-11

;; This composition rulesets only sense strict simultaneous key
;; presses. Timer-based compensations is not available.

(require "ng-japanese.scm")
(require "physical-key.scm")


(define ja-nicola-core-ruleset
  '(
    ;; left hand side without shift
    ((pkey_jp106_q)          ("��" "��" "��"))
    ((pkey_jp106_w)          ("��" "��" "��"))
    ((pkey_jp106_e)          ("��" "��" "��"))
    ((pkey_jp106_r)          ("��" "��" "��"))
    ((pkey_jp106_t)          ("��" "��" "��"))
		               
    ((pkey_jp106_a)          ("��" "��" "��"))
    ((pkey_jp106_s)          ("��" "��" "��"))
    ((pkey_jp106_d)          ("��" "��" "��"))
    ((pkey_jp106_f)          ("��" "��" "��"))
    ((pkey_jp106_g)          ("��" "��" "��"))
		               
    ((pkey_jp106_z)          ("��" "��" "."))
    ((pkey_jp106_x)          ("��" "��" "��"))
    ((pkey_jp106_c)          ("��" "��" "��"))
    ((pkey_jp106_v)          ("��" "��" "��"))
    ((pkey_jp106_b)          ("��" "��" "��"))

    ;; right hand side without shift
    ((pkey_jp106_y)          ("��" "��" "��"))
    ((pkey_jp106_u)          ("��" "��" "��"))
    ((pkey_jp106_i)          ("��" "��" "��"))
    ((pkey_jp106_o)          ("��" "��" "��"))
    ((pkey_jp106_p)          ("��" "��" ","))
    ((pkey_jp106_at)         ("��" "��" "��"))

    ((pkey_jp106_h)          ("��" "��" "��"))
    ((pkey_jp106_j)          ("��" "��" "��"))
    ((pkey_jp106_k)          ("��" "��" "��"))
    ((pkey_jp106_l)          ("��" "��" "��"))
    ((pkey_jp106_semicolon)  ("��" "��" "��"))
			       
    ((pkey_jp106_n)          ("��" "��" "��"))
    ((pkey_jp106_m)          ("��" "��" "��"))
    ((pkey_jp106_comma)      ("��" "��" "��"))
    ((pkey_jp106_period)     ("��" "��" "��"))
    ((pkey_jp106_slash)      ("��" "��" "��"))

    ;; left hand side with same-handed shift
    (((chord lkey_Thumb_Shift_L pkey_jp106_q))          ("��" "��" "��"))
    (((chord lkey_Thumb_Shift_L pkey_jp106_w))          ("��" "��" "��"))
    (((chord lkey_Thumb_Shift_L pkey_jp106_e))          ("��" "��" "��"))
    (((chord lkey_Thumb_Shift_L pkey_jp106_r))          ("��" "��" "��"))
    (((chord lkey_Thumb_Shift_L pkey_jp106_t))          ("��" "��" "��"))
							 
    (((chord lkey_Thumb_Shift_L pkey_jp106_a))          ("��" "��" "��"))
    (((chord lkey_Thumb_Shift_L pkey_jp106_s))          ("��" "��" "��"))
    (((chord lkey_Thumb_Shift_L pkey_jp106_d))          ("��" "��" "��"))
    (((chord lkey_Thumb_Shift_L pkey_jp106_f))          ("��" "��" "��"))
    (((chord lkey_Thumb_Shift_L pkey_jp106_g))          ("��" "��" "��"))
							 
    (((chord lkey_Thumb_Shift_L pkey_jp106_z))          ("��" "��" "��"))
    (((chord lkey_Thumb_Shift_L pkey_jp106_x))          ("��" "��" "��"))
    (((chord lkey_Thumb_Shift_L pkey_jp106_c))          ("��" "��" "��"))
    (((chord lkey_Thumb_Shift_L pkey_jp106_v))          ("��" "��" "��"))
    (((chord lkey_Thumb_Shift_L pkey_jp106_b))          ("��" "��" "��"))
							 
    ;; right hand side with same-handed shift		 
    (((chord lkey_Thumb_Shift_R pkey_jp106_y))          ("��" "��" "��"))
    (((chord lkey_Thumb_Shift_R pkey_jp106_u))          ("��" "��" "��"))
    (((chord lkey_Thumb_Shift_R pkey_jp106_i))          ("��" "��" "��"))
    (((chord lkey_Thumb_Shift_R pkey_jp106_o))          ("��" "��" "��"))
    (((chord lkey_Thumb_Shift_R pkey_jp106_p))          ("��" "��" "��"))
    ;;(((chord lkey_Thumb_Shift_R pkey_jp106_at))         ("" "" ""))

    (((chord lkey_Thumb_Shift_R pkey_jp106_h))          ("��" "��" "��"))
    (((chord lkey_Thumb_Shift_R pkey_jp106_j))          ("��" "��" "��"))
    (((chord lkey_Thumb_Shift_R pkey_jp106_k))          ("��" "��" "��"))
    (((chord lkey_Thumb_Shift_R pkey_jp106_l))          ("��" "��" "��"))
    (((chord lkey_Thumb_Shift_R pkey_jp106_semicolon))  ("��" "��" "��"))
							 
    (((chord lkey_Thumb_Shift_R pkey_jp106_n))          ("��" "��" "��"))
    (((chord lkey_Thumb_Shift_R pkey_jp106_m))          ("��" "��" "��"))
    (((chord lkey_Thumb_Shift_R pkey_jp106_comma))      ("��" "��" "��"))
    (((chord lkey_Thumb_Shift_R pkey_jp106_period))     ("��" "��" "��"))
    (((chord lkey_Thumb_Shift_R pkey_jp106_slash))      ("��" "��" "��"))

    ;; left hand side with cross-shift
    ;;(((chord lkey_Thumb_Shift_R pkey_jp106_q))          ("" "" ""))
    (((chord lkey_Thumb_Shift_R pkey_jp106_w))          ("��" "��" ("��" "��")))
    (((chord lkey_Thumb_Shift_R pkey_jp106_e))          ("��" "��" ("��" "��")))
    (((chord lkey_Thumb_Shift_R pkey_jp106_r))          ("��" "��" ("��" "��")))
    (((chord lkey_Thumb_Shift_R pkey_jp106_t))          ("��" "��" ("��" "��")))
							 
    ;;(((chord lkey_Thumb_Shift_R pkey_jp106_a))   (("��" "��") "��" ("��" "��")))
    (((chord lkey_Thumb_Shift_R pkey_jp106_s))          ("��" "��" ("��" "��")))
    (((chord lkey_Thumb_Shift_R pkey_jp106_d))          ("��" "��" ("��" "��")))
    (((chord lkey_Thumb_Shift_R pkey_jp106_f))          ("��" "��" ("��" "��")))
    (((chord lkey_Thumb_Shift_R pkey_jp106_g))          ("��" "��" ("��" "��")))
							 
    ;;(((chord lkey_Thumb_Shift_R pkey_jp106_z))          ("" "" ""))
    (((chord lkey_Thumb_Shift_R pkey_jp106_x))          ("��" "��" ("��" "��")))
    (((chord lkey_Thumb_Shift_R pkey_jp106_c))          ("��" "��" ("��" "��")))
    (((chord lkey_Thumb_Shift_R pkey_jp106_v))          ("��" "��" ("��" "��")))
    (((chord lkey_Thumb_Shift_R pkey_jp106_b))          ("��" "��" ("��" "��")))
							 
    ;; right hand side with cross-shift			 
    (((chord lkey_Thumb_Shift_L pkey_jp106_y))          ("��" "��" ("��" "��")))
    (((chord lkey_Thumb_Shift_L pkey_jp106_u))          ("��" "��" ("��" "��")))
    (((chord lkey_Thumb_Shift_L pkey_jp106_i))          ("��" "��" ("��" "��")))
    (((chord lkey_Thumb_Shift_L pkey_jp106_o))          ("��" "��" ("��" "��")))
    (((chord lkey_Thumb_Shift_L pkey_jp106_p))          ("��" "��" ("��" "��")))
    ;;(((chord lkey_Thumb_Shift_L pkey_jp106_at))         ("" "" ""))

    (((chord lkey_Thumb_Shift_L pkey_jp106_h))          ("��" "��" ("��" "��")))
    (((chord lkey_Thumb_Shift_L pkey_jp106_j))          ("��" "��" ("��" "��")))
    (((chord lkey_Thumb_Shift_L pkey_jp106_k))          ("��" "��" ("��" "��")))
    (((chord lkey_Thumb_Shift_L pkey_jp106_l))          ("��" "��" ("��" "��")))
    ;;(((chord lkey_Thumb_Shift_L pkey_jp106_semicolon))  ("" "" ""))
							 
    (((chord lkey_Thumb_Shift_L pkey_jp106_n))          ("��" "��" ("��" "��")))
    (((chord lkey_Thumb_Shift_L pkey_jp106_m))          ("��" "��" ("��" "��")))
    (((chord lkey_Thumb_Shift_L pkey_jp106_comma))      ("��" "��" ("��" "��")))
    (((chord lkey_Thumb_Shift_L pkey_jp106_period))     ("��" "��" ("��" "��")))
    ;;(((chord lkey_Thumb_Shift_L pkey_jp106_slash))      ("" "" ""))
    ))

(define ja-nicola-postfixed-voiced-consonant-ruleset
  '(
    ;; right hand side without shift
    ((pkey_jp106_bracketleft) ("��" "" ""))

    ;; right hand side with same-handed shift		 
    (((chord lkey_Thumb_Shift_R pkey_jp106_bracketleft)) ("��" "" ""))

    ;; right hand side with cross-shift			 
    ;;(((chord lkey_Thumb_Shift_R pkey_jp106_bracketleft)) ("" "" ""))

    ;; left hand side without shift
    ;;((pkey_jp106_q         pkey_jp106_bracketleft) ("��" "��" "��"))
    ((pkey_jp106_w         pkey_jp106_bracketleft) ("��" "��" ("��" "��")))
    ((pkey_jp106_e         pkey_jp106_bracketleft) ("��" "��" ("��" "��")))
    ((pkey_jp106_r         pkey_jp106_bracketleft) ("��" "��" ("��" "��")))
    ((pkey_jp106_t         pkey_jp106_bracketleft) ("��" "��" ("��" "��")))
		           
    ((pkey_jp106_a         pkey_jp106_bracketleft) (("��" "��") "��" ("��" "��")))
    ((pkey_jp106_s         pkey_jp106_bracketleft) ("��" "��" ("��" "��")))
    ((pkey_jp106_d         pkey_jp106_bracketleft) ("��" "��" ("��" "��")))
    ((pkey_jp106_f         pkey_jp106_bracketleft) ("��" "��" ("��" "��")))
    ((pkey_jp106_g         pkey_jp106_bracketleft) ("��" "��" ("��" "��")))
		           
    ;;((pkey_jp106_z         pkey_jp106_bracketleft) ("��" "��" "."))
    ((pkey_jp106_x         pkey_jp106_bracketleft) ("��" "��" ("��" "��")))
    ((pkey_jp106_c         pkey_jp106_bracketleft) ("��" "��" ("��" "��")))
    ((pkey_jp106_v         pkey_jp106_bracketleft) ("��" "��" ("��" "��")))
    ((pkey_jp106_b         pkey_jp106_bracketleft) ("��" "��" ("��" "��")))

    ;; right hand side without shift
    ;;((pkey_jp106_y         pkey_jp106_bracketleft) ("��" "��" "��"))
    ((pkey_jp106_u         pkey_jp106_bracketleft) ("��" "��" ("��" "��")))
    ((pkey_jp106_i         pkey_jp106_bracketleft) ("��" "��" ("��" "��")))
    ((pkey_jp106_o         pkey_jp106_bracketleft) ("��" "��" ("��" "��")))
    ;;((pkey_jp106_p         pkey_jp106_bracketleft) ("��" "��" ","))
    ;;((pkey_jp106_at        pkey_jp106_bracketleft) ("��" "��" "��"))

    ((pkey_jp106_h         pkey_jp106_bracketleft) ("��" "��" ("��" "��")))
    ((pkey_jp106_j         pkey_jp106_bracketleft) ("��" "��" ("��" "��")))
    ((pkey_jp106_k         pkey_jp106_bracketleft) ("��" "��" ("��" "��")))
    ;;((pkey_jp106_l         pkey_jp106_bracketleft) ("��" "��" "��"))
    ;;((pkey_jp106_semicolon pkey_jp106_bracketleft) ("��" "��" "��"))
			       
    ;;((pkey_jp106_n         pkey_jp106_bracketleft) ("��" "��" "��"))
    ((pkey_jp106_m         pkey_jp106_bracketleft) ("��" "��" ("��" "��")))
    ;;((pkey_jp106_comma     pkey_jp106_bracketleft) ("��" "��" "��"))
    ((pkey_jp106_period    pkey_jp106_bracketleft) ("��" "��" ("��" "��")))
    ;;((pkey_jp106_slash     pkey_jp106_bracketleft) ("��" "��" "��"))

    ;; left hand side without shift
    ((pkey_jp106_x      (chord lkey_Thumb_Shift_R pkey_jp106_bracketleft))
                                                      ("��" "��" ("��" "��")))
    ((pkey_jp106_v      (chord lkey_Thumb_Shift_R pkey_jp106_bracketleft))
                                                      ("��" "��" ("��" "��")))
    ((pkey_jp106_b      (chord lkey_Thumb_Shift_R pkey_jp106_bracketleft))
                                                      ("��" "��" ("��" "��")))

    ;; right hand side without shift
    ((pkey_jp106_h      (chord lkey_Thumb_Shift_R pkey_jp106_bracketleft))
                                                      ("��" "��" ("��" "��")))
    ((pkey_jp106_period (chord lkey_Thumb_Shift_R pkey_jp106_bracketleft))
                                                      ("��" "��" ("��" "��")))
    ))

;;(define ja-nicola-jp106-pseudo-thumb-shift-ruleset
;;  '((((lkey_Henkan   press   peek)) (($1 lkey_Thumb_Shift_R loopback)))
;;    (((lkey_Henkan   release peek)) (($1 lkey_Thumb_Shift_R loopback)))
;;    (((lkey_Muhenkan press   peek)) (($1 lkey_Thumb_Shift_L loopback)))
;;    (((lkey_Muhenkan release peek)) (($1 lkey_Thumb_Shift_L loopback)))))

(define ja-nicola-ruleset-name-list
  '(core
    postfixed-voiced-consonant))

(ja-define-dedicated-rulesets 'ja-nicola ja-nicola-ruleset-name-list)

(define ja-nicola-hiragana-ruleset
  (append
   ja-nicola-hiragana-core-ruleset
   ja-nicola-hiragana-postfixed-voiced-consonant-ruleset
   ja-nicola-jp106-pseudo-thumb-shift-ruleset))

(define ja-nicola-katakana-ruleset
  (append
   ja-nicola-katakana-core-ruleset
   ja-nicola-katakana-postfixed-voiced-consonant-ruleset
   ja-nicola-jp106-pseudo-thumb-shift-ruleset))

(define ja-nicola-halfkana-ruleset
  (append
   ja-nicola-halfkana-core-ruleset
   ja-nicola-halfkana-postfixed-voiced-consonant-ruleset
   ja-nicola-jp106-pseudo-thumb-shift-ruleset))

(define ja-nicola-hiragana-ruletree
  (evmap-parse-ruleset ja-nicola-hiragana-ruleset))

(define ja-nicola-katakana-ruletree
  (evmap-parse-ruleset ja-nicola-katakana-ruleset))

(define ja-nicola-halfkana-ruletree
  (evmap-parse-ruleset ja-nicola-halfkana-ruleset))
