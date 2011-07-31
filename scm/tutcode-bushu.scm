;;;
;;; Copyright (c) 2010-2011 uim Project http://code.google.com/p/uim/
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

;;; tutcode-bushu.scm: ����Ū����������Ѵ�
;;;
;;; tc-2.3.1��tc-bushu.el��ܿ�(sort�Ǥ��Ǥ��䤹���ι�θ��̤�б�)��
;;; (����:����������르�ꥺ���[tcode-ml:1942]������)

(require-extension (srfi 1 8 95))
(require "fileio.scm")
(require-dynlib "look")

;;; #t�ξ�硢������¤����ˤ�äƹ��������ʸ����ͥ���٤��Ѥ��
(define tutcode-bushu-sequence-sensitive? #t)

;;; ͥ���٤�Ʊ������ͥ�褵���ʸ���Υꥹ��
(define tutcode-bushu-prioritized-chars ())

;;; ����������Ϥˤ�����ʤ�ʸ���Υꥹ�� (tc-2.3.1-22.6���)
(define tutcode-bushu-inhibited-output-chars
  '("��" "��" "��" "��" "��" "��" "��" "��" "��" "��" "��" "��" "��"
    "��" "��" "��" "��" "��" "��" "��" "��" "��" "��" "��" "��" "��"
    "��" "��" "��" "��" "��" "��" "��"))

;;; bushu.help�ե�������ɤ����������tutcode-bushudic�����Υꥹ��
(define tutcode-bushu-help ())

;;; ʸ���Υꥹ�ȤȤ����֤���
(define (tutcode-bushu-parse-entry str)
  (reverse! (string-to-list str)))

