;;;
;;; Copyright (c) 2003-2007 uim Project http://code.google.com/p/uim/
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
;;; THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS ``AS IS'' AND
;;; ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
;;; IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
;;; ARE DISCLAIMED.  IN NO EVENT SHALL THE COPYRIGHT HOLDERS OR CONTRIBUTORS BE LIABLE
;;; FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
;;; DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS
;;; OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
;;; HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
;;; LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
;;; OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF
;;; SUCH DAMAGE.
;;;;

;;; tutcode.scm: TUT-Code for Japanese input.
;;;
;;; TUT-Code<http://www.crew.sfc.keio.ac.jp/~chk/>���ϥ�����ץȡ�
;;; TUT-Code��������ܸ�����Ϥ�Ԥ���
;;;
;;; �ǥե���ȤΥ�����ɽ(�������ȥ��������Ϥ����ʸ���Ȥ��б�)
;;; �Ǥ���tutcode-rule��QWERTY�����ܡ����ѡ�
;;;
;;; ����������Ѵ���
;;;   ���ַ��Τ߼������Ƥ��ޤ���
;;;   �Ƶ�Ū����������Ѵ����ǽ�Ǥ���
;;;   ��������Υ��르�ꥺ���tc-2.1�Τ�ΤǤ���
;;; 
;;; �ڸ򤼽��Ѵ���
;;;   ñ������ַ��򤼽��Ѵ����Ǥ��ޤ���
;;;   �򤼽��Ѵ������tc2��Ʊ������(SKK�����Ʊ�ͤη���)�Ǥ���
;;; 
;;; * �򤼽��Ѵ�����(��:/usr/local/share/tc/mazegaki.dic)�ؤΥ���������
;;;   libuim-skk.so�ε�ǽ��ȤäƤ��ޤ���
;;;   ���Τ��ᡢ�ؽ���ǽ��SKK��Ʊ�ͤ�ư��ˤʤ�ޤ�:
;;;     ���ꤷ������ϼ�����Ѵ�������Ƭ����ޤ���
;;;     ���ꤷ������ϸĿͼ���(~/.mazegaki.dic)����¸����ޤ���
;;; 
;;; * ���Ѥ������Ѵ��ϼ�ưŪ�ˤϹԤ��ޤ���
;;;   �ɤߤ�����Ū��"��"���ղä����Ѵ����Ƥ���������
;;; 
;;; * �򤼽��Ѵ��ط���̤�����ε�ǽ
;;;  - ���ַ��򤼽��Ѵ�
;;;  - �򤼽��Ѵ�����ؤ���Ͽ�������
;;;  - �ɤߤ򿭤Ф�����̤᤿�ꤹ�뵡ǽ���ɤߤ��䴰��ǽ
;;;  - �������򥦥���ɥ��λ���
;;;
;;; ���������
;;; * ������ɽ�ΰ������ѹ����������ϡ��㤨��~/.uim�ǰʲ��Τ褦�˵��Ҥ��롣
;;;   (require "tutcode.scm")
;;;   (tutcode-rule-set-sequences!
;;;     '(((("s" " "))("��"))                ; �����������ѹ�
;;;       ((("a" "l" "i"))("Ľ"))            ; �ɲ�
;;;       ((("d" "l" "u"))("��" "��"))       ; �������ʤ�ޤ���
;;;       ((("d" "l" "d" "u"))("��" "��"))))
;;;
;;; * T-Code��Ȥ��������
;;;   uim-pref-gtk�������ꤹ�뤫��~/.uim�ǰʲ��Τ褦�����ꤷ�Ƥ���������
;;;    (define tutcode-rule-filename "/usr/local/share/uim/tcode.scm")
;;;    (define tutcode-mazegaki-start-sequence "fj")
;;;    (define tutcode-bushu-start-sequence "jf")
;;;
;;; �ڥ������ˤĤ��ơ�
;;; generic.scm��١����ˤ��ưʲ����ѹ��򤷤Ƥ��롣
;;;  * ��������������Υ��ڡ�����ͭ���ˤʤ�褦���ѹ���
;;;  * �Ҥ餬��/�������ʥ⡼�ɤ��ڤ��ؤ����ɲá�
;;;  * rk�������̤����(preedit)ʸ�����ɽ���򤷤ʤ��褦�ˤ���
;;;    (Emacs��T/TUT-Code���ϴĶ�tc2�Ǥ�ɽ�����ʤ��ΤǤ���˹�碌��)��
;;;  * �򤼽��Ѵ��Ǥ�SKK�����μ����Ȥ��Τǡ�
;;;    skk.scm�Τ��ʴ����Ѵ���������ɬ�פ���ʬ������ߡ�
;;;  * ��������Ѵ���ǽ���ɲá�

(require "generic.scm")
(require-custom "tutcode-custom.scm")
(require-custom "generic-key-custom.scm")
(require-custom "tutcode-key-custom.scm")
(load-plugin "skk") ;SKK�����θ򤼽񤭼���θ����Τ��ᡢlibuim-skk.so�����
(require "tutcode-bushudic.scm") ;��������Ѵ�����

;;; user configs

;; widgets and actions

