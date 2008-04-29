;;; trec-tmp.scm: Experimental codes for trec.scm
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
;;; THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS ``AS
;;; IS'' AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO,
;;; THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
;;; PURPOSE ARE DISCLAIMED.  IN NO EVENT SHALL THE COPYRIGHT HOLDERS OR
;;; CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
;;; EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
;;; PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS;
;;; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
;;; WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR
;;; OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF
;;; ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
;;;;

;; PENDING TODO:
;; - proper route transition termination with rejected keys (needs SigScheme)
;;
;; TODO:
;; - fallback transition (to capture key-release, redundant timer-event)
;; -- register a release key-exp when key-press matcher has been activated
;; -- backtrack (("a" press) ("b" press) ("b" release) ("a" release))
;; -- fallback for key-release
;; - trigger a timer event
;;
;; - retrieve key-release event of a press-release pair
;;   -> transposer?
;;   -> (cons release-ev press-ev)?
;;   -> fallback transition
;; - deterministic transition mode
;; - cyclic transition with backtracking to start point of the cycle
;;   -> encode a mark to key (cons mark ev) and (find-tail marked? route)
;;   -> add 'flags' field to key-event and aggregate press,
;;      autorepeat, mark etc.
;;
;; - refactor transition drivers
;; - value extractor (flexibly replace the value when it is #f)
;; -- T-Code: "*", Anthy: "ky", "���"
;;
;; - rename 'route' to 'path'?
;; - rename 'branches' to 'junction'?
;; - route-route without explicit rest
;; - trec-context-driver (a set of methods) -> route-transition-driver
;;
;; - write trec-composer.scm
;; - obsolete 'consumed', 'loopback' and 'ext-state' of key-event
;;
;; DONE:
;; - support root rule '(() "a")
;; - rename match? of trec-node to key=?
;; - key replacement when advance
;; - virtual node
;; - support arbitrary predicate as expected key
;; - support arbitrary predicate as action seq
;; - overwriting recursion (erase previous route) -> route replacer proc?
;; - reroute when value is #f -> unneeded
;; - support time interval event
;; -- preorder timer event
;; - relative value reference
;; - rename route-elem
;;
;; REMINDER:
;; - use 'recycle' and 'peek' for key-side event control directive



;;
;; reroutable context
;;

(if trec-enable-reroutable-search?
    (begin
      (define trec-route-last-branches car)

      (define trec-route-next-siblings
	(compose cdr trec-route-last-branches))

      ;; .returns (new-route . rejected-keys)
      (define trec-route-advance
	(lambda (route rt-transit key)
	  (or (rt-transit route (trec-route-next-descendants route) key)
	      (trec-route-reroute route transit (list key)))))

      ;; .pre-condition At least contains one key
      (define trec-route-reroute
	(lambda (route rt-transit keys)
	  (let* ((cands (trec-route-next-siblings route))
		 (last-key (trec-route-last-key route))
		 (new-keys (cons last-key keys)))
	    (trec-route-route (cdr route) rt-transit new-keys cands))))

      ;; .returns (new-route . rejected-keys)
      (define trec-route-route
	(lambda (route rt-transit keys cands)
	  (or (and (null? keys)
		   (cons route ()))
	      (let ((next-rt.rej (rt-transit route cands (car keys))))
		(and next-rt.rej
		     (let* ((next-rt (car next-rt.rej))
			    (next-cands (trec-route-next-descendants next-rt))
			    (next-keys (append (cdr next-rt.rej)
					       (cdr keys))))
		       (trec-route-route next-rt rt-transit next-keys next-cands))))
	      (and (trec-route-root? route)
		   (cons route keys))
	      (trec-route-reroute route rt-transit keys))))

;;;; .returns (values next-route rejected-keys terminated?)
;;(define trec-route-route
;;  (lambda (route rt-transit keys cands)
;;    (or (and (null? keys)
;;	     (values route () #f))
;;	(receive (nx-rt rej-keys term?) (rt-transit route cands (car keys))
;;	  (and nx-rt
;;	       (if term?
;;		   (values nx-rt rej-keys term?)
;;		   (let ((nx-keys (append rej-keys (cdr keys)))
;;			 (nx-cands (trec-route-next-descendants nx-rt)))
;;		     (trec-route-route nx-rt rt-transit nx-keys nx-cands)))))
;;	(and (trec-route-root? route)
;;	     (values route keys #f))
;;	(trec-route-reroute route rt-transit keys))))

      ;; Search for another solution
      ;; .returns #f if succeeded. Otherwise rejected keys
      (define trec-context-reroute!
	(lambda (tc transit keys)
	  (let ((rt.rej (trec-route-reroute (trec-context-route tc) transit keys)))
	    (trec-context-update! tc rt.rej))))))



;;
;; test
;;

(define trec-romaji-basic-ruleset
  '((("a")             . ("��"))
    (("i")             . ("��"))
    (("u")             . ("��"))
    (("e")             . ("��"))
    (("o")             . ("��"))

    (("k" "a")         . ("��"))
    (("k" "i")         . ("��"))
    (("k" "u")         . ("��"))
    (("k" "e")         . ("��"))
    (("k" "o")         . ("��"))

    (("k" "k")         . ("��" "k"))
    (("k" "k" "a")     . ("��" "��"))
    (("k" "k" "i")     . ("��" "��"))
    (("k" "k" "u")     . ("��" "��"))
    (("k" "k" "e")     . ("��" "��"))
    (("k" "k" "o")     . ("��" "��"))

    (("k" "y" "a")     . ("��" "��"))
    (("k" "y" "i")     . ("��" "��"))
    (("k" "y" "u")     . ("��" "��"))
    (("k" "y" "e")     . ("��" "��"))
    (("k" "y" "o")     . ("��" "��"))

    ;;(("k" "k" "y")     . ("��" "k" "y"))
    (("k" "k" "y" "a") . ("��" "��" "��"))
    (("k" "k" "y" "i") . ("��" "��" "��"))
    (("k" "k" "y" "u") . ("��" "��" "��"))
    (("k" "k" "y" "e") . ("��" "��" "��"))
    (("k" "k" "y" "o") . ("��" "��" "��"))
    ))

(define match? string=?)
(define seed
  (trec-route-new (trec-parse-ruleset string=? trec-romaji-basic-ruleset)))
(define trec-romaji-basic-root seed)

(define trec-romaji-double-consonant-ruleset
  '(
    ))

;; �ʲ��ξ��֤���̤˸ƤӽФ�¦�����Τ���ɬ�פ�����
;; - ���ܤ���
;; - ���Ϥ���񤷤�
(define trec-romaji-n-ruleset
  '(
    ;; must be defined before "NA" row to take less precedence
    (("n" (char-nonvowel press peek loopback)) ("��"))
    (("n" (char-nonvowel press peek)) ("��" (inject $2)))

    ;; must be placed after above "nk" rule
    (("n" "n")                        ("��"))
    ))

;; ��
(define trec-romaji-hepburn-n-ruleset
  '(;; "namba" -> "�ʤ��"
    (("m" ("b" press peek loopback)) ("��"))
    (("m" ("b" peek)) ("��" (inject $2)))

    ;; "homma" -> "�ۤ��"
    (("m" ("m" press peek loopback)) ("��"))
    (("m" ("m" peek)) ("��" (inject $2)))

    ;; "kampo" -> "�����"
    (("m" ("p" press peek loopback)) ("��"))
    (("m" ("p" peek)) ("��" (inject $2)))
    (("m" "p") ("��" (sink $2)))  ;; peek��ɬ�ס�route�ؤε�Ͽ���򤱤뤿��
    (("m" ("p" peek)) ("��" loopback))  ;; ������?
    ))

;; ����������
;; - �ϥ󥰥��Ʊ�ͤ�backward-match�ǰ���?
(define trec-romaji-hepburn-oh-ruleset
  '((("o" "h"     (char-nonvowel press peek loopback)) ("��" "��"))
    (("k" "o" "h" (char-nonvowel press peek loopback)) ("��" "��"))
    (("g" "o" "h" (char-nonvowel press peek loopback)) ("��" "��"))
    (("t" "o" "h" (char-nonvowel press peek loopback)) ("��" "��"))
    ))