;;; STR �ǻϤޤ�ԤΤ������ǽ�Τ�Τ򸫤Ĥ��롣
;;; @param str ����ʸ����
;;; @param file �оݥե�����̾
;;; @return ���Ĥ���ʸ����(str�ϴޤޤʤ�)�����Ĥ���ʤ��ä�����#f
(define (tutcode-bushu-search str file)
  (let ((looked (look-lib-look #f #f 1 file str)))
    (and (pair? looked)
         (car looked)))) ; 1�Ԥ֤��ʸ�����������

;;; CHAR������������Υꥹ�Ȥ��֤���
(define (tutcode-bushu-for-char char)
  (let ((looked (tutcode-bushu-search char tutcode-bushu-expand-filename)))
    (if looked
      (tutcode-bushu-parse-entry looked)
      (list char))))

(define (tutcode-bushu-lookup-index2-entry-internal str)
  (let
    ((looked (tutcode-bushu-search (string-append str " ")
              tutcode-bushu-index2-filename)))
    (if looked
      (tutcode-bushu-parse-entry looked)
      ())))

;;; CHAR������Ȥ��ƻ���ʸ���Υꥹ�Ȥ��֤���
;;; �֤��ꥹ�Ȥˤ�CHAR��ޤޤ�롣
(define (tutcode-bushu-lookup-index2-entry-1 char)
  (cons char (tutcode-bushu-lookup-index2-entry-internal char)))

;;; CHAR��CHAR2������Ȥ��ƻ���ʸ���Υꥹ�Ȥ��֤���
(define (tutcode-bushu-lookup-index2-entry-2 char char2)
  (let
    ((str (if (string<? char char2)
              (string-append char char2)
              (string-append char2 char))))
    (tutcode-bushu-lookup-index2-entry-internal str)))

;;; CHAR��N�İʾ�����Ȥ��ƻ���ʸ���Υꥹ�Ȥ��֤���
(define (tutcode-bushu-lookup-index2-entry-many char n)
  (if (= n 1)
    (tutcode-bushu-lookup-index2-entry-1 char)
    (tutcode-bushu-lookup-index2-entry-internal
      (apply string-append (make-list n char)))))

;;; LIST���ELT�ο����֤���
(define (tutcode-bushu-count elt list)
  (count (lambda (elem) (string=? elt elem)) list))

;;; BUSHU �� N �İʾ�ޤ�ʸ���Υꥹ�Ȥ��֤���
(define (tutcode-bushu-included-char-list bushu n)
  (tutcode-bushu-lookup-index2-entry-many bushu n))

;;; LIST1��LIST2�˴ޤޤ�뽸�礫�ɤ�����ɽ���Ҹ졣
;;; Ʊ�����Ǥ�ʣ��������ϡ�LIST2�˴ޤޤ������������ʤ����#f���֤���
(define (tutcode-bushu-included-set? list1 list2)
  (if (null? list1)
    #t
    (let ((x (car list1)))
      (if (> (tutcode-bushu-count x list1) (tutcode-bushu-count x list2))
        #f
        (tutcode-bushu-included-set? (cdr list1) list2)))))

;;; LIST1��LIST2��Ʊ�����礫�ɤ�����ɽ���Ҹ졣
;;; Ʊ�����Ǥ�ʣ��������ϡ�Ʊ���������ޤޤ�Ƥ��ʤ����������ȤϤߤʤ��ʤ���
(define (tutcode-bushu-same-set? list1 list2)
  (and (= (length list1) (length list2))
       (tutcode-bushu-included-set? list1 list2)))

;;; BUSHU-LIST�ǹ����������ν������롣
(define (tutcode-bushu-char-list-for-bushu bushu-list)
  (cond
    ((null? bushu-list) ())
    ((null? (cdr bushu-list)) ; 1ʸ��
      (let*
        ((bushu (car bushu-list))
         (included (tutcode-bushu-included-char-list bushu 1))
         (ret
          (filter-map
            (lambda (elem)
              (let ((l (tutcode-bushu-for-char elem)))
                ;; ����ʸ��
                (and (string=? bushu (car l))
                     (null? (cdr l))
                     elem)))
            included)))
        ret))
    ((null? (cddr bushu-list)) ; 2ʸ��
      (let*
        ((bushu1 (car bushu-list))
         (bushu2 (cadr bushu-list))
         (included (tutcode-bushu-lookup-index2-entry-2 bushu1 bushu2))
         (ret
          (filter-map
            (lambda (elem)
              (let*
                ((l (tutcode-bushu-for-char elem))
                 (len2? (= (length l) 2))
                 (l1 (and len2? (car l)))
                 (l2 (and len2? (cadr l))))
                (and
                  len2?
                  (or (and (string=? bushu1 l1) (string=? bushu2 l2))
                      (and (string=? bushu2 l1) (string=? bushu1 l2)))
                  elem)))
            included)))
        ret))
    (else ; 3ʸ���ʾ�
      (let*
        ((bushu1 (car bushu-list))
         (bushu2 (cadr bushu-list))
         (included (tutcode-bushu-lookup-index2-entry-2 bushu1 bushu2))
         (ret
          (filter-map
            (lambda (elem)
              (and
                (tutcode-bushu-same-set?
                  (tutcode-bushu-for-char elem) bushu-list)
                elem))
            included)))
        ret))))

;;; LIST1��LIST2�Ȥν����Ѥ��֤���
;;; Ʊ�����Ǥ�ʣ��������϶��̤��롣
;;; �֤��ͤˤ��������Ǥ��¤�����LIST1�����˴�Ť���
(define (tutcode-bushu-intersection list1 list2)
  (let loop
    ((l1 list1)
     (l2 list2)
     (intersection ()))
    (if (or (null? l1) (null? l2))
      (reverse! intersection)
      (let*
        ((elt (car l1))
         (l2mem (member elt l2))
         (new-intersection (if l2mem (cons elt intersection) intersection))
         (l2-deleted-first-elt
          (if l2mem
            (append (drop-right l2 (length l2mem)) (cdr l2mem))
            l2)))
        (loop (cdr l1) l2-deleted-first-elt new-intersection)))))

(define (tutcode-bushu-complement-intersection list1 list2)
  (if (null? list2)
    list1
    (let loop
      ((l1 list1)
       (l2 list2)
       (ci ()))
      (if (or (null? l1) (null? l2))
        (append ci l1 l2)
        (let*
          ((e (car l1))
           (c1 (+ 1 (tutcode-bushu-count e (cdr l1))))
           (c2 (tutcode-bushu-count e l2))
           (diff (abs (- c1 c2))))
          (loop
            (if (> c1 1)
              (delete e (cdr l1))
              (cdr l1))
            (if (> c2 0)
              (delete e l2)
              l2)
            (if (> diff 0)
              (append! ci (make-list diff e))
              ci)))))))

(define (tutcode-bushu-subtract-set list1 list2)
  (if (null? list2)
    list1
    (let loop
      ((l1 list1)
       (l2 list2)
       (ci ()))
      (if (or (null? l1) (null? l2))
        (append l1 ci)
        (let*
          ((e (car l1))
           (c1 (+ 1 (tutcode-bushu-count e (cdr l1))))
           (c2 (tutcode-bushu-count e l2))
           (diff (- c1 c2)))
          (loop
            (if (> c1 1)
              (delete e (cdr l1))
              (cdr l1))
            (if (> c2 0)
              (delete e l2)
              l2)
            (if (> diff 0)
              (append! ci (make-list diff e))
              ci)))))))

;;; �������ʬ���礬BUSHU-LIST�Ǥ�����ν������롣
(define (tutcode-bushu-superset bushu-list)
  (cond
    ((null? bushu-list) ())
    ((null? (cdr bushu-list)) ; 1ʸ��
      (tutcode-bushu-included-char-list (car bushu-list) 1))
    ((null? (cddr bushu-list)) ; 2ʸ��
      (tutcode-bushu-lookup-index2-entry-2 (car bushu-list) (cadr bushu-list)))
    (else ; 3ʸ���ʾ�
      (let*
        ((bushu (car bushu-list))
         (n (tutcode-bushu-count bushu bushu-list))
         (bushu-list-wo-bushu
          (if (> n 1)
            (delete bushu (cdr bushu-list))
            (cdr bushu-list)))
         (included
          (if (> n 1)
            (tutcode-bushu-included-char-list bushu n)
            (tutcode-bushu-lookup-index2-entry-2 bushu
              (list-ref bushu-list-wo-bushu 1))))
         (ret
          (filter-map
            (lambda (elem)
              (and
                (tutcode-bushu-included-set? bushu-list-wo-bushu
                  (tutcode-bushu-for-char elem))
                elem))
            included)))
        ret))))

;;; CHAR���ѿ�`tutcode-bushu-prioritized-chars'�β����ܤˤ��뤫���֤���
;;; �ʤ���� #f ���֤���
(define (tutcode-bushu-priority-level char)
  (and (pair? tutcode-bushu-prioritized-chars)
    (let ((char-list (member char tutcode-bushu-prioritized-chars)))
      (and char-list
        (- (length tutcode-bushu-prioritized-chars) (length char-list) -1)))))

;;; REF����Ȥ��ơ�BUSHU1������BUSHU2�����¤��������˶ᤤ���ɤ�����
;;; Ƚ�ǤǤ��ʤ��ä��ꡢ����ɬ�פ��ʤ�����DEFAULT���֤���
(define (tutcode-bushu-higher-priority? bushu1 bushu2 ref default)
  (if tutcode-bushu-sequence-sensitive?
    (let loop
      ((bushu1 bushu1)
       (bushu2 bushu2)
       (ref ref))
      (if (or (null? ref) (null? bushu1) (null? bushu2))
        default
        (let*
          ((b1 (car bushu1))
           (b2 (car bushu2))
           (r (car ref))
           (r=b1? (string=? r b1))
           (r=b2? (string=? r b2)))
          (if (and r=b1? r=b2?)
            (loop (cdr bushu1) (cdr bushu2) (cdr ref))
            (cond
              ((and r=b1? (not r=b2?))
                #t)
              ((and (not r=b1?) r=b2?)
                #f)
              ((and (not r=b1?) (not r=b2?))
                default))))))
    default))

;;; CHAR1��CHAR2���ͥ���٤��⤤��?
;;; BUSHU-LIST�ǻ��ꤵ�줿����ꥹ�Ȥ���Ȥ��롣
;;; OPT-MANY?��#f�ξ�硢Ʊ��ͥ���٤Ǥϡ�BUSHU-LIST�˴ޤޤ�ʤ�
;;; ����ο������ʤ�����ͥ�褵��롣
;;; #t�ξ���¿������ͥ�褵��롣
(define (tutcode-bushu-less? char1 char2 bushu-list . opt-many?)
  (let*
    ((many? (:optional opt-many? #f))
     (bushu1 (tutcode-bushu-for-char char1))
     (bushu2 (tutcode-bushu-for-char char2))
     (i1 (tutcode-bushu-intersection bushu1 bushu-list))
     (i2 (tutcode-bushu-intersection bushu2 bushu-list))
     (il1 (length i1))
     (il2 (length i2))
     (l1 (length bushu1))
     (l2 (length bushu2)))
    (if (= il1 il2)
      (if (= l1 l2)
        (let ((p1 (tutcode-bushu-priority-level char1))
              (p2 (tutcode-bushu-priority-level char2)))
          (cond
            (p1
              (if p2
                (< p1 p2)
                #t))
            (p2
              #f)
            (else
              (let
                ((val (tutcode-bushu-higher-priority? i1 i2
                        (tutcode-bushu-intersection bushu-list
                          (append bushu1 bushu2)) 'default)))
                (if (not (eq? val 'default))
                  val
                  (let*
                    ((s1 (tutcode-reverse-find-seq char1 tutcode-rule))
                     (s2 (tutcode-reverse-find-seq char2 tutcode-rule))
                     (sl1 (if s1 (length s1) 99))
                     (sl2 (if s2 (length s2) 99)))
                    (cond 
                      ((and s1 s2)
                        (if (= sl1 sl2)
                          ;;XXX:�Ǥ��䤹���Ǥ���ӤϾ�ά
                          (string<? char1 char2)
                          (< sl1 sl2)))
                      (s1
                        #t)
                      (s2
                        #f)
                      (else
                        (string<? char1 char2)))))))))
        (if many?
          (> l1 l2)
          (< l1 l2)))
      (> il1 il2))))

(define (tutcode-bushu-less-against-sequence? char1 char2 bushu-list)
  (let ((p1 (tutcode-bushu-priority-level char1))
        (p2 (tutcode-bushu-priority-level char2)))
    (cond
      (p1
        (if p2
          (< p1 p2)
          #t))
      (p2
        #f)
      (else
        (tutcode-bushu-higher-priority?
          (tutcode-bushu-for-char char1)
          (tutcode-bushu-for-char char2)
          bushu-list
          (string<? char1 char2))))))

(define (tutcode-bushu-complete-compose-set char-list bushu-list)
  (sort!
    (tutcode-bushu-subtract-set
      (tutcode-bushu-char-list-for-bushu bushu-list) char-list)
    (lambda (a b)
      (tutcode-bushu-less-against-sequence? a b bushu-list))))

(define (tutcode-bushu-strong-compose-set char-list bushu-list)
  (let*
    ((r (tutcode-bushu-superset bushu-list))
     (r2
      (let loop
        ((lis char-list)
         (r r))
        (if (null? lis)
          r
          (loop (cdr lis) (delete! (car lis) r))))))
    (sort! r2 (lambda (a b) (tutcode-bushu-less? a b bushu-list)))))

(define (tutcode-bushu-include-all-chars-bushu? char char-list)
  (let*
    ((bushu0 (tutcode-bushu-for-char char))
     (new-bushu
      (let loop
        ((char-list char-list)
         (new-bushu bushu0))
        (if (null? char-list)
          new-bushu
          (loop
            (cdr char-list)
            (tutcode-bushu-subtract-set
              new-bushu (tutcode-bushu-for-char (car char-list)))))))
     (bushu (tutcode-bushu-subtract-set bushu0 new-bushu)))
    (let loop
      ((cl char-list))
      (cond
        ((null? cl)
          #t)
        ((null?
          (tutcode-bushu-subtract-set bushu
            (append-map!
              (lambda (char)
                (tutcode-bushu-for-char char))
              (tutcode-bushu-subtract-set char-list (list (car cl))))))
          #f)
        (else
          (loop (cdr cl)))))))

(define (tutcode-bushu-all-compose-set char-list bushu-list)
  (let*
    ((char (car char-list))
     (rest (cdr char-list))
     (all-list
      (delete-duplicates!
        (delete! char
          (append-map!
            (if (pair? rest)
              (lambda (bushu)
                (tutcode-bushu-all-compose-set rest (cons bushu bushu-list)))
              (lambda (bushu)
                (tutcode-bushu-superset (cons bushu bushu-list))))
            (tutcode-bushu-for-char char))))))
    (filter!
      (lambda (char)
        (tutcode-bushu-include-all-chars-bushu? char char-list))
      all-list)))

(define (tutcode-bushu-weak-compose-set char-list bushu-list strong-compose-set)
  (if (null? (cdr char-list)) ; char-list ����ʸ�������λ��ϲ��⤷�ʤ�
    ()
    (sort!
      (tutcode-bushu-subtract-set
        (tutcode-bushu-all-compose-set char-list ())
        strong-compose-set)
      (lambda (a b)
        (tutcode-bushu-less? a b bushu-list)))))

(define (tutcode-bushu-subset bushu-list)
  ;;XXX:Ĺ���ꥹ�Ȥ��Ф���delete-duplicates!���٤��Τǡ�filter��˹Ԥ�
  (delete-duplicates!
    (filter!
      (lambda (char)
        (null? 
          (tutcode-bushu-subtract-set
            (tutcode-bushu-for-char char) bushu-list)))
      (append-map!
        (lambda (elem)
          (tutcode-bushu-included-char-list elem 1))
        (delete-duplicates bushu-list)))))

(define (tutcode-bushu-strong-diff-set char-list . args)
  (let-optionals* args ((bushu-list ()) (complete? #f))
    (let*
      ((char (car char-list))
       (rest (cdr char-list))
       (bushu (tutcode-bushu-for-char char))
       (i
        (if (pair? bushu-list)
          (tutcode-bushu-intersection bushu bushu-list)
          bushu)))
      (if (null? i)
        ()
        (let*
          ((d1 (tutcode-bushu-complement-intersection bushu i))
           (d2 (tutcode-bushu-complement-intersection bushu-list i))
           (d1-or-d2 (if (pair? d1) d1 d2)))
          (if
            (or (and (pair? d1) (pair? d2))
                (and (null? d1) (null? d2)))
            ()
            (if (pair? rest)
              (delete! char
                (tutcode-bushu-strong-diff-set rest d1-or-d2 complete?))
              (sort!
                (delete! char
                  (if complete?
                    (tutcode-bushu-char-list-for-bushu d1-or-d2)
                    (tutcode-bushu-subset d1-or-d2)))
                (lambda (a b)
                  (tutcode-bushu-less? a b bushu-list #t))))))))))

(define (tutcode-bushu-complete-diff-set char-list)
  (tutcode-bushu-strong-diff-set char-list () #t))

(define (tutcode-bushu-all-diff-set char-list bushu-list common-list)
  (let*
    ((char (car char-list))
     (rest (cdr char-list))
     (bushu (tutcode-bushu-for-char char))
     (new-common-list
      (if (pair? common-list)
        (tutcode-bushu-intersection bushu common-list)
        bushu)))
    (if (null? new-common-list)
      ()
      (let*
        ((new-bushu-list
          (if (null? common-list)
            ()
            (append bushu-list
              (tutcode-bushu-complement-intersection
                bushu new-common-list)
              (tutcode-bushu-complement-intersection
                common-list new-common-list)))))
        (if (pair? rest)
          (delete! char
            (tutcode-bushu-all-diff-set rest new-bushu-list new-common-list))
          (delete-duplicates!
            (delete! char
              (append-map!
                (lambda (bushu)
                  (tutcode-bushu-subset
                    (append new-bushu-list (delete bushu new-common-list))))
                new-common-list))))))))

(define (tutcode-bushu-weak-diff-set char-list strong-diff-set)
  (let*
    ((bushu-list (tutcode-bushu-for-char (car char-list)))
     (diff-set
      (tutcode-bushu-subtract-set
        (tutcode-bushu-all-diff-set char-list () ())
        strong-diff-set))
     (less-or-many? (lambda (a b) (tutcode-bushu-less? a b bushu-list #t)))
     (res
       (receive
        (true-diff-set rest-diff-set)
        (partition!
          (lambda (char)
            (null?
              (tutcode-bushu-subtract-set
                (tutcode-bushu-for-char char) bushu-list)))
          diff-set)
        (append! (sort! true-diff-set less-or-many?)
                 (sort! rest-diff-set less-or-many?)))))
    (delete-duplicates! res)))

;;; bushu.help�ե�������ɤ��tutcode-bushudic�����Υꥹ�Ȥ���������
;;; @return tutcode-bushudic�����Υꥹ�ȡ��ɤ߹���ʤ��ä�����#f
(define (tutcode-bushu-help-load)
  (let*
    ((fd (file-open tutcode-bushu-help-filename
          (file-open-flags-number '($O_RDONLY)) 0))
     (parse
      (lambda (line)
        ;; ��: "ѣ����* ����"
        ;; ��(((("��" "��"))("ѣ"))((("��" "��"))("ѣ"))((("��" "��"))("ѣ")))
        (let*
          ((comps (string-split line " "))
           (kanji-lcomps (map tutcode-bushu-parse-entry comps))
           (kanji (and (pair? (car kanji-lcomps)) (caar kanji-lcomps)))
           ;; ��Ƭ�ι�����δ�����������ꥹ�ȡ���:(("��" "��" "*")("��" "��"))
           (lcomps
            (if kanji
              (cons (cdar kanji-lcomps) (cdr kanji-lcomps))
              ())))
          (append-map!
            (lambda (elem)
              (let ((len (length elem)))
                (if (< len 2)
                  ()
                  (let*
                    ((bushu1 (list-ref elem 0))
                     (bushu2 (list-ref elem 1))
                     (rule (list (list (list bushu1 bushu2)) (list kanji)))
                     (rev
                      (and
                        (and (>= len 3) (string=? (list-ref elem 2) "*"))
                        (list (list (list bushu2 bushu1)) (list kanji)))))
                    (if rev
                      (list rule rev)
                      (list rule))))))
            lcomps))))
     (res
      (call-with-open-file-port fd
        (lambda (port)
          (let loop ((line (file-read-line port))
                     (rules ()))
            (if (or (not line)
                    (eof-object? line))
                rules
                (loop (file-read-line port)
                  (append! rules (parse line)))))))))
    res))

;;; bushu.help�ե�����˴�Ť����������Ԥ�
(define (tutcode-bushu-compose-explicitly char-list)
  (if (null? tutcode-bushu-help)
    (set! tutcode-bushu-help (tutcode-bushu-help-load)))
  (if (not tutcode-bushu-help)
    ()
    (cond
      ((null? char-list)
        ())
      ((null? (cdr char-list)) ; 1ʸ��
        (map (lambda (elem) (caadr elem))
          (rk-lib-find-partial-seqs char-list tutcode-bushu-help)))
      ((pair? (cddr char-list)) ; 3ʸ���ʾ�
        ())
      (else ; 2ʸ��
        (let ((seq (rk-lib-find-seq char-list tutcode-bushu-help)))
          (if seq
            (cadr seq)
            ()))))))

;;; ����Ū����������Ѵ��Ѥˡ����ꤵ�줿����Υꥹ�Ȥ������������ǽ��
;;; �����Υꥹ�Ȥ��֤���
;;; @param char-list ���Ϥ��줿����Υꥹ��
;;; @return ������ǽ�ʴ����Υꥹ��
(define (tutcode-bushu-compose-interactively char-list)
  (let*
    ((bushu-list (append-map! tutcode-bushu-for-char char-list))
     (explicit (tutcode-bushu-compose-explicitly char-list))
     (complete-compose-set
      (tutcode-bushu-complete-compose-set char-list bushu-list))
     (complete-diff-set (tutcode-bushu-complete-diff-set char-list))
     (strong-compose-set
      (tutcode-bushu-strong-compose-set char-list bushu-list))
     (strong-diff-set (tutcode-bushu-strong-diff-set char-list))
     (weak-diff-set (tutcode-bushu-weak-diff-set char-list strong-diff-set))
     (weak-compose-set (tutcode-bushu-weak-compose-set char-list bushu-list
                        strong-compose-set)))
  (delete-duplicates!
    (filter!
      (lambda (elem)
        (not (member elem tutcode-bushu-inhibited-output-chars)))
      (append!
        explicit
        complete-compose-set
        complete-diff-set
        strong-compose-set
        strong-diff-set
        weak-diff-set
        weak-compose-set)))))