;; widgets
(define tutcode-widgets '(widget_tutcode_input_mode))

;; default activity for each widgets
(define default-widget_tutcode_input_mode 'action_tutcode_direct)

;; actions of widget_tutcode_input_mode
(define tutcode-input-mode-actions
  '(action_tutcode_direct
    action_tutcode_hiragana
    action_tutcode_katakana))

;;; ���Ѥ��륳����ɽ��
;;; tutcode-context-new����(tutcode-custom-load-rule!)������
(define tutcode-rule ())

;;; ������ɽ�����ѹ�/�ɲä��뤿��Υ�����ɽ��
;;; ~/.uim��tutcode-rule-set-sequences!����Ͽ���ơ�
;;; tutcode-context-new����ȿ�Ǥ��롣
(define tutcode-rule-userconfig ())

;;; implementations

;;; �򤼽��Ѵ�����ν����������äƤ��뤫�ɤ���
(define tutcode-dic-init #f)

(define tutcode-prepare-activation
  (lambda (tc)
    (let ((rkc (tutcode-context-rk-context tc)))
      (rk-flush rkc))))

(register-action 'action_tutcode_direct
		 (lambda (tc)
		   '(ja_halfwidth_alnum
		     "a"
		     "ľ������"
		     "ľ�����ϥ⡼��"))
		 (lambda (tc)
		   (not (tutcode-context-on? tc)))
		 (lambda (tc)
		   (tutcode-prepare-activation tc)
		   (tutcode-context-set-state! tc 'tutcode-state-off)))

(register-action 'action_tutcode_hiragana
		 (lambda (tc)
		   '(ja_hiragana
		     "��"
		     "�Ҥ餬��"
		     "�Ҥ餬�ʥ⡼��"))
		 (lambda (tc)
		   (and (tutcode-context-on? tc)
			(not (tutcode-context-katakana-mode? tc))))
		 (lambda (tc)
		   (tutcode-prepare-activation tc)
		   (tutcode-context-set-state! tc 'tutcode-state-on)
		   (tutcode-context-set-katakana-mode! tc #f)))

(register-action 'action_tutcode_katakana
		 (lambda (tc)
		   '(ja_katakana
		     "��"
		     "��������"
		     "�������ʥ⡼��"))
		 (lambda (tc)
		   (and (tutcode-context-on? tc)
			(tutcode-context-katakana-mode? tc)))
		 (lambda (tc)
		   (tutcode-prepare-activation tc)
		   (tutcode-context-set-state! tc 'tutcode-state-on)
		   (tutcode-context-set-katakana-mode! tc #t)))

;; Update widget definitions based on action configurations. The
;; procedure is needed for on-the-fly reconfiguration involving the
;; custom API
(define tutcode-configure-widgets
  (lambda ()
    (register-widget 'widget_tutcode_input_mode
		     (activity-indicator-new tutcode-input-mode-actions)
		     (actions-new tutcode-input-mode-actions))))

(define tutcode-context-rec-spec
  (append
   context-rec-spec
   '((rk-context    ()) ; �������ȥ�������ʸ���ؤ��Ѵ��Τ���Υ���ƥ�����
     ;;; TUT-Code���Ͼ���
     ;;; 'tutcode-state-off TUT-Code����
     ;;; 'tutcode-state-on TUT-Code����
     ;;; 'tutcode-state-yomi �򤼽��Ѵ����ɤ�������
     ;;; 'tutcode-state-converting �򤼽��Ѵ��θ���������
     ;;; 'tutcode-state-bushu �������ϡ��Ѵ���
     (state 'tutcode-state-off)
     ;;; �������ʥ⡼�ɤ��ɤ���
     ;;; #t: �������ʥ⡼�ɡ�#f: �Ҥ餬�ʥ⡼�ɡ�
     (katakana-mode #f)
     ;;; �򤼽��Ѵ�/��������Ѵ����оݤ�ʸ����ꥹ��(�ս�)
     ;;; (��: �򤼽��Ѵ����ɤߡ֤�����פ����Ϥ�����硢("��" "��" "��"))
     (head ())
     ;;; �򤼽��Ѵ���������θ�����ֹ�
     (nth 0)
     ;;; �򤼽��Ѵ��θ����
     (nr-candidates 0))))
(define-record 'tutcode-context tutcode-context-rec-spec)
(define tutcode-context-new-internal tutcode-context-new)
(define tutcode-context-katakana-mode? tutcode-context-katakana-mode)
(define (tutcode-context-on? pc)
  (not (eq? (tutcode-context-state pc) 'tutcode-state-off)))

;;; TUT-Code�Υ���ƥ����Ȥ򿷤����������롣
;;; @return ������������ƥ�����
(define (tutcode-context-new id im)
  (if (not tutcode-dic-init)
    (begin
      (set! tutcode-dic-init #t)
      (skk-lib-dic-open tutcode-dic-filename #f "localhost" 0 'unspecified)
      (tutcode-read-personal-dictionary)))
  (let ((tc (tutcode-context-new-internal id im)))
    (tutcode-context-set-widgets! tc tutcode-widgets)
    (tutcode-custom-load-rule! tutcode-rule-filename)
    (if tutcode-use-dvorak?
      (set! tutcode-rule (tutcode-rule-qwerty-to-dvorak tutcode-rule)))
    ;; tutcode-mazegaki/bushu-start-sequence�ϡ�
    ;; tutcode-use-dvorak?������ΤȤ���Dvorak�Υ������󥹤Ȥߤʤ���ȿ�Ǥ��롣
    ;; �Ĥޤꡢrule��qwerty-to-dvorak�Ѵ����ȿ�Ǥ��롣
    (tutcode-custom-set-mazegaki/bushu-start-sequence!)
    (tutcode-rule-commit-sequences! tutcode-rule-userconfig)
    (tutcode-context-set-rk-context! tc (rk-context-new tutcode-rule #t #f))
    tc))

;;; �Ҥ餬��/�������ʥ⡼�ɤ��ڤ��ؤ���Ԥ���
;;; �����ξ��֤��Ҥ餬�ʥ⡼�ɤξ��ϥ������ʥ⡼�ɤ��ڤ��ؤ��롣
;;; �����ξ��֤��������ʥ⡼�ɤξ��ϤҤ餬�ʥ⡼�ɤ��ڤ��ؤ��롣
;;; @param pc ����ƥ����ȥꥹ��
(define (tutcode-context-kana-toggle pc)
  (let ((s (tutcode-context-katakana-mode? pc)))
    (tutcode-context-set-katakana-mode! pc (not s))))

;;; �򤼽��Ѵ��ѸĿͼ�����ɤ߹��ࡣ
(define (tutcode-read-personal-dictionary)
  (if (not (setugid?))
      (skk-lib-read-personal-dictionary tutcode-personal-dic-filename)))

;;; �򤼽��Ѵ��ѸĿͼ����񤭹��ࡣ
(define (tutcode-save-personal-dictionary)
  (if (not (setugid?))
      (skk-lib-save-personal-dictionary tutcode-personal-dic-filename)))

;;; �������ȥ�������ʸ���ؤ��Ѵ��Τ����rk-push-key!��ƤӽФ���
;;; ����ͤ�#f�Ǥʤ���С������(�ꥹ��)��car���֤���
;;; ���������������ʥ⡼�ɤξ�������ͥꥹ�Ȥ�cadr���֤���
;;; (rk-push-key!�ϥ��ȥ�������ξ���#f���֤�)
;;; @param pc ����ƥ����ȥꥹ��
;;; @param key ������ʸ����
(define (tutcode-push-key! pc key)
  (let ((res (rk-push-key! (tutcode-context-rk-context pc) key)))
    (and res
      (if
        (and
          (not (null? (cdr res)))
          (tutcode-context-katakana-mode? pc))
        (cadr res)
        (car res)))))

;;; �Ѵ�����֤򥯥ꥢ���롣
;;; @param pc ����ƥ����ȥꥹ��
(define (tutcode-flush pc)
  (rk-flush (tutcode-context-rk-context pc))
  (tutcode-context-set-state! pc 'tutcode-state-on)
  (tutcode-context-set-head! pc ())
  (tutcode-context-set-nr-candidates! pc 0))

;;; �Ѵ��оݤ�ʸ����ꥹ�Ȥ���ʸ������롣
;;; @param sl ʸ����ꥹ��
(define (tutcode-make-string sl)
  (if (null? sl)
    ""
    (string-append (tutcode-make-string (cdr sl)) (car sl))))

;;; �򤼽��Ѵ����n���ܤθ�����֤���
;;; @param pc ����ƥ����ȥꥹ��
;;; @param n �оݤθ����ֹ�
(define (tutcode-get-nth-candidate pc n)
  (let* ((head (tutcode-context-head pc))
         (cand (skk-lib-get-nth-candidate
                n (tutcode-make-string head) "" "" #f)))
    cand))

;;; �򤼽��Ѵ���θ���������θ�����֤���
;;; @param pc ����ƥ����ȥꥹ��
(define (tutcode-get-current-candidate pc)
  (tutcode-get-nth-candidate pc (tutcode-context-nth pc)))

;;; �򤼽��Ѵ��ǳ��ꤷ��ʸ������֤���
;;; @param pc ����ƥ����ȥꥹ��
(define (tutcode-prepare-commit-string pc)
  (let* ((res (tutcode-get-current-candidate pc)))
    ;; skk-lib-commit-candidate��Ƥ֤ȳؽ���Ԥ���
    (skk-lib-commit-candidate
      (tutcode-make-string (tutcode-context-head pc)) "" ""
        (tutcode-context-nth pc) #f)
    (if (> (tutcode-context-nth pc) 0)
      (tutcode-save-personal-dictionary))
    (tutcode-flush pc)
    res))

;;; �򤼽��Ѵ����ɤ�/��������Ѵ�������(ʸ����ꥹ��head)��ʸ������ɲä��롣
;;; @param pc ����ƥ����ȥꥹ��
;;; @param str �ɲä���ʸ����
(define (tutcode-append-string pc str)
  (if (and str (string? str))
    (tutcode-context-set-head! pc
      (cons str
        (tutcode-context-head pc)))))

;;; �򤼽񤭼���θ�����Ԥ���
;;; @param pc ����ƥ����ȥꥹ��
(define (tutcode-begin-conversion pc)
  (let* ((yomi (tutcode-make-string (tutcode-context-head pc)))
         (res (skk-lib-get-entry yomi "" "" #f)))
    (if res
      (begin
        (tutcode-context-set-nth! pc 0)
        (tutcode-context-set-nr-candidates! pc
         (skk-lib-get-nr-candidates yomi "" "" #f))
        (tutcode-context-set-state! pc 'tutcode-state-converting)
        ;; ���䤬1�Ĥ����ʤ����ϼ�ưŪ�˳��ꤹ��
        (if (= (tutcode-context-nr-candidates pc) 1)
          (im-commit pc (tutcode-prepare-commit-string pc))))
      ;(tutcode-flush pc) ; flush��������Ϥ���ʸ���󤬾ä��Ƥ��ä���
      )))

;;; preeditɽ���򹹿����롣
;;; @param pc ����ƥ����ȥꥹ��
(define (tutcode-update-preedit pc)
  (let ((rkc (tutcode-context-rk-context pc))
        (stat (tutcode-context-state pc)))
    (im-clear-preedit pc)
    (case stat
      ((tutcode-state-yomi)
        (im-pushback-preedit pc preedit-none "��")
        (let ((h (tutcode-make-string (tutcode-context-head pc))))
          (if (string? h)
            (im-pushback-preedit pc preedit-none h))))
      ((tutcode-state-converting)
        (im-pushback-preedit pc preedit-none "��")
        (im-pushback-preedit pc preedit-none
          (tutcode-get-current-candidate pc)))
      ;; ��������Ѵ��Υޡ�������ʸ����Ȥ���head��Ǵ���(�Ƶ�Ū��������Τ���)
      ((tutcode-state-bushu)
        (let ((h (tutcode-make-string (tutcode-context-head pc))))
          (if (string? h)
            (im-pushback-preedit pc preedit-none h)))))
    (im-pushback-preedit pc preedit-cursor "")
    (im-update-preedit pc)))

;;; TUT-Code���Ͼ��֤ΤȤ��Υ������Ϥ�������롣
;;; @param pc ����ƥ����ȥꥹ��
;;; @param key ���Ϥ��줿����
;;; @param key-state ����ȥ��륭�����ξ���
(define (tutcode-proc-state-on pc key key-state)
  (let ((rkc (tutcode-context-rk-context pc)))
    (cond
      ((and
        (tutcode-vi-escape-key? key key-state)
        tutcode-use-with-vi?)
       (rk-flush rkc)
       (tutcode-context-set-state! pc 'tutcode-state-off)
       (im-commit-raw pc)) ; ESC�����򥢥ץ�ˤ��Ϥ�
      ((tutcode-off-key? key key-state)
       (rk-flush rkc)
       (tutcode-context-set-state! pc 'tutcode-state-off))
      ((tutcode-kana-toggle-key? key key-state)
       (rk-flush rkc)
       (tutcode-context-kana-toggle pc))
      ((tutcode-backspace-key? key key-state)
       (if (> (length (rk-context-seq rkc)) 0)
         (rk-flush rkc)
         (im-commit-raw pc)))
      ((or
        (symbol? key)
        (and
          (modifier-key-mask key-state)
          (not (shift-key-mask key-state))))
       (rk-flush rkc)
       (im-commit-raw pc))
      ;; �������ʤ������������󥹤����ƼΤƤ�(tc2�˹�碌��ư��)��
      ;; (rk-push-key!����ȡ�����ޤǤΥ������󥹤ϼΤƤ��뤬��
      ;; �ְ�ä������ϻĤäƤ��ޤ��Τǡ�rk-push-key!�ϻȤ��ʤ�)
      ((not (member (charcode->string key) (rk-expect rkc)))
       (if (> (length (rk-context-seq rkc)) 0)
         (rk-flush rkc) ; �������ʤ��������󥹤ϼΤƤ�
         (im-commit-raw pc))) ; ñ�ȤΥ�������(TUT-Code���ϤǤʤ���)
      (else
       (let ((res (tutcode-push-key! pc (charcode->string key))))
         (if res
           (case res
            ((tutcode-mazegaki-start)
              (tutcode-context-set-state! pc 'tutcode-state-yomi))
            ((tutcode-bushu-start)
              (tutcode-context-set-state! pc 'tutcode-state-bushu)
              (tutcode-append-string pc "��"))
            (else
              (im-commit pc res)))))))))

;;; ľ�����Ͼ��֤ΤȤ��Υ������Ϥ�������롣
;;; @param pc ����ƥ����ȥꥹ��
;;; @param key ���Ϥ��줿����
;;; @param key-state ����ȥ��륭�����ξ���
(define (tutcode-proc-state-off pc key key-state)
  (if
   (tutcode-on-key? key key-state)
   (tutcode-context-set-state! pc 'tutcode-state-on)
   (im-commit-raw pc)))

;;; �򤼽��Ѵ����ɤ����Ͼ��֤ΤȤ��Υ������Ϥ�������롣
;;; @param pc ����ƥ����ȥꥹ��
;;; @param key ���Ϥ��줿����
;;; @param key-state ����ȥ��륭�����ξ���
(define (tutcode-proc-state-yomi pc key key-state)
  (let* ((rkc (tutcode-context-rk-context pc))
         (res #f))
    (cond
      ((tutcode-off-key? key key-state)
       (tutcode-flush pc)
       (tutcode-context-set-state! pc 'tutcode-state-off))
      ((tutcode-kana-toggle-key? key key-state)
       (rk-flush rkc)
       (tutcode-context-kana-toggle pc))
      ((tutcode-backspace-key? key key-state)
       (if (> (length (rk-context-seq rkc)) 0)
        (rk-flush rkc)
        (if (> (length (tutcode-context-head pc)) 0)
          (tutcode-context-set-head! pc (cdr (tutcode-context-head pc))))))
      ((or
        (tutcode-commit-key? key key-state)
        (tutcode-return-key? key key-state))
       (im-commit pc (tutcode-make-string (tutcode-context-head pc)))
       (tutcode-flush pc))
      ((tutcode-cancel-key? key key-state)
       (tutcode-flush pc))
      ((symbol? key)
       (tutcode-flush pc)
       (tutcode-proc-state-on pc key key-state))
      ((and
        (modifier-key-mask key-state)
        (not (shift-key-mask key-state)))
       ;; <Control>n���Ǥ��Ѵ�����?
       (if (tutcode-begin-conv-key? key key-state)
         (if (not (null? (tutcode-context-head pc)))
           (tutcode-begin-conversion pc)
           (tutcode-flush pc))
         (begin
           (tutcode-flush pc)
           (tutcode-proc-state-on pc key key-state))))
      ((not (member (charcode->string key) (rk-expect rkc)))
       (if (> (length (rk-context-seq rkc)) 0)
         (rk-flush rkc)
         ;; space�����Ǥ��Ѵ�����?
         ;; (space�ϥ����������󥹤˴ޤޤ���礬����Τǡ�
         ;;  rk-expect��space��̵�����Ȥ����)
         ;; (trycode��space�ǻϤޤ륭���������󥹤�ȤäƤ����硢
         ;;  space���Ѵ����ϤϤǤ��ʤ��Τǡ�<Control>n����Ȥ�ɬ�פ���)
         (if (tutcode-begin-conv-key? key key-state)
           (if (not (null? (tutcode-context-head pc)))
             (tutcode-begin-conversion pc)
             (tutcode-flush pc))
           (set! res (charcode->string key)))))
      (else
       (set! res (tutcode-push-key! pc (charcode->string key)))))
    (if res
      (tutcode-append-string pc res))))

;;; ��������Ѵ����������Ͼ��֤ΤȤ��Υ������Ϥ�������롣
;;; @param pc ����ƥ����ȥꥹ��
;;; @param key ���Ϥ��줿����
;;; @param key-state ����ȥ��륭�����ξ���
(define (tutcode-proc-state-bushu pc key key-state)
  (let* ((rkc (tutcode-context-rk-context pc))
         (res #f))
    (cond
      ((tutcode-off-key? key key-state)
       (tutcode-flush pc)
       (tutcode-context-set-state! pc 'tutcode-state-off))
      ((tutcode-kana-toggle-key? key key-state)
       (rk-flush rkc)
       (tutcode-context-kana-toggle pc))
      ((tutcode-backspace-key? key key-state)
       (if (> (length (rk-context-seq rkc)) 0)
        (rk-flush rkc)
        ;; head��1ʸ���ܤ���������Ѵ��Υޡ�������backspace�ǤϾä��ʤ��褦��
        ;; ���롣�ְ�äƳ���Ѥ�ʸ����ä��ʤ��褦�ˤ��뤿�ᡣ
        (if (> (length (tutcode-context-head pc)) 1)
          (tutcode-context-set-head! pc (cdr (tutcode-context-head pc))))))
      ((or
        (tutcode-commit-key? key key-state)
        (tutcode-return-key? key key-state))
        ;; �Ƶ�Ū��������Ѵ���(���ꤷ��)�����᤹
        (set! res (car (tutcode-context-head pc)))
        (tutcode-context-set-head! pc (cdr (tutcode-context-head pc)))
        (if (not (string=? res "��"))
          ;; �⤦1ʸ��(���ΤϤ�)��ä��ơ�����ä�
          (tutcode-context-set-head! pc (cdr (tutcode-context-head pc)))
          (set! res #f))
        (if (= (length (tutcode-context-head pc)) 0)
          (begin
            ;; �Ǿ�̤���������Ѵ��ξ�硢�Ѵ���������󤬤����commit
            (if res
              (im-commit pc res))
            (tutcode-flush pc)
            (set! res #f))))
      ((tutcode-cancel-key? key key-state)
        ;; �Ƶ�Ū��������Ѵ���(����󥻥뤷��)�����᤹
        (set! res (car (tutcode-context-head pc)))
        (tutcode-context-set-head! pc (cdr (tutcode-context-head pc)))
        (if (not (string=? res "��"))
          ;; �⤦1ʸ��(���ΤϤ�)��ä��ơ�����ä�
          (tutcode-context-set-head! pc (cdr (tutcode-context-head pc))))
        (set! res #f)
        (if (= (length (tutcode-context-head pc)) 0)
          (tutcode-flush pc)))
      ((or
        (symbol? key)
        (and
          (modifier-key-mask key-state)
          (not (shift-key-mask key-state))))
       (tutcode-flush pc)
       (tutcode-proc-state-on pc key key-state))
      ((not (member (charcode->string key) (rk-expect rkc)))
       (if (> (length (rk-context-seq rkc)) 0)
         (rk-flush rkc)
         (set! res (charcode->string key))))
      (else
       (set! res (tutcode-push-key! pc (charcode->string key)))
       (case res
        ((tutcode-mazegaki-start) ; ��������Ѵ���ϸ򤼽��Ѵ���̵���ˤ���
          (set! res #f))
        ((tutcode-bushu-start) ; �Ƶ�Ū����������Ѵ�
          (tutcode-append-string pc "��")
          (set! res #f)))))
    (if res
      (let loop ((prevchar (car (tutcode-context-head pc)))
                  (char res))
        (if (string=? prevchar "��")
          (tutcode-append-string pc char)
          ;; ľ����ʸ������������ޡ����Ǥʤ���2ʸ���ܤ����Ϥ��줿���Ѵ�����
          (begin
            (set! char
              (tutcode-bushu-convert prevchar char))
            (if (string? char)
              ;; ��������
              (begin
                ;; 1���ܤ�����Ȣ���ä�
                (tutcode-context-set-head! pc (cddr (tutcode-context-head pc)))
                (if (= (length (tutcode-context-head pc)) 0)
                  ;; �Ѵ��Ԥ������󤬻ĤäƤʤ���С����ꤷ�ƽ�λ
                  (begin
                    (im-commit pc char)
                    (tutcode-flush pc))
                  ;; ���󤬤ޤ��ĤäƤ�С��Ƴ�ǧ��
                  ;; (��������ʸ����2ʸ���ܤʤ�С�Ϣ³������������Ѵ�)
                  (loop
                    (car (tutcode-context-head pc))
                    char)))
              ;; �������Ի������Ϥ�ľ�����Ԥ�
              )))))))

;;; �򤼽��Ѵ������������ֹ��1���䤹��
;;; @param pc ����ƥ����ȥꥹ��
(define (tutcode-incr-candidate-index pc)
  (let ((nth (tutcode-context-nth pc)))
    (if (< (+ nth 1) (tutcode-context-nr-candidates pc))
      (tutcode-context-set-nth! pc (+ nth 1)))))

;;; �򤼽��Ѵ������������ֹ��1���餹��
;;; @param pc ����ƥ����ȥꥹ��
(define (tutcode-decr-candidate-index pc)
  (let ((nth (tutcode-context-nth pc)))
    (if (>= (- nth 1) 0)
      (tutcode-context-set-nth! pc (- nth 1)))))

;;; �򤼽��Ѵ��θ���������֤��顢�ɤ����Ͼ��֤��᤹��
;;; @param pc ����ƥ����ȥꥹ��
(define (tutcode-back-to-yomi-state pc)
  (tutcode-context-set-state! pc 'tutcode-state-yomi)
  (tutcode-context-set-nr-candidates! pc 0))

;;; �򤼽��Ѵ��θ���������֤ΤȤ��Υ������Ϥ�������롣
;;; @param pc ����ƥ����ȥꥹ��
;;; @param key ���Ϥ��줿����
;;; @param key-state ����ȥ��륭�����ξ���
(define (tutcode-proc-state-converting pc key key-state)
  (cond
    ((tutcode-next-candidate-key? key key-state)
      (tutcode-incr-candidate-index pc))
    ((tutcode-prev-candidate-key? key key-state)
      (tutcode-decr-candidate-index pc))
    ((tutcode-cancel-key? key key-state)
      (tutcode-back-to-yomi-state pc))
    ((or
      (tutcode-commit-key? key key-state)
      (tutcode-return-key? key key-state))
      (im-commit pc (tutcode-prepare-commit-string pc)))
    (else
      (im-commit pc (tutcode-prepare-commit-string pc))
      (tutcode-proc-state-on pc key key-state))))

;;; ��������Ѵ���Ԥ���
;;; @param c1 1���ܤ�����
;;; @param c2 2���ܤ�����
;;; @return �������ʸ���������Ǥ��ʤ��ä��Ȥ���#f
(define (tutcode-bushu-convert c1 c2)
  ;; tc-2.1+[tcode-ml:1925]������������르�ꥺ������
  (and c1 c2
    (or
      (tutcode-bushu-compose-sub c1 c2)
      (let ((a1 (tutcode-bushu-alternative c1))
            (a2 (tutcode-bushu-alternative c2)))
        (and
          (or
            (not (string=? a1 c1))
            (not (string=? a2 c2)))
          (begin
            (set! c1 a1)
            (set! c2 a2)
            #t)
          (tutcode-bushu-compose-sub c1 c2)))
      (let* ((decomposed1 (tutcode-bushu-decompose c1))
             (decomposed2 (tutcode-bushu-decompose c2))
             (tc11 (and decomposed1 (car decomposed1)))
             (tc12 (and decomposed1 (cadr decomposed1)))
             (tc21 (and decomposed2 (car decomposed2)))
             (tc22 (and decomposed2 (cadr decomposed2)))
             ;; �������ʸ��������������2�Ĥ�����Ȥϰۤʤ�
             ;; ������ʸ���Ǥ��뤳�Ȥ��ǧ���롣
             ;; (string=?����#f�����ä��Ȥ��˥��顼�ˤʤ�Τ�equal?�����)
             (newchar
                (lambda (new)
                  (and
                    (not (equal? new c1))
                    (not (equal? new c2))
                    new))))
        (or
          ;; ������
          (and
            (equal? tc11 c2)
            (newchar tc12))
          (and
            (equal? tc12 c2)
            (newchar tc11))
          (and
            (equal? tc21 c1)
            (newchar tc22))
          (and
            (equal? tc22 c1)
            (newchar tc21))
          ;; ���ʤˤ��­����
          (let ((compose-newchar
                  (lambda (i1 i2)
                    (let ((res (tutcode-bushu-compose-sub i1 i2)))
                      (and res
                        (newchar res))))))
            (or
              (compose-newchar c1 tc22) (compose-newchar tc11 c2)
              (compose-newchar c1 tc21) (compose-newchar tc12 c2)
              (compose-newchar tc11 tc22) (compose-newchar tc11 tc21)
              (compose-newchar tc12 tc22) (compose-newchar tc12 tc21)))
          ;; ���ʤˤ�������
          (and tc11
            (equal? tc11 tc21)
            (newchar tc12))
          (and tc11
            (equal? tc11 tc22)
            (newchar tc12))
          (and tc12
            (equal? tc12 tc21)
            (newchar tc11))
          (and tc12
            (equal? tc12 tc22)
            (newchar tc11)))))))

;;; ��������Ѵ�:c1��c2��������ƤǤ���ʸ����õ�����֤���
;;; ���ꤵ�줿���֤Ǹ��Ĥ���ʤ��ä����ϡ����֤����줫����õ����
;;; @param c1 1���ܤ�����
;;; @param c2 2���ܤ�����
;;; @return �������ʸ���������Ǥ��ʤ��ä��Ȥ���#f
(define (tutcode-bushu-compose-sub c1 c2)
  (and c1 c2
    (or
      (tutcode-bushu-compose c1 c2)
      (tutcode-bushu-compose c2 c1))))

;;; ��������Ѵ�:c1��c2��������ƤǤ���ʸ����õ�����֤���
;;; @param c1 1���ܤ�����
;;; @param c2 2���ܤ�����
;;; @return �������ʸ���������Ǥ��ʤ��ä��Ȥ���#f
(define (tutcode-bushu-compose c1 c2)
  (let ((seq (rk-lib-find-seq (list c1 c2) tutcode-bushudic)))
    (and seq
      (car (cadr seq)))))

;;; ��������Ѵ�:����ʸ����õ�����֤���
;;; @param c �����оݤ�ʸ��
;;; @return ����ʸ��������ʸ�������Ĥ���ʤ��ä��Ȥ��ϸ���ʸ������
(define (tutcode-bushu-alternative c)
  (let ((alt (assoc c tutcode-bushudic-altchar)))
    (or
      (and alt (cadr alt))
      c)))

;;; ��������Ѵ�:ʸ����2�Ĥ������ʬ�򤹤롣
;;; @param c ʬ���оݤ�ʸ��
;;; @return ʬ�򤷤ƤǤ���2�Ĥ�����Υꥹ�ȡ�ʬ��Ǥ��ʤ��ä��Ȥ���#f
(define (tutcode-bushu-decompose c)
  (let ((lst
          (filter
            (lambda (elem)
              (string=? c (car (cadr elem))))
            tutcode-bushudic)))
    (and
      (not (null? lst))
      (car (caar lst)))))

;;; �����������줿�Ȥ��ν����ο���ʬ����Ԥ���
;;; @param pc ����ƥ����ȥꥹ��
;;; @param key ���Ϥ��줿����
;;; @param key-state ����ȥ��륭�����ξ���
(define (tutcode-key-press-handler pc key key-state)
  (if (control-char? key)
      (im-commit-raw pc)
      (begin
        (case (tutcode-context-state pc)
          ((tutcode-state-on)
           (tutcode-proc-state-on pc key key-state))
          ((tutcode-state-yomi)
           (tutcode-proc-state-yomi pc key key-state))
          ((tutcode-state-converting)
           (tutcode-proc-state-converting pc key key-state))
          ((tutcode-state-bushu)
           (tutcode-proc-state-bushu pc key key-state))
          (else
           (tutcode-proc-state-off pc key key-state)))
        (tutcode-update-preedit pc))))

;;; ������Υ���줿�Ȥ��ν�����Ԥ���
;;; @param pc ����ƥ����ȥꥹ��
;;; @param key ���Ϥ��줿����
;;; @param key-state ����ȥ��륭�����ξ���
(define (tutcode-key-release-handler pc key key-state)
  (if (or (control-char? key)
	  (not (tutcode-context-on? pc)))
      ;; don't discard key release event for apps
      (im-commit-raw pc)))

;;; TUT-Code IM�ν������Ԥ���
(define (tutcode-init-handler id im arg)
  (tutcode-context-new id im))

(define (tutcode-release-handler pc)
  (tutcode-save-personal-dictionary))

(define (tutcode-reset-handler tc)
  (tutcode-flush tc))

(define (tutcode-focus-in-handler tc) #f)

(define (tutcode-focus-out-handler tc)
  (let ((rkc (tutcode-context-rk-context tc)))
    (rk-flush rkc)))

(define tutcode-place-handler tutcode-focus-in-handler)
(define tutcode-displace-handler tutcode-focus-out-handler)

(define (tutcode-get-candidate-handler tc idx) #f)
(define (tutcode-set-candidate-index-handler tc idx) #f)

(tutcode-configure-widgets)

;;; TUT-Code IM����Ͽ���롣
(register-im
 'tutcode
 "ja"
 "EUC-JP"
 (N_ "TUT-Code")
 (N_ "A kanji direct input method")
 #f
 tutcode-init-handler
 tutcode-release-handler
 context-mode-handler
 tutcode-key-press-handler
 tutcode-key-release-handler
 tutcode-reset-handler
 tutcode-get-candidate-handler
 tutcode-set-candidate-index-handler
 context-prop-activate-handler
 #f
 tutcode-focus-in-handler
 tutcode-focus-out-handler
 tutcode-place-handler
 tutcode-displace-handler
 )

;;; ������ɽ��Qwerty����Dvorak�Ѥ��Ѵ����롣
;;; @param qwerty Qwerty�Υ�����ɽ
;;; @return Dvorak���Ѵ�����������ɽ
(define (tutcode-rule-qwerty-to-dvorak qwerty)
  (map
    (lambda (elem)
      (cons
        (list
          (map
            (lambda (key)
              (cadr (assoc key tutcode-rule-qwerty-to-dvorak-alist)))
            (caar elem)))
        (cdr elem)))
    qwerty))

;;; Qwerty����Dvorak�ؤ��Ѵ��ơ��֥롣
(define tutcode-rule-qwerty-to-dvorak-alist
  '(
    ;��ľ�ǻȤ������ʳ��ϥ����ȥ�����
    ("1" "1")
    ("2" "2")
    ("3" "3")
    ("4" "4")
    ("5" "5")
    ("6" "6")
    ("7" "7")
    ("8" "8")
    ("9" "9")
    ("0" "0")
    ;("-" "[")
    ;("^" "]") ;106
    ("q" "'")
    ("w" ",")
    ("e" ".")
    ("r" "p")
    ("t" "y")
    ("y" "f")
    ("u" "g")
    ("i" "c")
    ("o" "r")
    ("p" "l")
    ;("@" "/") ;106
    ;("[" "=") ;106
    ("a" "a")
    ("s" "o")
    ("d" "e")
    ("f" "u")
    ("g" "i")
    ("h" "d")
    ("j" "h")
    ("k" "t")
    ("l" "n")
    (";" "s")
    ;(":" "-") ;106
    ("z" ";")
    ("x" "q")
    ("c" "j")
    ("v" "k")
    ("b" "x")
    ("n" "b")
    ("m" "m")
    ("," "w")
    ("." "v")
    ("/" "z")
    ;; shift
    ;("\"" "@") ;106
    ;("&" "^") ;106
    ;("'" "&") ;106
    ;("(" "*") ;106
    ;(")" "(") ;106
    ;("=" "{") ;106
    ;("~" "}") ;106
    ("Q" "\"")
    ("W" "<")
    ("E" ">")
    ("R" "P")
    ("T" "Y")
    ("Y" "F")
    ("U" "G")
    ("I" "C")
    ("O" "R")
    ("P" "L")
    ;("`" "?") ;106
    ;("{" "+") ;106
    ("A" "A")
    ("S" "O")
    ("D" "E")
    ("F" "U")
    ("G" "I")
    ("H" "D")
    ("J" "H")
    ("K" "T")
    ("L" "N")
    ("+" "S") ;106
    ;("*" "_") ;106
    ("Z" ":")
    ("X" "Q")
    ("C" "J")
    ("V" "K")
    ("B" "X")
    ("N" "B")
    ("M" "M")
    ("<" "W")
    (">" "V")
    ("?" "Z")
    (" " " ")
    ))

;;; tutcode-custom�����ꤵ�줿������ɽ�Υե�����̾���饳����ɽ̾���äơ�
;;; ���Ѥ��륳����ɽ�Ȥ������ꤹ�롣
;;; �������륳����ɽ̾�ϡ��ե�����̾����".scm"�򤱤��äơ�
;;; "-rule"���Ĥ��Ƥʤ��ä����ɲä�����Ρ�
;;; ��: "tutcode-rule.scm"��tutcode-rule
;;;     "tcode.scm"��tcode-rule
;;; @param filename tutcode-rule-filename
(define (tutcode-custom-load-rule! filename)
  (and
    (try-load filename)
    (let*
      ((basename (last (string-split filename "/")))
       ;; �ե�����̾����".scm"�򤱤���
       (bnlist (string-to-list basename))
       (codename
        (or
          (and
            (> (length bnlist) 4)
            (string=? (string-list-concat (list-head bnlist 4)) ".scm")
            (string-list-concat (list-tail bnlist 4)))
          basename))
       ;; "-rule"���Ĥ��Ƥʤ��ä����ɲ�
       (rulename
        (or
          (and
            (not (string=? (last (string-split codename "-")) "rule"))
            (string-append codename "-rule"))
          codename)))
      (and rulename
        (symbol-bound? (string->symbol rulename))
        (set! tutcode-rule
          (eval (string->symbol rulename) (interaction-environment)))))))

;;; tutcode-key-custom�����ꤵ�줿�򤼽�/��������Ѵ����ϤΥ����������󥹤�
;;; ������ɽ��ȿ�Ǥ���
(define (tutcode-custom-set-mazegaki/bushu-start-sequence!)
  (let*
    ((make-subrule
      (lambda (keyseq cmd)
        (if
          (and
            keyseq
            (> (string-length keyseq) 0))
          (let ((keys (reverse (string-to-list keyseq))))
            (list (list (list keys) cmd)))
          #f)))
     (subrule ()))
    (set! subrule
      (make-subrule tutcode-mazegaki-start-sequence '(tutcode-mazegaki-start)))
    (set! subrule
      (append subrule
        (make-subrule tutcode-bushu-start-sequence '(tutcode-bushu-start))))
    (tutcode-rule-set-sequences! subrule)))

;;; ������ɽ�ΰ�������������ѹ�/�ɲä��롣~/.uim����λ��Ѥ����ꡣ
;;; �ƤӽФ����ˤ�tutcode-rule-userconfig����Ͽ���Ƥ��������ǡ�
;;; �ºݤ˥�����ɽ��ȿ�Ǥ���Τϡ�tutcode-context-new����
;;;
;;; (tutcode-rule-filename�����꤬��uim-pref��~/.uim�Τɤ���ǹԤ�줿���Ǥ�
;;;  ~/.uim�ǤΥ�����ɽ�ΰ����ѹ���Ʊ�����ҤǤǤ���褦�ˤ��뤿�ᡣ
;;;  ������ɽ���ɸ��hook���Ѱդ���������������)��
;;;
;;; �ƤӽФ���:
;;;   (tutcode-rule-set-sequences!
;;;     '(((("d" "l" "u")) ("��" "��"))
;;;       ((("d" "l" "d" "u")) ("��" "��"))))
;;; @param rules �����������󥹤����Ϥ����ʸ���Υꥹ��
(define (tutcode-rule-set-sequences! rules)
  (set! tutcode-rule-userconfig
    (append rules tutcode-rule-userconfig)))

;;; ������ɽ�ξ���ѹ�/�ɲäΤ����tutcode-rule-userconfig��
;;; ������ɽ��ȿ�Ǥ��롣
(define (tutcode-rule-commit-sequences! rules)
  ;; ������ɽ�θ����ϥ�˥��˹Ԥ���Τǡ��ꥹ�Ȥ���Ƭ�����������Ǿ�񤭤�OK
  (if (not (null? rules))
    (set! tutcode-rule (append rules tutcode-rule))))