(define trec-romaji-hepburn-oh-states
  '(initial_o
    initial_oh_sensitive_consonant
    sensitive_consonant_prefixed_oh
    bare_oh
    ))

;; ��§¥�� �Ѵ���ɽ��
(define trec-romaji-hepburn-irregular-double-consonant-guide-ruleset
  '((("t" "c")         ("��" "c")))
    (("t" "c" "h")     ("��" "c" "h")))

;; ��§¥��
(define trec-romaji-hepburn-irregular-double-consonant-ruleset
  '((("t" "c" "h" "a") ("��" "��" "��"))
    (("t" "c" "h" "i") ("��" "��" "��"))
    (("t" "c" "h" "u") ("��" "��" "��"))
    (("t" "c" "h" "o") ("��" "��" "��"))))

(define trec-romaji-hepburn-irregular-double-consonant-ruleset
  '((("t" "c" "h") ("��" (join $2 $3)))))

(define trec-cyclic-ruleset
  '((("1")                   . ("��"))
    (("1" "1")               . ("��"))
    (("1" "1" "1")           . ("��"))
    (("1" "1" "1" "1")       . ("��"))
    (("1" "1" "1" "1" "1")   . ("��"))

    (("1" "1" "1" "1" "1" ("1" init recycle))   . #f)  ;; re-init as root
    (("1" "1" "1" "1" "1" ("1" restart recycle))   . #f)  ;; re-init as root
    (("1" "1" "1" "1" "1" ("1" recur recycle))  . #f)  ;; recursively into root

    ;; how to revert?
    ;; - (find-tail marked? route)
    ;;   -> encode a mark to key
    ;;     -> (cons attr ev)
    ((("1" mark-prev) "1" "1" "1" "1" ("1" revert recycle))  . ())  ;; backtrack to the marked point
    ((("1" mark-prev) "1" "1" "1" "1" ("1" return recycle))  . ())  ;; backtrack to the marked point
    ((("1" mark-prev) "1" "1" "1" "1" ("1" backtrack recycle))  . ())  ;; backtrack to the marked point

    (("1" "1" "1" "1" "1" ("1" recycle)) . ((join)))
    (("1" "1" "1" "1" "1" "1") . ((join "1")))
    (("1" "1" "1" "1" "1" "1") . ((join $6)))
    (("1" "1" "1" "1" "1" "1") . ((join $last)))
    (("1" "1" "1" "1" "1" "1") . ((join $-1)))
    ))

;;
;; trec
;;
(define trec-romaji-n-ruleset
  '(
    ;; must be defined before "��" row to take less precedence
    (("n" (char-nonvowel press) . (peek)) . ("��"))
    (("n" (char-nonvowel press) . (recur-retry)) . ("��"))
    (("n" terminate) . ("��"))

    ;; must be placed after above "nk" rule to take precedence
    (("n" "n") . ("��"))
    ))
(define trec-romaji-hepburn-n-ruleset
  ;; peek��ɬ�ס�route�ؤε�Ͽ���򤱤뤿��
  '(;; "namba" -> "�ʤ��"
    (("m" ("b" press) . (peek)) . ("��"))
    (("m" ("b" press) . (recycle-recur)) . ("��"))
    (("m" ("b" press) . (recur-retry)) . ("��"))

    ;; "homma" -> "�ۤ��"
    (("m" ("m" press) . (peek)) . ("��"))

    ;; "kampo" -> "�����"
    (("m" ("p" press) . (peek)) . ("��"))
    ))

(define trec-cyclic-ruleset
  '((("1")                 . ("��"))
    (("1" "1")             . ("��"))
    (("1" "1" "1")         . ("��"))
    (("1" "1" "1" "1")     . ("��"))
    (("1" "1" "1" "1" "1") . ("��"))

    ;; peek, recur, restart, recur-retry, restart-retry

    ;; reroute: continue(default), join, restart
    ;; key:     consume(default), recycle, peek, reinject
    ;; recycle implies peek? -> #f as matched key
    ;; recur���join�������狼��䤹��
    ;; reroot���restart
    (("1" "1" "1" "1" "1" . (restart))   . ("��"))  ;; re-init as root
    (("1" "1" "1" "1" "1" . (recur))     . ("��"))  ;; recursively into root
    (("1" "1" "1" "1" "1" "1" . (recycle restart))   . #f)  ;; re-init as root
    (("1" "1" "1" "1" "1" "1" . (recycle recur))  . #f)  ;; recursively into root
    (("1" "1" "1" "1" "1" "1" . (recycle (join)))  . #f)  ;; recursively into root
    (("1" "1" "1" "1" "1" "1" . (recycle (join "2")))  . #f)  ;; recursively into root and inject "2"
    (("1" "1" "1" "1" "1" "1" . (recycle (restart)))  . #f)  ;; recursively into root
    (("1" "1" "1" "1" "1" "1" . (recycle (restart st_2nd_cycle)))  . #f)  ;; recursively into root and inject st_2nd_cycle

    (("1" "1" "1" "1" "1" "1" . (recycle))  . #f)  ;; recycle last input
    (("1" "1" "1" "1" "1" "1" . (join))  . #f)  ;; recursively into root
    (("1" "1" "1" "1" "1" "1" . (join "2"))  . #f)  ;; recursively into root and inject "2"
    (("1" "1" "1" "1" "1" "1" . (restart))  . #f)  ;; recursively into root
    (("1" "1" "1" "1" "1" "1" . (restart st_2nd_cycle))  . #f)  ;; recursively into root and inject st_2nd_cycle
    (("1" "1" "1" "1" "1" "1" . (recycle-join))  . #f)  ;; recursively into root
    (("1" "1" "1" "1" "1" "1" . (recycle-join "2"))  . #f)  ;; recursively into root and inject "2"
    (("1" "1" "1" "1" "1" "1" . (recycle-restart))  . #f)  ;; recursively into root
    (("1" "1" "1" "1" "1" "1" . (recycle-restart st_2nd_cycle))  . #f)  ;; recursively into root and inject st_2nd_cycle
    ))

(define trec-chord-ruleset
  '(
    ((("a" press) ("b" press)) ((join st_ab)))
    ((("b" press) ("a" press)) ((join st_ab)))

    ((st_ab ("a" release) ("b" release)) ("AB"))
    ((st_ab ("b" release) ("a" release)) ("AB"))
    ))

(define trec-chord3-ruleset
  '(
    ((("a" press) ("b" press)) ((join st_ab)))
    ((("b" press) ("a" press)) ((join st_ab)))

    ((("a" press) ("c" press)) ((join st_ac)))
    ((("c" press) ("a" press)) ((join st_ac)))

    ((("b" press) ("c" press)) ((join st_bc)))
    ((("c" press) ("b" press)) ((join st_bc)))

    ((st_ab ("c" press)) ((join st_abc)))
    ((st_ac ("b" press)) ((join st_abc)))
    ((st_bc ("a" press)) ((join st_abc)))

    ((st_abc ("a" release) ("b" release)) ((join st_AB)))
    ((st_abc ("b" release) ("a" release)) ((join st_AB)))

    ((st_abc ("a" release) ("c" release)) ((join st_AC)))
    ((st_abc ("c" release) ("a" release)) ((join st_AC)))

    ((st_abc ("b" release) ("c" release)) ((join st_BC)))
    ((st_abc ("c" release) ("b" release)) ((join st_BC)))

    ((st_AB ("c" release)) ("ABC"))
    ((st_AC ("b" release)) ("ABC"))
    ((st_BC ("a" release)) ("ABC"))
    ))

(define trec-keyset-chord3-ruleset
  '(
    ((set ("a" press) ("b" press) ("c" press)) ((join st_abc)))
    ((st_abc (set ("a" release) ("b" release) ("c" release)) ("ABC")))
    ))

(define trec-keyset-chord3-ruleset
  '(
    (((set ("a" press)   ("b" press)   ("c" press))
      (set ("a" release) ("b" release) ("c" release))) ("ABC"))
    ))

(define trec-keyset-chord3-ruleset
  '(
    ((chord "a" "b" "c") . ("ABC"))
    ))

(define trec-chord-ruleset
  '(
    ))

(define trec-ordrered-chord-ruleset
  '(
    ))

;; chord���̾��sequencing����³
(define trec-nicola-core-ruleset
  '(
    ;; left hand side without shift
    ((pkey_jp106_x)                                                   ("��"))
    ((pkey_jp106_x pkey_jp106_bracketleft)                            ("��"))
    ;; right hand side with cross-shift			 
    (((chord lkey_Thumb_Shift_L pkey_jp106_p))                        ("��"))
    ;; right hand side with same-handed shift		 
    (((chord lkey_Thumb_Shift_R pkey_jp106_bracketleft))              ("��"))
    ;; left hand side without shift
    ((pkey_jp106_x (chord lkey_Thumb_Shift_R pkey_jp106_bracketleft)) ("��"))
    ))


(define trec-romaji-basic-ruletree
  (trec-parse-ruleset string=? trec-romaji-basic-ruleset))

(define trec-ja-testcases
  '(
    "a" "��"

    "na" "��"
    "nya" "�ˤ�"
    "nka" "��"
    "n1" "��1"
    "nq" "��q"
    "nn" "��"
    "n'" "��"
    "n." "��"

    "go" "��"
    "goh" "��h"
    "goh." "������"
    "goha" "����"
    "gohk" "����k"
    "gohka" "������"
    "gohkk" "����kk"
    "gohkka" "�����ä�"
    "goto" "����"
    "gotoh" "����h"
    "gotoh." "���Ȥ���"
    "got" "��t"
    "gotc" "��tc"
    "gotch" "����ch"
    "gotcha" "���ä���"
    "gotcho" "���ä���"
    "gotchoh" "���ä���h"
    "gotchoh." "���ä��礦��"
    "gotchoho" "���ä����"
    "gotchohoh" "���ä����h"
    "gotchohoh." "���ä���ۤ���"
    "gotchohoho" "���ä���ۤ�"
    "gotchohohoh" "���ä���ۤ�h"
    "gotchohohoh." "���ä���ۤۤ���"
    "gotchohho" "���ä���ä�"
    "gotchohhoh" "���ä���ä�h"
    "gotchohhoh." "���ä���äۤ���"
    "gotchohhoho" "���ä���äۤ�"

    "o" "��"
    "oh" "��h"
    "oh." "������"
    "oho"  "����"
    "ohoh"  "����h"
    "ohoh."  "���ۤ���"
    "ohoho"  "���ۤ�"
    "ohohoh"  "���ۤ�h"
    "ohohoh."  "���ۤۤ���"
    "oht" "��ht"
    "ohta" "������"
    "ohto" "������"
    "ohtoh" "������h"
    "ohtoh." "�����Ȥ���"
    "ohyo"  "���Ҥ�"

    "no" "��"
    "noh" "�Τ�"
    "noho" "�Τ�"
    "nohoh" "�Τۤ�"
    "nohoho" "�Τۤ�"
    "nohohoh" "�Τۤۤ�"
    "nohho" "�Τä�"
    "nohhoh" "�Τäۤ�"
    "nohhoho" "�Τäۤ�"
    "nohyo" "�ΤҤ�"
    "nohhyo" "�ΤäҤ�"
    "nohhyoh" "�ΤäҤ礦"
    "nohhyoho" "�ΤäҤ��"
    "nohhyohoh" "�ΤäҤ�ۤ�"

    "kam" "��m"
    "kamo" "����"
    "kamp" "����p"
    "kampo" "�����"
    "kampou" "����ݤ�"
    "kampoh" "�����h"
    "kampoh." "����ݤ���"
    "kampoho" "����ݤ�"
    "kampohoh" "����ݤ�h"
    "kampohoh." "����ݤۤ���"
    "kampohoho" "����ݤۤ�"
    "kampohohoh" "����ݤۤ�h"
    "kampohohoh." "����ݤۤۤ���"
    "kampohho" "����ݤä�"
    "kampohhoh" "����ݤä�h"
    "kampohhoh." "����ݤäۤ���"
    "kampohhoho" "����ݤäۤ�"
    "kampohhohoh" "����ݤäۤ�h"
    "kampohhohoh." "����ݤäۤۤ���"
    ))

;;
;; dynamic-node
;;

(define trec-node-mtbl-rec-spec
  '((key=?       node key)
    (match?      node key)
    (consume?    node key)
    (value       node)
    (next-branches node key)
    (advance     node route)
    (backtrack   node route)))

(define f
  (lambda (restart retry)
    (lambda (key value)
      (lambda (router route pregiven-keys key)
	(let ((root (trec-route-root route))
	      (keys (if retry
			(append pregiven-keys (list key))
			pregiven-keys)))
	  (if restart
	      (trec-route-route router root keys)
	      (trec-route-route router (cons root route) keys)))))))  ;; recur

(define trec-router-std-advance-new
  (lambda (matcher)
    (lambda (route cands key)
      (let recycle ((route route)
		    (cands cands))
	(and-let* ((transit (lambda (branch)
			      (and-let* ((matched (matcher (trec-node-key branch)
							   key)))
				(if (trec-vkey-terminal-state matched)
				    (subcons key branch)
				    (cons* key TREC-NULL-VALUE
					   (list (subcons matched branch)))))))
		   (advanced (find-car-mapped-tail transit cands)))
	  (if (eq? matched TREC-VKEY-RECYCLE)
	      (recycle (cons (subcons TREC-NULL-KEY advanced)
			     route)
		       (trec-node-branches (car advanced)))
	      (values (cons advanced route) ())))))))

;; basic
(define trec-node-merge-rule!
  (lambda (node key=? backward-match rule)
    (let* ((descend! (lambda (key cur-node)
		       (trec-node-descend! cur-node key=? key)))
	   (leaf (fold descend! node (trec-rule-path rule))))
      (trec-node-set-val! leaf (trec-rule-value rule))
      node)))

;; basic with backward-match
(define trec-node-merge-rule!
  (lambda (node key=? backward-match rule)
    (let* ((descend! (lambda (key cur-node)
		       (trec-node-descend! cur-node key=? key)))
	   (keys (if backward-match
		     (reverse (trec-rule-path rule))
		     (trec-rule-path rule)))
	   (leaf (fold descend! node keys)))
      (trec-node-set-val! leaf (trec-rule-value rule))
      node)))

;; insert as vnode
(define trec-node-merge-rule!
  (lambda (node key=? backward-match rule)
    (receive (leaf special-node)
	(let descend ((cur-node node)
		      (rest-keys (if backward-match
				     (reverse (trec-rule-path rule))
				     (trec-rule-path rule))))
	  (if (pair? rest-keys)
	      (descend (trec-node-descend! cur-node key=? (car rest-keys))
		       (cdr rest-keys))
	      (values cur-node rest-keys)))
      (if (null? special-node)
	  (trec-node-set-val! leaf (trec-rule-value rule))
	  (trec-node-insert-branch! leaf special-node))
      node)))
      
(define trec-node-normal? pair?)


(define foo
  (lambda (one)
    (lambda (two three)
      (let loop ((tw two)
		 (th three))
	(if (zero? tw)
	    #t
	    (begin
	      (write tw)
	      (newline)
	      (loop (- tw one) th)))))))

(define foo2
  (lambda (one)
    (letrec ((loop (lambda (tw th)
		     (if (zero? tw)
			 #t
			 (begin
			   (write tw)
			   (newline)
			   (loop (- tw one) th))))))
      loop)))
(define bar2 (foo2 1))
(bar2 4 3)

(define foo4
  (lambda (one)
    (define loop
      (lambda (tw th)
	(if (zero? tw)
	    #t
	    (begin
	      (write tw)
	      (newline)
	      (loop (- tw one) th)))))
    loop))
(define (foo4 one)
  (define (loop tw th)
    (if (zero? tw)
	#t
	(begin
	  (write tw)
	  (newline)
	  (loop (- tw one) th))))
  loop)
(define bar4 (foo4 1))
(bar4 4 3)

(define foo3
  (lambda (one)
    (let loop ((tw two)
	       (th three))
      (if (zero? tw)
	  #t
	  (begin
	    (write tw)
	    (newline)
	    (loop (- tw one) th))))))


(define trec-router-std-advance-new
  (lambda (matcher)
    (letrec ((proc
	      (lambda (route cands key)
		(and (not (null? cands))
		     (or (and-let* ((matched (trec-node-match (car cands)
							      matcher key))
				    (advanced (cons (cons matched (cdr cands))
						    route)))
			   (if (eq? (car matched) TREC-VKEY-RECYCLE)
			       (proc advanced (trec-node-branches matched) key)
			       (values advanced ())))
			 (proc route (cdr cands) key))))))
      proc)))


(define find-car-mapped-tail
  (lambda (f lst)
    (and (not (null? lst))
	 (let ((mapped (f (car lst))))
	   (if mapped
	       (cons mapped (cdr lst))
	       (find-car-mapped-tail f (cdr lst)))))))

(define find-with-rest
  (lambda (f lst)
    (and-let* ((tail (find-tail f lst)))
      (values (car tail) (cdr tail)))))

;;(define trec-node-normal? pair?)
;;  (lambda (node)
;;    (pair? node)

(define f2
  (lambda (restart retry)
    (lambda (pregiven-keys)
      (letrec ((make-vnode
		(lambda (rule-key)
		  (lambda (router route key)
		    (let ((root (trec-route-root route))
			  (keys (if retry
				    (append pregiven-keys (list key))
				    pregiven-keys)))
		      (if restart
			  (trec-route-route router root keys)
			  (trec-route-route router (cons root route) keys)))))))
	make-vnode))))

(define (trec-router-std-advance-new matcher)
  (define (self route cands key)
    (and (not (null? cands))
	 (let ((node (car cands))
	       (rest (cdr cands)))
	   (or (if (trec-vnode? node)
		   (node self route matcher key)
		   (and-let* ((matched (matcher (trec-node-key node) key))
			      (new-node (trec-make-node node matched key))
			      (advanced (cons (cons new-node rest)
					      route)))
		     (if (eq? matched TREC-VKEY-RECYCLE)
			 (self advanced
			       (trec-node-branches new-node) key)
			 (values advanced ()))))
	       (self route rest key)))))
  self)

;; ����
(define (trec-router-std-advance-new matcher)
  (define (self route cands key)
    (and (not (null? cands))
	 (or (if (trec-vnode? (car cands))
		 ((car cands) self route matcher key)
		 (and-let* ((matched (matcher (trec-node-key (car cands)) key))
			    (new-node (trec-make-node (car cands) matched key))
			    (advanced (cons (cons new-node (cdr cands))
					    route)))
		   (if (eq? matched TREC-VKEY-RECYCLE)
		       (self advanced
			     (trec-node-branches new-node) key)
		       (values advanced ()))))
	     (self route (cdr cands) key))))
  self)

(define (trec-make-vnode-recur-new restart retry)
  (lambda (pregiven-keys)
    (define (make-vnode rule-key rule-val)
      (lambda (router route matcher key)
	(and-let* ((matched (matcher rule-key key)))
	  (if (not (trec-vkey-terminal-state matched))
	      (let ((next-node (make-vnode matched rule-val)))
		(cons (list key TREC-NULL-VALUE next-node)
		      route))
	      (let ((root (trec-route-root route))
		    (keys (if retry
			      (append pregiven-keys (list key))
			      pregiven-keys))
		    (node (cond
			   ((eq? matched TREC-VKEY-FIN)
			    (list key rule-val))
			   ((eq? matched TREC-VKEY-RECYCLE)
			    (list TREC-NULL-KEY rule-val)))))
		(trec-route-route router
				  (if restart
				      root
				      (cons* root node route))
				  keys))))))
    make-vnode))

(define (trec-router-std-advance-new matcher)
  (define (loop route cands key)
    (and (not (null? cands))
	 (or (and-let* ((matched (trec-node-match (car cands) matcher key))
			(advanced (cons (cons matched (cdr cands))
					route)))
	       (if (eq? (trec-node-key matched) TREC-VKEY-RECYCLE)
		   (loop advanced (trec-node-branches matched) key)
		   (values advanced ())))
	     (loop route (cdr cands) key))))
  loop)

(define trec-node-match
  (lambda (node matcher key)
    (and-let* ((matched (matcher (trec-node-key node) key)))
      (cond
       ((eq? matched TREC-VKEY-FIN)
	(cons key (cdr node)))
       ((eq? matched TREC-VKEY-RECYCLE)
	(cons TREC-NULL-KEY (cdr node)))
       (else
	(let ((next-node (if (trec-vnode? node)
			     ()
			     (cons matched (cdr node)))))
	  (cons* key TREC-NULL-VALUE (list next-node))))))))

(define trec-router-std-advance-new
  (lambda (matcher)
    (define loop
      (lambda (route cands key)
	(and (not (null? cands))
	     (or (and-let* ((matched (trec-node-match (car cands) matcher key))
			    (advanced (cons (cons matched (cdr cands))
					    route)))
		   (if (eq? (trec-node-key matched) TREC-VKEY-RECYCLE)
		       (loop advanced (trec-node-branches matched) key)
		       (values advanced ())))
		 (loop route (cdr cands) key)))))
    loop))

;;(base-router route (trec-route-next-descendants root) key)

(define trec-vnode-peek-new
  (lambda (key value)
    (lambda (router route pregiven-keys key)
      (if (not (null? pregiven-keys))
	  (error "'peek' does not take arguments")
	  (values (cons (cons TREC-NULL-KEY (cdar route))
			(cdr route))
		  (list key))))))

;; ordinary:
;; (keyset "a" "b" "c")
;;
;; interval:
;; (keyset ("a" (interval 100) "b") ("c" (interval 100) "d"))
;;
;; nested:
;; (keyset (keyset "a" "b") (keyset "c" "d"))
;;
;; ordered-chord:
;; ((lkey_a press) (lkey_b press)
;;  (keyset (lkey_a release) (lkey_b release)))
;;
;; chord:
;; ((keyset (lkey_a press) (lkey_b press))
;;  (keyset (lkey_a release) (lkey_b release)))
;;

;; substitute car of a pair safely
(define subcons
  (lambda (kar lst)
    (and (not (null? lst))
	 (cons kar (cdr lst)))))


;; others

;; - longest-suffix? suffix-tree?, backward-match?
;; .returns (rejected-keys head-route . tail-route) or #f if failed
;; TODO: make refined
(define trec-route-split-longest-tail
  (lambda (route transit keys)
    (let ((root (trec-route-root route)))
      (let loop ((head root)
		 (rest-keys (append (trec-route-keys route) keys)))
	(and-let* (((not (null? rest-keys)))
		   (rt.rej (trec-route-advance head transit (car rest-keys)))
		   ((not (cdr rt.rej))))
	  (let* ((advanced (car rt.rej))
		 (rest (trec-route-next-descendants root))
		 (rt.rej2 (trec-route-route root transit
					    (cdr rest-keys) rest)))
	    (if (and (not (cdr rt.rej2))
		     (trec-route-value (car rt.rej2))) ;; unneeded?
		(cons advanced
		      (car rt.rej2))
		(loop advanced (cdr rest-keys)))))))))

(define trec-node-find-subtree
  (lambda (node key=? key)
    (find-tail (lambda (branch)
		 (key=? (trec-node-key branch) key))
	       (trec-node-branches node))))

(define trec-node-descend!
  (lambda (node key=? key)
    (or (safe-car (trec-node-find-subtree node key=? key))
	(car (trec-node-insert-branch! node (trec-node-new key))))))

(define trec-route-filter-keys
  (lambda (route pred)
    (trec-route-filter-map route
			   (lambda (node)
			     (and (pred (trec-node-key node))
				  (trec-node-key node))))))

(define trec-route-filter-map
  (lambda (route f)
    (pair-fold (lambda (rest filtered)
		 (let ((mapped (f (trec-route-last-node rest))))
		   (or (and mapped
			    (cons mapped filtered))
		       filtered)))
	       ()
	       route)))

;; FIXME contain last value?
(define trec-route-joint-values
  (lambda (route)
    (pair-fold (lambda (rest vals)
		 (if (and (trec-node-root? (trec-route-last-node rest))
			  (not (last-pair? rest)))
		     (cons (trec-node-val (trec-route-last-node (cdr rest)))
			   vals)
		     vals))
	       ()
	       route)))

;; FIXME: support joint-root
(define trec-route-keys
  (lambda (route)
    (unfold-right trec-route-root? trec-route-point-key cdr route)))

(define trec-route-point-key
  (if trec-enable-reroutable-search?
      (compose trec-node-key car)
      trec-node-key))

(define trec-matcher-vanilla-new
  (lambda (match?)
    (lambda (key-exp key)
      (and (match? key-exp key)
	   TREC-MATCHER-FIN))))

(define trec-node-merge-rule!
  (lambda (node key=? rule)
    (let* ((val (trec-rule-value rule))
	   (descend! (lambda (keys cur-node)
		       (if (trec-vnode-directive? (cdr keys))
			   (let* ((make-vnode (cdr keys))
				  (vnode (make-vnode (car keys) val)))
			     (trec-node-insert-branch! cur-node vnode)
			     #f)
			   (trec-node-descend! cur-node key=? (car keys)))))
	   (leaf (pair-fold descend! node (trec-rule-path rule))))
      (if leaf
	  (trec-node-set-val! leaf val))
      node)))

(define trec-node-merge-ruleset!
  (lambda (node key=? backward-match ruleset)
    (let ((merge! (if backward-match
		      (lambda (rule node)
			(let ((rev-rule (cons (reverse (trec-rule-path rule))
					      (trec-rule-value rule))))
			  (trec-node-merge-rule! node key=? rev-rule)))
		      (lambda (rule node)
			(trec-node-merge-rule! node key=? rule)))))
      (fold merge! node ruleset))))
