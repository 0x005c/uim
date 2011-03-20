;;;
;;; Copyright (c) 2003-2011 uim Project http://code.google.com/p/uim/
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
;;; TUT-Code�ʳ���T-Code��Try-Code�����Ϥ⡢������ɽ������ˤ���ǽ��
;;;
;;; ����������Ѵ���(ala)
;;;   �Ƶ�Ū����������Ѵ����ǽ�Ǥ���
;;;   ��������Υ��르�ꥺ���tc-2.1�Τ�ΤǤ���
;;;
;;; * ����Ū����������Ѵ�
;;;   tc-2.3.1��tc-bushu.el�ΰܿ��Ǥ���(������sort��̤�б��Ǥ�)
;;;   �ʲ��Τ褦������򤹤�Ȼ��Ѳ�ǽ�ˤʤ�ޤ���
;;;   (define tutcode-use-interactive-bushu-conversion? #t)
;;;   (define tutcode-bushu-index2-filename "/usr/local/share/tc/bushu.index2")
;;;   (define tutcode-bushu-expand-filename "/usr/local/share/tc/bushu.expand")
;;;   (define tutcode-interactive-bushu-start-sequence "als")
;;;   bushu.index2��bushu.expand�ե�����ϡ�
;;;   tc-2.3.1�Υ��󥹥ȡ���������������󥹥ȡ��뤵���ե�����Ǥ���
;;;
;;; �ڸ򤼽��Ѵ���(alj)
;;;   �򤼽��Ѵ������tc2��Ʊ������(SKK�����Ʊ�ͤη���)�Ǥ���
;;; 
;;; * �򤼽��Ѵ�����(��:/usr/local/share/tc/mazegaki.dic)�ؤΥ���������
;;;   libuim-skk.so�ε�ǽ��ȤäƤ��ޤ���
;;;   ���Τ��ᡢ�ؽ���ǽ��SKK��Ʊ�ͤ�ư��ˤʤ�ޤ�:
;;;     + ���ꤷ������ϼ�����Ѵ�������Ƭ����ޤ���
;;;     + ���ꤷ������ϸĿͼ���(~/.mazegaki.dic)����¸����ޤ���
;;;   �����γؽ���ǽ�򥪥դˤ���ˤϡ�
;;;   tutcode-enable-mazegaki-learning?�ѿ���#f�����ꤷ�Ƥ���������
;;; ** �򤼽��Ѵ�����ؤ���Ͽ�������SKK��Ʊ�ͤ�ư��ˤʤ�ޤ�:
;;;     + ~/.mazegaki.dic�ؤ���Ͽ�������
;;;     + ��Ͽ: �Ѵ�����κǸ�ޤǹԤä���Ƶ�Ū��Ͽ�⡼�ɤ˰ܹԡ�
;;;             ���뤤�ϡ��ɤߤ����ϸ塢|�򲡤���
;;;     + ���: ���񤫤�κ���ϡ��������������������!�򲡤���
;;; 
;;; * ���Ѥ������Ѵ�
;;;   tutcode-mazegaki-enable-inflection?�ѿ���#t�����ꤹ��ȡ����Ѥ��ʤ���
;;;   �Ȥ��Ƥ��Ѵ����䤬���Ĥ���ʤ��ä����ˡ����Ѥ����Ȥ����Ѵ����ߤޤ���
;;;   (�����������Ѥ��ʤ���θ��䤬1�Ĥξ��μ�ư����Ϥ��ʤ��ʤ�ޤ���
;;;    ����ʸ�������Ϥ򳫻Ϥ���г��ꤵ��ޤ���)
;;;   �ޤ����ǽ餫����Ѥ����Ȥ����Ѵ����������ϡ��ɤߤ�"��"���դ��뤫��
;;;   �ʲ��Υ������Ѵ����Ϥ��Ƥ���������
;;;     tutcode-postfix-mazegaki-inflection-start-sequence (���ַ��ѥ�����ή��)
;;;
;;;   ����ɽ����ϡ�<��>�����ˤ�ꡢ�촴(���Ѹ����ʳ�����ʬ)�ο��̤���ǽ�Ǥ���
;;;   (���������ɤߤ����ϻ���"��"���դ��Ƹ촴�����������������)
;;;
;;; * �ɤߤ򥫥����ʤȤ��Ƴ���
;;;   tutcode-katakana-commit-key�˥������ʳ��ꥭ�������ꤹ���
;;;   ���Ѳ�ǽ�ˤʤ�ޤ���
;;;
;;; * �ѻ��Ѵ�(SKK abbrev)�⡼�ɤ��ɲä��Ƥ��ޤ�(al/)��
;;;   �㤨�С���file�פ����Ϥ��ơ֥ե�����פ��Ѵ����뵡ǽ�Ǥ���
;;;
;;; �ڸ��ַ��Ѵ���
;;;   uim��surrounding text�ط���API��Ȥäơ�
;;;   ������������ʸ����μ����������Ԥ��ޤ���
;;;   ���Τ��ᡢuim��surrounding text API�򥵥ݡ��Ȥ��Ƥ���֥�å�
;;;   (uim-gtk, uim-qt, uim-qt4(lineedit�Τ�))�ǤΤ߸��ַ��Ѵ�����ǽ�Ǥ���
;;;
;;;   �����ʳ��Υ֥�å��Ǥ���ַ��Ѵ���Ȥ�������硢
;;;   tutcode-enable-fallback-surrounding-text?��#t�����ꤹ��ȡ�
;;;   surrounding text API�����ѤǤ��ʤ����ˡ�
;;;   ʸ����μ����������γ����ʸ����Хåե�����Ԥ���
;;;   ʸ����κ����"\b"(tutcode-fallback-backspace-string)�����Ф��ޤ���
;;;     - \b(BS,0x08)ʸ������������˺����Ԥ����ץ�ǤΤ�ư�
;;;     - �����γ����ʸ����Хåե����䴰�ȷ��Ѥǡ�
;;;       Ĺ����tutcode-completion-chars-max���͡�
;;;
;;; * ���ַ���������Ѵ��ϡ����ϥ�����tutcode-postfix-bushu-start-sequence��
;;;   ���ꤹ��Ȼ��Ѳ�ǽ�ˤʤ�ޤ���
;;; * ���ַ��򤼽��Ѵ��ϡ��ʲ��γ��ϥ��������ꤹ��Ȼ��Ѳ�ǽ�ˤʤ�ޤ���
;;;  ���Ѥ��ʤ��� tutcode-postfix-mazegaki-start-sequence
;;;  ���Ѥ����   tutcode-postfix-mazegaki-inflection-start-sequence
;;;  ���Ѥ��ʤ���(�ɤ�1ʸ��) tutcode-postfix-mazegaki-1-start-sequence
;;;   ...
;;;  ���Ѥ��ʤ���(�ɤ�9ʸ��) tutcode-postfix-mazegaki-9-start-sequence
;;;  ���Ѥ����(�ɤ�1ʸ��) tutcode-postfix-mazegaki-inflection-1-start-sequence
;;;   ...
;;;  ���Ѥ����(�ɤ�9ʸ��) tutcode-postfix-mazegaki-inflection-9-start-sequence
;;; * ���ַ��򤼽��Ѵ��ˤ����롢�ɤ�/�촴�ο���
;;;   ����ɽ����ϡ�<��>�����ˤ�ꡢ�ɤ�/�촴�ο��̤���ǽ�Ǥ���
;;;   ���Ѥ����˴ؤ��Ƥϡ��촴��Ĺ����Τ�ͥ�褷���Ѵ����ޤ���
;;;     ��:�֤�������>�֤�����>�֤���
;;;         (tutcode-mazegaki-enable-inflection?��#t�ξ�硢
;;;          ����˽̤��ȳ��Ѥ����Ȥ����Ѵ�)
;;;        >�֤���������>�֤�������>�֤�������>�֤�����>�֤�����>�֤�����
;;;        (�ºݤˤ�tc2��°��mazegaki.dic�ˡ֤��������פ�̵���Τǥ����å�)
;;; ** �ɤߤ�ʸ��������ꤷ���Ѵ����Ϥ������
;;;    ���Ѥ����˴ؤ��Ƥϡ��ɤߤϻ��ꤵ�줿ʸ�����Ǹ��ꤷ�Ƹ촴�Τ߿��̡�
;;;      ��(�֤������פ��Ф���3ʸ������):�֤���������>�֤�������>�֤�����
;;;
;;; �ڥإ�׵�ǽ��
;;; * ���۸���ɽ��(ɽ�����θ��䥦����ɥ���ή��)
;;;   �ư��֤Υ������Ǹ��ˤ�����Ϥ����ʸ����ɽ�����ޤ���
;;;   uim-pref-gtk�Ǥ�ɽ������ɽ�������¾�ˡ�
;;;   <Control>/�ǰ��Ū��ɽ������ɽ�����ڤ��ؤ����ǽ�Ǥ���
;;;   (�Ǥ���������դ��ʸ�������Ϥ���Ȥ�����ɽ����������礬����Τ�)
;;;  - ��*�����դ�ʸ��:�����������Ǹ��ˤ�ꡢ
;;;    ����ʸ����ޤಾ�۸��פ�ɽ������뤳�Ȥ�ɽ���ޤ���(����Ǹ�)
;;;  - ��+�����դ�ʸ��:����������������ʸ��������Ǹ��Ǥ��뤳�Ȥ�ɽ���ޤ���
;;;    (�ϸ쥬���ɤ�����Ǹ�)
;;;  - ��+�׸��դ�ʸ��:�ϸ쥬���ɤκǽ��Ǹ��Ǥ��뤳�Ȥ�ɽ���ޤ���
;;; * ��ư�إ��ɽ����ǽ(ɽ�����θ��䥦����ɥ���ή��)
;;;   �򤼽��Ѵ�����������Ѵ������Ϥ���ʸ�����Ǥ�����ɽ�����ޤ���
;;;   ���������ˡ�⡢��ñ�ʹ����˴ؤ��Ƥ�ɽ����ǽ�Ǥ���
;;;   ��:�򤼽��Ѵ��ǡ�ͫݵ�פ���ꤷ�����
;;;    ������������������������������������������������������������
;;;    ��  ��  ��  ��  ��  ��  ��            ��  ��  ��      ��  ��
;;;    ����������������������  ������������������������������������
;;;    ��  ��  ��  ��  ��b ��  ��            ��  ��  ��f     ��  ��
;;;    ����������������������  ������������������������������������
;;;    ��  ��3 ��  ��  ��  ��  ��            ��  ��  ��1(ͫ) ��  ��
;;;    ����������������������  ������������������������������������
;;;    ��  ��  ��d ��  ��e ��  ��2a(ݵ���Ӵ�)��  ��  ��      ��  ��
;;;    ������������������������������������������������������������
;;; ** ľ���ɽ��������ư�إ�פκ�ɽ��
;;;    tutcode-auto-help-redisplay-sequence�˰ʲ��Τ褦�˥����������󥹤�
;;;    ���ꤹ��Ȼ��Ѳ�ǽ�ˤʤ�ޤ���
;;;      (define tutcode-auto-help-redisplay-sequence "al-")
;;;
;;; ���䴰/ͽ¬���ϡ��ϸ쥬���ɡ�
;;; +���䴰��:�����ʸ������Ф��ơ�³��ʸ����θ����ɽ�����ޤ���
;;; +��ͽ¬���ϡ�:�򤼽��Ѵ����ɤߤ��Ф��ơ��Ѵ���ʸ����θ����ɽ�����ޤ���
;;; +�ֽϸ쥬���ɡ�:�䴰/ͽ¬���ϸ���ʸ������Ȥˡ�
;;;   �������Ϥ�ͽ¬�����ʸ�����Ǹ������ɤ�ɽ�����ޤ�('+'���դ���ɽ��)��
;;; * �䴰/ͽ¬���ϡ��ϸ쥬���ɤȤ���䥦����ɥ���ɽ�����ޤ���
;;; * �䴰/ͽ¬���ϵ�ǽ��Ȥ��ˤϡ�
;;;   uim-pref-gtk���Ρ����ͽ¬���ϡץ��롼�פ����꤬ɬ�פǤ���
;;;     (a)Look-SKK��ͭ���ˤ���mazegaki.dic�����μ���ե��������ꤹ�롣
;;;        (���ͽ¬������)
;;;     (b)Look��ͭ���ˤ���ñ��ե��������ꤹ�롣(�䴰��)
;;;        mazegaki.dic���ɤߤˡ������Ȥ��Ƥ����äƤ��ʤ�ñ����䴰��������硣
;;;        (��:�ֶ��פ����Ϥ��������ǡ��ۡפ��䴰�����ߤ�������
;;;         �ֶ��ۡפ�mazegaki.dic�ˤ��ɤߤȤ��Ƥ����äƤ��ʤ��Τǡ�
;;;         (a)�����Ǥ��䴰����ʤ���((a)���ɤߤ򸡺�����Τ�))
;;;         mazegaki.dic�����Ѵ����ñ���ȴ���Ф��ơ�
;;;         �䴰��ñ��ե��������������ˤϡ��ʲ��Υ��ޥ�ɤǲ�ǽ��
;;;           awk -F'[ /]' '{for(i=3;i<=NF;i++)if(length($i)>2)print $i}' \
;;;           mazegaki.dic | sort -u > mazegaki.words
;;;     (c)Sqlite3��ͭ���ˤ��롣
;;;        �䴰/ͽ¬���Ϥ����򤷤������ؽ���������硢���־�����֡�
;;;   ��ʬõ������Τǡ�(a)(b)�Υե�����ϥ����Ȥ��Ƥ���ɬ�פ�����ޤ���
;;; * �䴰/ͽ¬���Ϥγ��Ϥϰʲ��Τ����줫�Υ����ߥ�:
;;; ** �䴰: tutcode����ξ��֤�tutcode-completion-chars-min��ʸ�������ϻ�
;;; ** �䴰: tutcode����ξ��֤�<Control>.�Ǹ���
;;; ** ͽ¬����: �򤼽��Ѵ����ɤ����Ͼ��֤�
;;;              tutcode-prediction-start-char-count��ʸ�������ϻ�
;;; ** ͽ¬����: �򤼽��Ѵ����ɤ����Ͼ��֤�<Control>.�Ǹ���
;;; * �䴰����ɽ���ˤ����<Control>.���Ǹ�������о�ʸ����1�ĸ��餷�ƺ��䴰��
;;;   Ĺ������ʸ������оݤ��䴰���줿���ˡ��䴰��ľ�����Ǥ���褦�ˡ�
;;; * �嵭���䴰����ʸ����(tutcode-completion-chars-min)��
;;;   ͽ¬����ʸ����(tutcode-prediction-start-char-count)��0�����ꤹ��ȡ�
;;;   <Control>.�Ǹ����ˤΤ��䴰/ͽ¬���ϸ����ɽ�����ޤ���
;;; * �ϸ쥬����(�������Ϥ�ͽ¬�����ʸ�����Ǹ�������)��
;;;   �䴰/ͽ¬���ϸ��䤫���äƤ��ޤ���
;;; * �ϸ쥬���ɤ�ɽ������Ƥ���+�դ�ʸ�����б����륭�������Ϥ�����硢
;;;   2�Ǹ��ܰʹߤⲾ�۸��׾��+�դ���ɽ������Τǡ�
;;;   �����ɤ˽��äƴ��������Ϥ���ǽ�Ǥ���
;;;   (�̾�ϲ��۸�����ɽ���ξ��Ǥ⡢���Ū��<Control>/��ɽ������г�ǧ��ǽ)
;;;
;;; - (����Ū�ˤϡ������Ǹ������Ф餯̵�������䴰/ͽ¬���ϸ����ɽ����������
;;;    �Ǥ�����������uim�ˤϥ����ޤ�̵���Τǡ��Ǹ�ľ���ɽ������ޤ���
;;;    1ʸ�����Ϥ��뤴�Ȥ�ɽ�������ȼ���ʤ��Ȥ�¿���Τǡ�
;;;    �ǥե���ȤǤ�2ʸ�����ϻ���ɽ����������ˤ��Ƥ��ޤ�:
;;;      tutcode-completion-chars-min, tutcode-prediction-start-char-count��
;;;    ���ξ��Ǥ⡢1ʸ�����ϸ��<Control>.����(tutcode-begin-completion-key)
;;;    �ˤ���䴰/ͽ¬���ϸ����ɽ������ǽ�Ǥ���)
;;;
;;; ����������Ѵ�����ͽ¬���ϡ�
;;;   ��������Ѵ�����򸡺����ơ����Ϥ��줿���󤬴ޤޤ����ܤ�ɽ����
;;;
;;; �ڵ������ϥ⡼�ɡ�
;;;   <Control>_�ǵ������ϥ⡼�ɤΥȥ��롣
;;;   ���ѱѿ����ϥ⡼�ɤȤ��Ƥ�Ȥ���褦�ˤ��Ƥ��ޤ���
;;;
;;; ��2���ȥ����������ϥ⡼�ɡ�
;;;   ɴ�기�סؤ��٤�Ʊ�ͤˡ�2�Ǹ��ǳƼ�ε��桦���������Ϥ���⡼�ɡ�
;;;   �����ϴ���Ū��ʸ�������ɽ���¤�Ǥ��ޤ���
;;;   (�̾�ε������ϥ⡼�ɤǤϡ���Ū��ʸ���ޤǤ��ɤ�Ĥ������
;;;   next-page�����򲿲�ⲡ��ɬ�פ����ä����ݤʤΤ�)
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
;;; * T-Code/Try-Code��Ȥ��������
;;;   uim-pref-gtk�������ꤹ�뤫��~/.uim�ǰʲ��Τ褦�����ꤷ�Ƥ���������
;;;    (define tutcode-rule-filename "/usr/local/share/uim/tcode.scm")
;;;    ;(define tutcode-rule-filename "/usr/local/share/uim/trycode.scm")
;;;    (define tutcode-mazegaki-start-sequence "fj")
;;;    (define tutcode-bushu-start-sequence "jf")
;;;    (define tutcode-latin-conv-start-sequence "47")
;;;    (define tutcode-kana-toggle-key? (make-key-predicate '()))
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
;;;  * �������ϥ⡼�ɤ��ɲá�
;;;  * ���۸���ɽ����ǽ���ɲá�
;;;  * ��ư�إ��ɽ����ǽ���ɲá�
;;;  * �䴰/ͽ¬���ϡ��ϸ쥬���ɵ�ǽ���ɲá�

(require-extension (srfi 1 2 8))
(require "generic.scm")
(require "generic-predict.scm")
(require-custom "tutcode-custom.scm")
(require-custom "generic-key-custom.scm")
(require-custom "tutcode-key-custom.scm")
(require-dynlib "skk") ;SKK�����θ򤼽񤭼���θ����Τ���libuim-skk.so�����
(require "tutcode-bushudic.scm") ;��������Ѵ�����
(require "tutcode-kigoudic.scm") ;�������ϥ⡼���Ѥε���ɽ
(require "tutcode-dialog.scm"); �򤼽��Ѵ����񤫤�κ����ǧ��������
(require "japanese.scm") ; for ja-wide or ja-make-kana-str{,-list}
(require "ustr.scm")

;;; user configs

;; widgets and actions

;; widgets
(define tutcode-widgets '(widget_tutcode_input_mode))

;; default activity for each widgets
(define default-widget_tutcode_input_mode 'action_tutcode_direct)

;; actions of widget_tutcode_input_mode
(define tutcode-input-mode-actions
  (if tutcode-use-kigou2-mode?
    '(action_tutcode_direct
      action_tutcode_hiragana
      action_tutcode_katakana
      action_tutcode_kigou
      action_tutcode_kigou2)
    '(action_tutcode_direct
      action_tutcode_hiragana
      action_tutcode_katakana
      action_tutcode_kigou)))

;;; ���Ѥ��륳����ɽ��
;;; tutcode-context-new����(tutcode-custom-load-rule!)������
(define tutcode-rule ())
;;; 2���ȥ����������ϥ⡼���ѥ�����ɽ
(define tutcode-kigou-rule ())
;;; tutcode-rule����������롢�հ�������(���������Ǹ��ꥹ�Ȥ����)��alist��
;;; (��ư�إ���Ѥ���������Ѵ����両�����ι�®���Τ���)
(define tutcode-reverse-rule-alist ())
;;; tutcode-kigou-rule����������롢�հ���������alist��
(define tutcode-reverse-kigou-rule-alist ())
;;; tutcode-bushudic����������롢
;;; �հ�������(�������ʸ����������Ѥ�2ʸ�������)��alist��
;;; (��ư�إ���Ѥ���������Ѵ����両�����ι�®���Τ���)
(define tutcode-reverse-bushudic-alist ())
;;; stroke-help�ǡ����⥭�����Ϥ�̵������ɽ���������Ƥ�alist��
;;; (���tutcode-rule�����Ƥʤ�ƺ���������٤�����
;;; �ǽ�Υڡ����ϸ������ƤʤΤǡ����ٺ���������Τ�Ȥ���)
(define tutcode-stroke-help-top-page-alist ())
;;; stroke-help�ǡ����⥭�����Ϥ�̵������ɽ���������Ƥ�alist��
;;; �������ʥ⡼���ѡ�
;;; (XXX:��������ͭ�ξ��⥭��å����Ȥ��褦�ˤ���?
;;;  �⤷��������С�~/.uim�ǲ��۸���ɽ�����ƤΥ������ޥ������ưפˤʤ�)
(define tutcode-stroke-help-top-page-katakana-alist ())

;;; ������ɽ�����ѹ�/�ɲä��뤿��Υ�����ɽ��
;;; ~/.uim��tutcode-rule-set-sequences!����Ͽ���ơ�
;;; tutcode-context-new����ȿ�Ǥ��롣
(define tutcode-rule-userconfig ())

;;; ���䥦����ɥ��Υץ����̾��
;;; uim-xim����UIM_LIBEXECDIR/uim-candwin-prog����䥦����ɥ��Ȥ��ƻ��ѡ�
;;; gtk-immodule������ɽ�������䥦����ɥ�����Ѥ��뤫Ƚ�Ǥ��뤿�ᡢ
;;; "uim-candwin-tbl"�ǻϤޤäƤ��뤫�ɤ���������å����Ƥ��롣
;;; ɽ�������䥦����ɥ���custom������Ǥ���褦�ˤ��뤿�ᡢ
;;; ���餫����define��
;;; XXX:tutcode�ʳ��ˤ�ƶ�����Τǡ�¾�ξ��������������⡣
(define uim-candwin-prog "")
(if tutcode-use-table-style-candidate-window?
  (set! uim-candwin-prog "uim-candwin-tbl-gtk"))

;;; ɽ�����θ��䥦����ɥ���γƥܥ���ȥ������б�ɽ(13��8��)��
;;; ɽ�������䥦����ɥ������Ȥ��ƻ��Ѥ��롣
(define uim-candwin-prog-layout ())
;;; ɽ�������䥦����ɥ���Υ����쥤������:QWERTY(JIS)����
(define uim-candwin-prog-layout-qwerty-jis
  '("1" "2" "3" "4" "5"  "6" "7" "8" "9" "0"  "-" "^" "\\"
    "q" "w" "e" "r" "t"  "y" "u" "i" "o" "p"  "@" "[" ""
    "a" "s" "d" "f" "g"  "h" "j" "k" "l" ";"  ":" "]" ""
    "z" "x" "c" "v" "b"  "n" "m" "," "." "/"  ""  ""  " "
    "!" "\"" "#" "$" "%" "&" "'" "(" ")" ""   "=" "~" "|"
    "Q" "W" "E" "R" "T"  "Y" "U" "I" "O" "P"  "`" "{" ""
    "A" "S" "D" "F" "G"  "H" "J" "K" "L" "+"  "*" "}" ""
    "Z" "X" "C" "V" "B"  "N" "M" "<" ">" "?"  "_" ""  ""))
;;; ɽ�������䥦����ɥ���Υ����쥤������:QWERTY(US/ASCII)����
(define uim-candwin-prog-layout-qwerty-us
  '("1" "2" "3" "4" "5"  "6" "7" "8" "9" "0"  "-" "=" "\\"
    "q" "w" "e" "r" "t"  "y" "u" "i" "o" "p"  "[" "]" ""
    "a" "s" "d" "f" "g"  "h" "j" "k" "l" ";"  "'" "`" ""
    "z" "x" "c" "v" "b"  "n" "m" "," "." "/"  ""  ""  " "
    "!" "@" "#" "$" "%"  "^" "&" "*" "(" ")"  "_" "+" "|"
    "Q" "W" "E" "R" "T"  "Y" "U" "I" "O" "P"  "{" "}" ""
    "A" "S" "D" "F" "G"  "H" "J" "K" "L" ":"  "\"" "~" ""
    "Z" "X" "C" "V" "B"  "N" "M" "<" ">" "?"  ""  ""  ""))
;;; ɽ�������䥦����ɥ���Υ����쥤������:DVORAK����
;;; (��������֤����줵�줿��Τ�̵���褦�ʤΤǰ���)
(define uim-candwin-prog-layout-dvorak
  '("1" "2" "3" "4" "5"  "6" "7" "8" "9" "0"  "[" "]" "\\"
    "'" "," "." "p" "y"  "f" "g" "c" "r" "l"  "/" "=" ""
    "a" "o" "e" "u" "i"  "d" "h" "t" "n" "s"  "-" "`" ""
    ";" "q" "j" "k" "x"  "b" "m" "w" "v" "z"  ""  ""  " "
    "!" "@" "#" "$" "%"  "^" "&" "*" "(" ")"  "{" "}" "|"
    "\"" "<" ">" "P" "Y" "F" "G" "C" "R" "L"  "?" "+" ""
    "A" "O" "E" "U" "I"  "D" "H" "T" "N" "S"  "_" "~" ""
    ":" "Q" "J" "K" "X"  "B" "M" "W" "V" "Z"  ""  ""  ""))
;;; ɽ�����θ��䥦����ɥ���γƥܥ���ȥ������б�ɽ�����ꡣ
;;; (~/.uim�Ϥ��θ�Ǽ¹Ԥ����Τǡ�
;;;  ~/.uim���ѹ�����ˤ�uim-candwin-prog-layout���񤭤���ɬ�פ���)
(set! uim-candwin-prog-layout
  (case tutcode-candidate-window-table-layout
    ((qwerty-jis) uim-candwin-prog-layout-qwerty-jis)
    ((qwerty-us) uim-candwin-prog-layout-qwerty-us)
    ((dvorak) uim-candwin-prog-layout-dvorak)
    (else ()))) ; default

;;; �򤼽��Ѵ����θ��������ѥ�٥�ʸ���Υꥹ��(ɽ�������䥦����ɥ���)��
;;; QWERTY(JIS)�����ѡ�
(define tutcode-table-heading-label-char-list-qwerty-jis
  '("a" "s" "d" "f" "g" "h" "j" "k" "l" ";"
    "q" "w" "e" "r" "t" "y" "u" "i" "o" "p"
    "z" "x" "c" "v" "b" "n" "m" "," "." "/"
    "1" "2" "3" "4" "5" "6" "7" "8" "9" "0"))
;;; �򤼽��Ѵ����θ��������ѥ�٥�ʸ���Υꥹ��(ɽ�������䥦����ɥ���)��
;;; QWERTY(US)�����ѡ�
(define tutcode-table-heading-label-char-list-qwerty-us
  tutcode-table-heading-label-char-list-qwerty-jis)
;;; �򤼽��Ѵ����θ��������ѥ�٥�ʸ���Υꥹ��(ɽ�������䥦����ɥ���)��
;;; DVORAK�����ѡ�
(define tutcode-table-heading-label-char-list-dvorak
  '("a" "o" "e" "u" "i"  "d" "h" "t" "n" "s"
    "'" "," "." "p" "y"  "f" "g" "c" "r" "l"
    ";" "q" "j" "k" "x"  "b" "m" "w" "v" "z"
    "1" "2" "3" "4" "5"  "6" "7" "8" "9" "0"))
;;; �򤼽��Ѵ����θ��������ѥ�٥�ʸ���Υꥹ��(ɽ�������䥦����ɥ���)��
;;; (�Ǥ��䤹����꤫����˸��������)
(define tutcode-table-heading-label-char-list
  tutcode-table-heading-label-char-list-qwerty-jis)
;;; �򤼽��Ѵ����θ��������ѥ�٥�ʸ���Υꥹ��(uim����������)
(define tutcode-uim-heading-label-char-list
  '("1" "2" "3" "4" "5" "6" "7" "8" "9" "0"
    "a" "b" "c" "d" "e" "f" "g" "h" "i" "j"
    "k" "l" "m" "n" "o" "p" "q" "r" "s" "t"
    "u" "v" "w" "x" "y" "z"
    "A" "B" "C" "D" "E" "F" "G" "H" "I" "J"
    "K" "L" "M" "N" "O" "P" "Q" "R" "S" "T"
    "U" "V" "W" "X" "Y" "Z"))
;;; �򤼽��Ѵ����θ��������ѥ�٥�ʸ���Υꥹ��
(define tutcode-heading-label-char-list ())

;;; �������ϥ⡼�ɻ��θ��������ѥ�٥�ʸ���Υꥹ��(ɽ�������䥦����ɥ���)��
;;; (�����ܡ��ɥ쥤�����Ȥ˽��äơ����夫�鱦���ؽ�˸��������)
(define tutcode-table-heading-label-char-list-for-kigou-mode
  (if (null? uim-candwin-prog-layout)
    (delete "" uim-candwin-prog-layout-qwerty-jis)
    (delete "" uim-candwin-prog-layout)))
;;; �������ϥ⡼�ɻ��θ��������ѥ�٥�ʸ���Υꥹ��(uim����������)
(define tutcode-uim-heading-label-char-list-for-kigou-mode
  '(" "
    "1" "2" "3" "4" "5" "6" "7" "8" "9" "0"
    "a" "b" "c" "d" "e" "f" "g" "h" "i" "j"
    "k" "l" "m" "n" "o" "p" "q" "r" "s" "t"
    "u" "v" "w" "x" "y" "z"
    "-" "^" "\\" "@" "[" ";" ":" "]" "," "." "/"
    "!" "\"" "#" "$" "%" "&" "'" "(" ")"
    "A" "B" "C" "D" "E" "F" "G" "H" "I" "J"
    "K" "L" "M" "N" "O" "P" "Q" "R" "S" "T"
    "U" "V" "W" "X" "Y" "Z"
    "=" "~" "|" "`" "{" "+" "*" "}" "<" ">" "?" "_"))
;;; �������ϥ⡼�ɻ��θ��������ѥ�٥�ʸ���Υꥹ��
;;; (���ѱѿ��⡼�ɤȤ��ƻȤ��ˤϡ�tutcode-kigoudic�ȹ�碌��ɬ�פ���)
(define tutcode-heading-label-char-list-for-kigou-mode ())

;;; �䴰/ͽ¬���ϻ��θ��������ѥ�٥�ʸ���Υꥹ�ȡ�
;;; (�̾��ʸ�����Ϥ˱ƶ����ʤ��褦�ˡ�1�Ǹ��ܤȤ��֤�ʤ�ʸ������ѡ�
;;; ����(�����)��ľ�����ϤǤ���褦�ˡ������Ǥϴޤ�ʤ�)
;;; QWERTY(JIS)�����ѡ�TUT-Code�ѡ�
(define tutcode-heading-label-char-list-for-prediction-qwerty
  '(                     "Y" "U" "I" "O" "P"
                         "H" "J" "K" "L"
    "Z" "X" "C" "V" "B"  "N" "M"))
;;; �䴰/ͽ¬���ϻ��θ��������ѥ�٥�ʸ���Υꥹ�ȡ�
;;; DVORAK�����ѡ�TUT-Code�ѡ�
(define tutcode-heading-label-char-list-for-prediction-dvorak
  '(                     "F" "G" "C" "R" "L"
                         "D" "H" "T" "N" "S"
        "Q" "J" "K" "X"  "B" "M" "W" "V" "Z"))
;;; �䴰/ͽ¬���ϻ��θ��������ѥ�٥�ʸ���Υꥹ�ȡ�
(define tutcode-heading-label-char-list-for-prediction
  tutcode-heading-label-char-list-for-prediction-qwerty)

;;; ��ư�إ�פǤ�ʸ�����Ǥ���ɽ���κݤ˸���ʸ����Ȥ��ƻȤ�ʸ���Υꥹ��
(define tutcode-auto-help-cand-str-list
  ;; ��1,2,3�Ǹ��򼨤�ʸ��(����1��, ����2��)
  '((("1" "2" "3") ("4" "5" "6")) ; 1ʸ������
    (("a" "b" "c") ("d" "e" "f")) ; 2ʸ������
    (("A" "B" "C") ("D" "E" "F"))
    (("��" "��" "��") ("��" "��" "ϻ"))
    (("��" "��" "��") ("��" "��" "��"))
    (("��" "��" "��") ("��" "��" "��"))))

;;; �ϸ쥬�����ѥޡ���
(define tutcode-guide-mark "+")
;;; �ϸ쥬�����ѽ�λ�ޡ���
(define tutcode-guide-end-mark "+")
;;; ���۸��פΥ��ȥ�������ǡ�
;;; ³�����������Υҥ�ȤȤ���ɽ������������դ���ޡ���
(define tutcode-hint-mark "*")
;;; 2���ȥ����������ϥ⡼�ɻ��˲��۸���ɽ����Ԥ����ɤ���������
(define tutcode-use-stroke-help-window-another? #t)

;;; ���ַ��򤼽��Ѵ����ɤ߼������ˡ��ɤߤ˴ޤ�ʤ�ʸ���Υꥹ��
(define tutcode-postfix-mazegaki-terminate-char-list
  '("\n" "\t" " " "��" "��" "��" "��" "��" "��" "��" "��" "��"))

;;; surrounding text API���Ȥ��ʤ����ˡ�ʸ������Τ����commit����ʸ����
(define tutcode-fallback-backspace-string "\b")

;;; implementations

;;; �򤼽��Ѵ�����ν����������äƤ��뤫�ɤ���
(define tutcode-dic #f)

;;; list of context
(define tutcode-context-list '())

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
		 (lambda (c)
		   (let ((tc (tutcode-find-descendant-context c)))
                     (not (tutcode-context-on? tc))))
		 (lambda (c)
		   (let ((tc (tutcode-find-descendant-context c)))
                     (tutcode-prepare-activation tc)
                     (tutcode-flush tc)
                     (tutcode-context-set-state! tc 'tutcode-state-off)
                     (tutcode-update-preedit tc))));flush�ǥ��ꥢ����ɽ����ȿ��

(register-action 'action_tutcode_hiragana
		 (lambda (tc)
		   '(ja_hiragana
		     "��"
		     "�Ҥ餬��"
		     "�Ҥ餬�ʥ⡼��"))
		 (lambda (c)
		   (let ((tc (tutcode-find-descendant-context c)))
                     (and (tutcode-context-on? tc)
                          (not (eq? (tutcode-context-state tc)
                                    'tutcode-state-kigou))
                          (not (tutcode-context-katakana-mode? tc))
                          (not (tutcode-kigou2-mode? tc)))))
		 (lambda (c)
		   (let ((tc (tutcode-find-descendant-context c)))
                     (tutcode-prepare-activation tc)
                     (if
                       (or
                         (not (tutcode-context-on? tc)) ; �Ѵ�����֤��ѹ����ʤ�
                         (eq? (tutcode-context-state tc) 'tutcode-state-kigou))
                       (begin
                         (tutcode-reset-candidate-window tc)
                         (tutcode-context-set-state! tc 'tutcode-state-on)))
                     (if (tutcode-kigou2-mode? tc)
                       (begin
                         (tutcode-reset-candidate-window tc)
                         (tutcode-toggle-kigou2-mode tc)))
                     (tutcode-context-set-katakana-mode! tc #f)
                     (tutcode-update-preedit tc))))

(register-action 'action_tutcode_katakana
		 (lambda (tc)
		   '(ja_katakana
		     "��"
		     "��������"
		     "�������ʥ⡼��"))
		 (lambda (c)
		   (let ((tc (tutcode-find-descendant-context c)))
                     (and (tutcode-context-on? tc)
                          (not (eq? (tutcode-context-state tc)
                                    'tutcode-state-kigou))
                          (tutcode-context-katakana-mode? tc)
                          (not (tutcode-kigou2-mode? tc)))))
		 (lambda (c)
		   (let ((tc (tutcode-find-descendant-context c)))
                     (tutcode-prepare-activation tc)
                     (if
                       (or
                         (not (tutcode-context-on? tc)) ; �Ѵ�����֤��ѹ����ʤ�
                         (eq? (tutcode-context-state tc) 'tutcode-state-kigou))
                       (begin
                         (tutcode-reset-candidate-window tc)
                         (tutcode-context-set-state! tc 'tutcode-state-on)))
                     (if (tutcode-kigou2-mode? tc)
                       (begin
                         (tutcode-reset-candidate-window tc)
                         (tutcode-toggle-kigou2-mode tc)))
                     (tutcode-context-set-katakana-mode! tc #t)
                     (tutcode-update-preedit tc))))

(register-action 'action_tutcode_kigou
                 (lambda (tc)
                   '(ja_fullwidth_alnum
                     "��"
                     "��������"
                     "�������ϥ⡼��"))
                 (lambda (c)
		   (let ((tc (tutcode-find-descendant-context c)))
                     (eq? (tutcode-context-state tc) 'tutcode-state-kigou)))
                 (lambda (c)
		   (let ((tc (tutcode-find-descendant-context c)))
                     (tutcode-prepare-activation tc)
                     (if
                       (not
                         (eq? (tutcode-context-state tc) 'tutcode-state-kigou))
                       (tutcode-flush tc))
                     (tutcode-begin-kigou-mode tc)
                     (tutcode-update-preedit tc))))

(register-action 'action_tutcode_kigou2
                 (lambda (tc)
                   '(ja_fullwidth_alnum
                     "��"
                     "��������2"
                     "�������ϥ⡼��2"))
                 (lambda (c)
                   (let ((tc (tutcode-find-descendant-context c)))
                     (and (tutcode-context-on? tc)
                          (not (eq? (tutcode-context-state tc)
                                    'tutcode-state-kigou))
                          (tutcode-kigou2-mode? tc))))
                 (lambda (c)
		   (let ((tc (tutcode-find-descendant-context c)))
                     (tutcode-prepare-activation tc)
                     (if
                       (or
                         (not (tutcode-context-on? tc)) ; �Ѵ�����֤��ѹ����ʤ�
                         (eq? (tutcode-context-state tc) 'tutcode-state-kigou))
                       (begin
                         (tutcode-reset-candidate-window tc)
                         (tutcode-context-set-state! tc 'tutcode-state-on)))
                     (if (not (tutcode-kigou2-mode? tc))
                       (begin
                         (tutcode-reset-candidate-window tc)
                         (tutcode-toggle-kigou2-mode tc)))
                     (tutcode-update-preedit tc))))

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
   (list
     (list 'rk-context ()) ; �������ȥ�������ʸ���ؤ��Ѵ��Τ���Υ���ƥ�����
     (list 'rk-context-another ()) ;�⤦��Ĥ�rk-context(2stroke�������ϥ⡼��)
     ;;; TUT-Code���Ͼ���
     ;;; 'tutcode-state-off TUT-Code����
     ;;; 'tutcode-state-on TUT-Code����
     ;;; 'tutcode-state-yomi �򤼽��Ѵ����ɤ�������
     ;;; 'tutcode-state-converting �򤼽��Ѵ��θ���������
     ;;; 'tutcode-state-bushu �������ϡ��Ѵ���
     ;;; 'tutcode-state-interactive-bushu ����Ū��������Ѵ���
     ;;; 'tutcode-state-kigou �������ϥ⡼��
     (list 'state 'tutcode-state-off)
     ;;; �������ʥ⡼�ɤ��ɤ���
     ;;; #t: �������ʥ⡼�ɡ�#f: �Ҥ餬�ʥ⡼�ɡ�
     (list 'katakana-mode #f)
     ;;; �򤼽��Ѵ�/��������Ѵ����оݤ�ʸ����ꥹ��(�ս�)
     ;;; (��: �򤼽��Ѵ����ɤߡ֤�����פ����Ϥ�����硢("��" "��" "��"))
     (list 'head ())
     ;;; �򤼽��Ѵ���������θ�����ֹ�
     (list 'nth 0)
     ;;; �򤼽��Ѵ��θ����
     (list 'nr-candidates 0)
     ;;; ���ַ��򤼽��Ѵ����ˡ��Ѵ��˻��Ѥ����ɤߤ�Ĺ����
     ;;; (�������im-delete-text���뤿��˻���)
     ;;; ���ַ������ַ�����Ƚ��ˤ���ѡ�(���ַ��ξ���0)
     (list 'postfix-yomi-len 0)
     ;;; �򤼽��Ѵ����ϻ��˻��ꤵ�줿�ɤߤ�ʸ������
     ;;; ���ַ��ξ������ϺѤߤ��ɤߤ�ʸ������
     (list 'mazegaki-yomi-len-specified 0)
     ;;; �򤼽��Ѵ��Ѥ��ɤ����Ρ����ַ��ξ��ϼ����Ѥߤ��ɤ�
     (list 'mazegaki-yomi-all ())
     ;;; �򤼽��Ѵ����γ��Ѹ���
     ;;; (���Ѥ����ϸ����򡽤��ִ����Ƹ�������Τǡ���������᤹����˻���)
     (list 'mazegaki-suffix ())
     ;;; ���䥦����ɥ��ξ���
     ;;; 'tutcode-candidate-window-off ��ɽ��
     ;;; 'tutcode-candidate-window-converting �򤼽��Ѵ�����ɽ����
     ;;; 'tutcode-candidate-window-kigou ����ɽ����
     ;;; 'tutcode-candidate-window-stroke-help ���۸���ɽ����
     ;;; 'tutcode-candidate-window-auto-help ��ư�إ��ɽ����
     ;;; 'tutcode-candidate-window-predicting �䴰/ͽ¬���ϸ���ɽ����
     ;;; 'tutcode-candidate-window-interactive-bushu ����Ū��������Ѵ�����ɽ��
     (list 'candidate-window 'tutcode-candidate-window-off)
     ;;; ���ȥ���ɽ
     ;;; �������Ϥ��륭����ʸ�����б��Ρ�get-candidate-handler�ѷ����ǤΥꥹ��
     (list 'stroke-help ())
     ;;; ��ư�إ��
     (list 'auto-help ())
     ;;; �򤼽��Ѵ�����ؤκƵ�Ū��Ͽ�Τ���λҥ���ƥ�����
     (list 'child-context ())
     ;;; �ҥ���ƥ����Ȥμ���
     ;;; 'tutcode-child-type-editor ��Ͽ�Ѥ��Ѵ���ʸ�����Խ����ǥ���
     ;;; 'tutcode-child-type-dialog ���񤫤�κ����ǧ��������
     (list 'child-type ())
     ;;; �ƥ���ƥ�����
     (list 'parent-context ())
     ;;; ��Ͽ��ʸ�����Խ����ǥ���
     (list 'editor ())
     ;;; �����ǧ��������
     (list 'dialog ())
     ;;; �ѻ��Ѵ�(SKK abbrev)�⡼�ɤ��ɤ���
     (list 'latin-conv #f)
     ;;; commit�Ѥ�ʸ����ꥹ��(�䴰��)
     (list 'commit-strs ())
     ;;; commit-strs�Τ������䴰�˻��Ѥ��Ƥ���ʸ����
     (list 'commit-strs-used-len 0)
     ;;; �䴰/ͽ¬���Ϥθ��������椫�ɤ���
     ;;; 'tutcode-predicting-off �䴰/ͽ¬���Ϥθ���������Ǥʤ�
     ;;; 'tutcode-predicting-completion �䴰����������
     ;;; 'tutcode-predicting-prediction �򤼽��Ѵ�����ͽ¬���ϸ���������
     ;;; 'tutcode-predicting-bushu ��������Ѵ�����ͽ¬���ϸ���������
     ;;; 'tutcode-predicting-interactive-bushu ����Ū��������Ѵ���
     (list 'predicting 'tutcode-predicting-off)
     ;;; �䴰/ͽ¬�����ѥ���ƥ�����
     (list 'prediction-ctx ())
     ;;; �䴰/ͽ¬���ϸ�����ɤߤΥꥹ��
     (list 'prediction-word ())
     ;;; �䴰/ͽ¬���ϸ���θ���Υꥹ��
     (list 'prediction-candidates ())
     ;;; �䴰/ͽ¬���ϸ����appendix�Υꥹ��
     (list 'prediction-appendix ())
     ;;; �䴰/ͽ¬���ϸ����
     (list 'prediction-nr 0)
     ;;; �䴰/ͽ¬���ϸ���θ������򤵤�Ƥ��륤��ǥå���(�ϸ쥬���ɹ���)
     (list 'prediction-index 0)
     ;;; �䴰/ͽ¬���ϸ����(�ϸ쥬����ʬ�ޤ�)
     (list 'prediction-nr-all 0)
     ;;; �ڡ������Ȥ��䴰/ͽ¬���Ϥθ���ɽ����(�ϸ쥬����ʬ�Ͻ���)
     (list 'prediction-nr-in-page tutcode-nr-candidate-max-for-prediction)
     ;;; �ڡ������Ȥ��䴰/ͽ¬���Ϥθ���ɽ����(�ϸ쥬����ʬ��ޤ�)
     (list 'prediction-page-limit
      (+ tutcode-nr-candidate-max-for-prediction
         tutcode-nr-candidate-max-for-guide))
     ;;; ��������Ѵ���ͽ¬����
     (list 'prediction-bushu ())
     ;;; ��������Ѵ���ͽ¬����θ��ߤ�ɽ���ڡ����κǽ�Υ���ǥå����ֹ�
     (list 'prediction-bushu-page-start 0)
     ;;; �ϸ쥬���ɡ��䴰/ͽ¬���ϻ���ɽ���ѡ�
     ;;; ͽ¬����뼡�����ϴ�������1�Ǹ������ϴ������б��Υꥹ�ȡ�
     ;;; ��: (("," "��") ("u" "��" "��"))
     (list 'guide ())
     ;;; �ϸ쥬���ɺ������ǡ��������۸���(stroke-help)�ؤΥ�����ɽ���ѡ�
     ;;; ʸ���ȥ��ȥ����Υꥹ��(rk-lib-find-partial-seqs�ѷ���)��
     ;;; ��: (((("," "r"))("��")) ((("u" "c"))("��")) ((("u" "v"))("��")))
     (list 'guide-chars ())
     )))
(define-record 'tutcode-context tutcode-context-rec-spec)
(define tutcode-context-new-internal tutcode-context-new)
(define tutcode-context-katakana-mode? tutcode-context-katakana-mode)
(define (tutcode-context-on? pc)
  (not (eq? (tutcode-context-state pc) 'tutcode-state-off)))
(define (tutcode-kigou2-mode? pc)
  (and tutcode-use-kigou2-mode?
       (eq? (rk-context-rule (tutcode-context-rk-context pc))
            tutcode-kigou-rule)))

;;; TUT-Code�Υ���ƥ����Ȥ򿷤����������롣
;;; @return ������������ƥ�����
(define (tutcode-context-new id im)
  (if (not tutcode-dic)
    (if (not (symbol-bound? 'skk-lib-dic-open))
      (begin
        (if (symbol-bound? 'uim-notify-info)
          (uim-notify-info
            (N_ "libuim-skk.so is not available. Mazegaki conversion is disabled")))
        (set! tutcode-use-recursive-learning? #f)
        (set! tutcode-enable-mazegaki-learning? #f))
      (begin
        (set! tutcode-dic (skk-lib-dic-open tutcode-dic-filename #f "localhost" 0 'unspecified))
        (if tutcode-use-recursive-learning?
          (require "tutcode-editor.scm"))
        (tutcode-read-personal-dictionary))))
  (let ((tc (tutcode-context-new-internal id im)))
    (tutcode-context-set-widgets! tc tutcode-widgets)
    (if (null? tutcode-rule)
      (begin
        (tutcode-custom-load-rule! tutcode-rule-filename)
        (if tutcode-use-dvorak?
          (begin
            (set! tutcode-rule (tutcode-rule-qwerty-to-dvorak tutcode-rule))
            (set! tutcode-heading-label-char-list-for-prediction
              tutcode-heading-label-char-list-for-prediction-dvorak)))
        ;; tutcode-mazegaki/bushu-start-sequence�ϡ�
        ;; tutcode-use-dvorak?������ΤȤ���Dvorak�Υ������󥹤Ȥߤʤ���ȿ�ǡ�
        ;; �Ĥޤꡢrule��qwerty-to-dvorak�Ѵ����ȿ�Ǥ��롣
        (tutcode-custom-set-mazegaki/bushu-start-sequence!)
        (tutcode-rule-commit-sequences! tutcode-rule-userconfig)))
    ;; ɽ�������䥦����ɥ�������
    (if (null? tutcode-heading-label-char-list)
      (if tutcode-use-table-style-candidate-window?
        (set! tutcode-heading-label-char-list
          (case tutcode-candidate-window-table-layout
            ((qwerty-jis) tutcode-table-heading-label-char-list-qwerty-jis)
            ((qwerty-us) tutcode-table-heading-label-char-list-qwerty-us)
            ((dvorak) tutcode-table-heading-label-char-list-dvorak)
            (else tutcode-table-heading-label-char-list)))
        (set! tutcode-heading-label-char-list
          tutcode-uim-heading-label-char-list)))
    (if (null? tutcode-heading-label-char-list-for-kigou-mode)
      (if tutcode-use-table-style-candidate-window?
        (begin
          (set! tutcode-heading-label-char-list-for-kigou-mode
            tutcode-table-heading-label-char-list-for-kigou-mode)
          ;; �������ϥ⡼�ɤ����ѱѿ��⡼�ɤȤ��ƻȤ����ᡢ
          ;; tutcode-heading-label-char-list-for-kigou-mode�����Ѥˤ���
          ;; tutcode-kigoudic����Ƭ�������
          (set! tutcode-kigoudic
            (append
              (map (lambda (lst) (list (ja-wide lst)))
                tutcode-heading-label-char-list-for-kigou-mode)
              (list-tail tutcode-kigoudic
                (length tutcode-heading-label-char-list-for-kigou-mode)))))
        (set! tutcode-heading-label-char-list-for-kigou-mode
          tutcode-uim-heading-label-char-list-for-kigou-mode)))
    (tutcode-context-set-rk-context! tc (rk-context-new tutcode-rule #t #f))
    (if tutcode-use-kigou2-mode?
      (begin
        (if (null? tutcode-kigou-rule)
          (begin
            (require "tutcode-kigou-rule.scm") ;2stroke�������ϥ⡼���ѥ�����ɽ
            (tutcode-kigou-rule-translate
              tutcode-candidate-window-table-layout)))
        (tutcode-context-set-rk-context-another!
          tc (rk-context-new tutcode-kigou-rule #t #f))))
    (if tutcode-use-recursive-learning?
      (tutcode-context-set-editor! tc (tutcode-editor-new tc)))
    (tutcode-context-set-dialog! tc (tutcode-dialog-new tc))
    (if tutcode-use-interactive-bushu-conversion?
      (require "tutcode-bushu.scm"))
    (if (or tutcode-use-completion? tutcode-use-prediction?)
      (begin
        (tutcode-context-set-prediction-ctx! tc (predict-make-meta-search))
        (predict-meta-open (tutcode-context-prediction-ctx tc) "tutcode")
        (predict-meta-set-external-charset! (tutcode-context-prediction-ctx tc) "EUC-JP")))
    tc))

;;; �Ҥ餬��/�������ʥ⡼�ɤ��ڤ��ؤ���Ԥ���
;;; �����ξ��֤��Ҥ餬�ʥ⡼�ɤξ��ϥ������ʥ⡼�ɤ��ڤ��ؤ��롣
;;; �����ξ��֤��������ʥ⡼�ɤξ��ϤҤ餬�ʥ⡼�ɤ��ڤ��ؤ��롣
;;; @param pc ����ƥ����ȥꥹ��
(define (tutcode-context-kana-toggle pc)
  (let ((s (tutcode-context-katakana-mode? pc)))
    (tutcode-context-set-katakana-mode! pc (not s))))

;;; ���ä��Υ���ƥ����Ȥ�������롣
(define (tutcode-find-root-context pc)
  (let ((ppc (tutcode-context-parent-context pc)))
    (if (null? ppc)
      pc
      (tutcode-find-root-context ppc))))

;;; ����Υ���ƥ�����(�򤼽��Ѵ��κƵ�Ū��Ͽ�ΰ��ֿ����Ȥ���
;;; =�����Խ���Υ���ƥ�����)��������롣
(define (tutcode-find-descendant-context pc)
  (let ((cpc (tutcode-context-child-context pc)))
    (if (null? cpc)
      pc
      (tutcode-find-descendant-context cpc))))

(define (tutcode-predict pc str)
  (predict-meta-search
   (tutcode-context-prediction-ctx pc)
   str))
;;; �䴰/ͽ¬���ϸ���򸡺�
;;; @param str ����ʸ����
;;; @param completion? �䴰�ξ���#t
;;; @return ��ʣ�����������Ƥ��ɤߤΥꥹ��(�ϸ쥬������)
(define (tutcode-lib-set-prediction-src-string pc str completion?)
  (let* ((ret      (tutcode-predict pc str))
         (word     (predict-meta-word? ret))
         (cands    (predict-meta-candidates? ret))
         (appendix (predict-meta-appendix? ret))
         (word/cand/appendix (map list word cands appendix))
         (uniq-word/cand/appendix 
          ;; ��ʣ��������
          (delete-duplicates word/cand/appendix
            (lambda (x y)
              (let ((xcand (list-ref x 1))
                    (ycand (list-ref y 1)))
                (string=? xcand ycand)))))
         (strlen (string-length str))
         (filtered-word/cand/appendix
          (if completion?
            (filter
              ;; �䴰����str�ǻϤޤäƤ��ʤ���������(str��commit�ѤʤΤ�)
              (lambda (elem)
                (let ((cand (list-ref elem 1)))
                  (and
                    (> (string-length cand) strlen)
                    (string=? str (substring cand 0 strlen)))))
              uniq-word/cand/appendix)
            uniq-word/cand/appendix))
         (filtered-word
          (map (lambda (x) (list-ref x 0)) filtered-word/cand/appendix))
         (filtered-cands
          (map (lambda (x) (list-ref x 1)) filtered-word/cand/appendix))
         (filtered-appendix
          (map (lambda (x) (list-ref x 2)) filtered-word/cand/appendix)))
    (tutcode-context-set-prediction-word! pc filtered-word)
    (tutcode-context-set-prediction-candidates! pc
      (if completion?
        (map
          (lambda (cand)
            ;; �䴰������Ƭ��str����:
            ;; str�ϳ����ʸ����ʤΤǡ�ʸ���ν�ʣ���򤱤뤿�ᡣ
            (if (string=? str (substring cand 0 strlen))
              (substring cand strlen (string-length cand))
              cand))
          filtered-cands)
        filtered-cands))
    (tutcode-context-set-prediction-appendix! pc filtered-appendix)
    (tutcode-context-set-prediction-nr! pc (length filtered-cands))
    word))

;;; ��������Ѵ�����ͽ¬���ϸ��������
;;; @param start-index �����ֹ�
(define (tutcode-lib-set-bushu-prediction pc start-index)
  ;; �����ֹ椫��Ϥޤ�1�ڡ����֤�θ����������Ф��ƻ��ѡ�
  ;; ���ƻ��Ѥ���ȡ��ϸ쥬���ɤΥ�٥�ʸ����Ĺ���ʤäƲ����������ꤹ����
  ;; ������ɥ��˼��ޤ�ʤ��ʤ��礬����Τ�(�����200�ʾ�ξ��ʤ�)��
  ;; (�ϸ쥬���ɤ�ɽ����θ��������������ˡ�⤢�뤬��
  ;; ���ξ�硢�ϸ쥬���ɤο������ڡ������Ȥ��Ѥ�äƤ��ޤ����ᡢ
  ;; �����θ��䥦����ɥ�(�ڡ������Ȥ�ɽ����������Ѥ��ʤ����Ȥ�����)
  ;; �Ǥ�ɽ�������꤬ȯ��)
  (let* ((ret (tutcode-context-prediction-bushu pc))
         (all-len (length ret))
         (start
          (cond
            ((>= start-index all-len)
              (tutcode-context-prediction-bushu-page-start pc))
            ((< start-index 0)
              0)
            (else
              start-index)))
         (end (+ start tutcode-nr-candidate-max-for-prediction))
         (cnt
          (if (< end all-len)
            tutcode-nr-candidate-max-for-prediction
            (- all-len start)))
         (page-word/cand (take (drop ret start) cnt))
         (page-word (map (lambda (elem) (car elem)) page-word/cand))
         (page-cands (map (lambda (elem) (cadr elem)) page-word/cand))
         (len (length page-cands))
         (appendix (make-list len "")))
    (tutcode-context-set-prediction-bushu-page-start! pc start)
    (tutcode-context-set-prediction-word! pc page-word)
    (tutcode-context-set-prediction-candidates! pc page-cands)
    (tutcode-context-set-prediction-appendix! pc appendix)
    (tutcode-context-set-prediction-nr! pc len)))

(define (tutcode-lib-get-nr-predictions pc)
  (tutcode-context-prediction-nr pc))
(define (tutcode-lib-get-nth-word pc nth)
  (let ((word (tutcode-context-prediction-word pc)))
    (list-ref word nth)))
(define (tutcode-lib-get-nth-prediction pc nth)
  (let ((cands (tutcode-context-prediction-candidates pc)))
    (list-ref cands nth)))
(define (tutcode-lib-get-nth-appendix pc nth)
  (let ((appendix (tutcode-context-prediction-appendix pc)))
    (list-ref appendix nth)))
(define (tutcode-lib-commit-nth-prediction pc nth completion?)
  (let ((cand (tutcode-lib-get-nth-prediction pc nth)))
    (predict-meta-commit
      (tutcode-context-prediction-ctx pc)
      (tutcode-lib-get-nth-word pc nth)
      (if completion?
        ;; �䴰���ϡ�cands����ϸ����դ��Ƥ���
        ;; ��Ƭ��commit-strs�������Ƥ���Τǡ�����
        (string-append
          (tutcode-make-string
            (take (tutcode-context-commit-strs pc)
                  (tutcode-context-commit-strs-used-len pc)))
          cand)
        cand)
      (tutcode-lib-get-nth-appendix pc nth))))

;;; �ϸ쥬����ɽ���Ѹ���ꥹ�Ȥ��䴰/ͽ¬���ϸ��䤫���������
;;; @param str �䴰/ͽ¬���ϸ���θ������˻��Ѥ���ʸ����=���Ϻ�ʸ����
;;; @param completion? �䴰����#t
;;; @param all-yomi ͽ¬���ϸ��両����̤˴ޤޤ�����Ƥ��ɤ�
(define (tutcode-guide-set-candidates pc str completion? all-yomi)
  (let* ((cands (tutcode-context-prediction-candidates pc))
         (rule (rk-context-rule (tutcode-context-rk-context pc)))
         (word all-yomi)
         (strlen (string-length str))
         (filtered-cands
          (if (not completion?)
            (filter
              ;; ͽ¬���ϻ���str�ǻϤޤäƤ��ʤ���������äƤ�Τǽ���
              (lambda (cand)
                (and
                  (> (string-length cand) strlen)
                  (string=? str (substring cand 0 strlen))))
              cands)
            cands))
         ;; �ɤ�������ϡ��ɤ�(word)�⸫�Ƽ�������ǽ���Τ�������򥬥���
         ;; ��:"����"�����Ϥ��������ǡ�look������"������"�Ȥ����ɤߤ��Ȥˡ�
         ;;    "��"�򥬥���
         (filtered-words
          (if completion?
            ()
            (filter
              (lambda (cand)
                (let ((candlen (string-length cand)))
                  (and
                    (> candlen strlen)
                    ;; str�θ�ˡ����Ѥ����򼨤�"��"�����Ĥ�ʤ�����Ͻ���
                    (not (string=?  "��" (substring cand strlen candlen))))))
              word)))
         (trim-str
          (lambda (lst)
            (if (not completion?)
              (map
                (lambda (cand)
                  ;; ͽ¬���ϻ������ϺѤ�str��ޤޤ�Ƥ���Τǡ�
                  ;; ��������ʸ���򥬥���ɽ��
                  (substring cand strlen (string-length cand)))
                lst)
              lst)))
         (trim-cands (trim-str filtered-cands))
         (trim-words (trim-str filtered-words))
         (candchars ; ͽ¬�����ϸ��1ʸ���ܤδ����Υꥹ��
          (delete-duplicates
            (map (lambda (cand) (last (string-to-list cand)))
              (append trim-cands trim-words))))
         (cand-stroke
          (map
            (lambda (elem)
              (list (list (tutcode-reverse-find-seq elem rule)) (list elem)))
            candchars))
         (filtered-cand-stroke
          (filter
            (lambda (elem)
              (pair? (caar elem))) ; ������ɽ��̵�������Ͻ���
            cand-stroke))
         (label-cands-alist
          (tutcode-guide-update-alist () filtered-cand-stroke)))
    (tutcode-context-set-guide! pc label-cands-alist)
    (tutcode-context-set-guide-chars! pc filtered-cand-stroke)))

;;; �ϸ쥬����ɽ���Ѹ���ꥹ�Ȥ��������ͽ¬���ϸ��䤫���������
;;; @param str �������ͽ¬���ϸ���θ������˻��Ѥ�������=���ϺѴ���
(define (tutcode-guide-set-candidates-for-bushu pc)
  (let* ((word (tutcode-context-prediction-word pc))
         (rule (rk-context-rule (tutcode-context-rk-context pc)))
         (cand-stroke
          (map
            (lambda (elem)
              (list (list (tutcode-reverse-find-seq elem rule)) (list elem)))
            word))
         (filtered-cand-stroke
          (filter
            (lambda (elem)
              (pair? (caar elem))) ; ������ɽ��̵�������Ͻ���
            cand-stroke))
         (label-cands-alist
          (tutcode-guide-update-alist () filtered-cand-stroke)))
    (tutcode-context-set-guide! pc label-cands-alist)
    (tutcode-context-set-guide-chars! pc filtered-cand-stroke)))

;;; �ϸ쥬���ɤ�ɽ���˻Ȥ�alist�򹹿����롣
;;; alist�ϰʲ��Τ褦�˥�٥�ʸ���ȴ����Υꥹ�ȡ�
;;; ��: (("," "��") ("u" "��" "��"))
;;; @param label-cands-alist ����alist
;;; @param kanji-list �����ȥ��ȥ����Υꥹ��
;;; ��: (((("," "r"))("��")) ((("u" "c"))("��")) ((("u" "v"))("��")))
;;; @return ������νϸ쥬������alist
(define (tutcode-guide-update-alist label-cands-alist kanji-list)
  (if (null? kanji-list)
    label-cands-alist
    (let*
      ((kanji-stroke (car kanji-list))
       (kanji (caadr kanji-stroke))
       (stroke (caar kanji-stroke)))
      (tutcode-guide-update-alist
        (tutcode-auto-help-update-stroke-alist-with-key label-cands-alist
          kanji (car stroke))
        (cdr kanji-list)))))

;;; �򤼽��Ѵ��ѸĿͼ�����ɤ߹��ࡣ
(define (tutcode-read-personal-dictionary)
  (if (not (setugid?))
      (skk-lib-read-personal-dictionary tutcode-dic tutcode-personal-dic-filename)))

;;; �򤼽��Ѵ��ѸĿͼ����񤭹��ࡣ
;;; @param force? tutcode-enable-mazegaki-learning?��#f�Ǥ�񤭹��फ�ɤ���
(define (tutcode-save-personal-dictionary force?)
  (if (and
        (or force? tutcode-enable-mazegaki-learning?)
        (not (setugid?)))
      (skk-lib-save-personal-dictionary tutcode-dic tutcode-personal-dic-filename)))

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
  (let ((cpc (tutcode-context-child-context pc)))
    (rk-flush (tutcode-context-rk-context pc))
    (if tutcode-use-recursive-learning?
      (tutcode-editor-flush (tutcode-context-editor pc)))
    (tutcode-dialog-flush (tutcode-context-dialog pc))
    (if (tutcode-context-on? pc) ; ���ջ��˸ƤФ줿���ϥ���ˤ���������
      (tutcode-context-set-state! pc 'tutcode-state-on)) ; �Ѵ����֤򥯥ꥢ����
    (tutcode-context-set-head! pc ())
    (tutcode-context-set-nr-candidates! pc 0)
    (tutcode-context-set-postfix-yomi-len! pc 0)
    (tutcode-context-set-mazegaki-yomi-len-specified! pc 0)
    (tutcode-context-set-mazegaki-yomi-all! pc ())
    (tutcode-context-set-mazegaki-suffix! pc ())
    (tutcode-reset-candidate-window pc)
    (tutcode-context-set-latin-conv! pc #f)
    (tutcode-context-set-child-context! pc ())
    (tutcode-context-set-child-type! pc ())
    (if (not (null? cpc))
      (tutcode-flush cpc))))

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
                tutcode-dic
                n
                (cons (tutcode-make-string head) "")
                ""
                #f)))
    cand))

;;; �������ϥ⡼�ɻ���n���ܤθ�����֤���
;;; @param n �оݤθ����ֹ�
(define (tutcode-get-nth-candidate-for-kigou-mode pc n)
 (car (nth n tutcode-kigoudic)))

;;; �򤼽��Ѵ���θ���������θ�����֤���
;;; @param pc ����ƥ����ȥꥹ��
(define (tutcode-get-current-candidate pc)
  (tutcode-get-nth-candidate pc (tutcode-context-nth pc)))

;;; �������ϥ⡼�ɻ��θ���������θ�����֤���
(define (tutcode-get-current-candidate-for-kigou-mode pc)
  (tutcode-get-nth-candidate-for-kigou-mode pc (tutcode-context-nth pc)))

;;; �򤼽��Ѵ��ǳ��ꤷ��ʸ������֤���
;;; @param pc ����ƥ����ȥꥹ��
;;; @return ���ꤷ��ʸ����
(define (tutcode-prepare-commit-string pc)
  (let ((res (tutcode-get-current-candidate pc))
        (suffix (tutcode-context-mazegaki-suffix pc))
        (head (tutcode-context-head pc)))
    ;; ���Ĥ�����Υ�٥륭��������θ������ꤹ��Ȥ������Ǥ���褦�ˡ�
    ;; tutcode-enable-mazegaki-learning?��#f�ξ��ϸ�����¤ӽ���Ѥ��ʤ���
    ;; (��:�֤����פ��Ѵ��ˤ����ơ����d�����ǡֲ��ס�e�����ǡֲ��פ����)
    (if tutcode-enable-mazegaki-learning?
      (begin
        ;; skk-lib-commit-candidate��Ƥ֤ȳؽ����Ԥ�졢����礬�ѹ������
        (skk-lib-commit-candidate
          tutcode-dic
          (cons (tutcode-make-string head) "")
          ""
          (tutcode-context-nth pc)
          #f)
        (if (> (tutcode-context-nth pc) 0)
          (tutcode-save-personal-dictionary #f))))
    (tutcode-flush pc)
    (if (null? suffix)
      res
      (string-append res (tutcode-make-string suffix)))))

;;; �������ϥ⡼�ɻ��˳��ꤷ��ʸ������֤���
(define (tutcode-prepare-commit-string-for-kigou-mode pc)
  (tutcode-get-current-candidate-for-kigou-mode pc))

;;; im-commit-raw��ƤӽФ���
;;; ���������ҥ���ƥ����Ȥξ��ϡ�editor��dialog�����ϥ������Ϥ���
(define (tutcode-commit-raw pc key key-state)
  (if (or tutcode-use-completion? tutcode-enable-fallback-surrounding-text?)
    (tutcode-append-commit-string pc (im-get-raw-key-str key key-state)))
  (let ((ppc (tutcode-context-parent-context pc)))
    (if (not (null? ppc))
      (if (eq? (tutcode-context-child-type ppc) 'tutcode-child-type-editor)
        (tutcode-editor-commit-raw (tutcode-context-editor ppc) key key-state)
        (tutcode-dialog-commit-raw (tutcode-context-dialog ppc) key key-state))
      (im-commit-raw pc))))

;;; im-commit��ƤӽФ���
;;; ���������ҥ���ƥ����Ȥξ��ϡ�editor��dialog�����ϥ������Ϥ���
;;; @param str ���ߥåȤ���ʸ����
;;; @param opt-skip-append-commit-strs? commit-strs�ؤ��ɲä�
;;;  �����åפ��뤫�ɤ�����̤�������#f
(define (tutcode-commit pc str . opt-skip-append-commit-strs?)
  (if
    (and (or tutcode-use-completion? tutcode-enable-fallback-surrounding-text?)
         (not (:optional opt-skip-append-commit-strs? #f)))
    (tutcode-append-commit-string pc str))
  (let ((ppc (tutcode-context-parent-context pc)))
    (if (not (null? ppc))
      (if (eq? (tutcode-context-child-type ppc) 'tutcode-child-type-editor)
        (tutcode-editor-commit (tutcode-context-editor ppc) str)
        (tutcode-dialog-commit (tutcode-context-dialog ppc) str))
      (im-commit pc str))))

;;; im-commit��ƤӽФ��ȤȤ�ˡ���ư�إ��ɽ���Υ����å���Ԥ�
(define (tutcode-commit-with-auto-help pc)
  (let* ((head (tutcode-context-head pc))
         (yomi-len (tutcode-context-postfix-yomi-len pc))
         (suffix (tutcode-context-mazegaki-suffix pc))
         (res (tutcode-prepare-commit-string pc))) ; flush�ˤ��head�������ꥢ
    (if (> yomi-len 0)
      (tutcode-postfix-delete-text pc yomi-len))
    (tutcode-commit pc res)
    (tutcode-check-auto-help-window-begin pc
      (drop (string-to-list res) (length suffix))
      (append suffix head))))

;;; �򤼽��Ѵ��θ���������ˡ����ꤵ�줿��٥�ʸ�����б�����������ꤹ��
;;; @param ch ���Ϥ��줿��٥�ʸ��
(define (tutcode-commit-by-label-key pc ch)
  ;; ���߸��䥦����ɥ���ɽ������Ƥ��ʤ���٥�ʸ�������Ϥ�����硢
  ;; ���߰ʹߤθ�����ˤ��������ϥ�٥�ʸ�����б�����������ꤹ�롣
  ;; (�ؽ���ǽ�򥪥դˤ��Ƹ�����¤ӽ�����ˤ��ƻ��Ѥ�����ˡ�
  ;; next-page-key�򲡤�����򸺤餷��
  ;; �ʤ�٤����ʤ���������Ū�θ�������٤�褦�ˤ��뤿��)
  (let* ((nr (tutcode-context-nr-candidates pc))
         (nth (tutcode-context-nth pc))
         (cur-page (cond
                     ((= tutcode-nr-candidate-max 0) 0)
                     (else
                       (quotient nth tutcode-nr-candidate-max))))
         ;; ���߸��䥦����ɥ���ɽ����θ���ꥹ�Ȥ���Ƭ�θ����ֹ�
         (cur-offset (* cur-page tutcode-nr-candidate-max))
         (cur-labels (list-tail
                       tutcode-heading-label-char-list
                       (remainder cur-offset
                                  (length tutcode-heading-label-char-list))))
         (target-labels (member ch cur-labels))
         (offset (if target-labels
                   (- (length cur-labels) (length target-labels))
                   (+ (length cur-labels)
                      (- (length tutcode-heading-label-char-list)
                         (length
                           (member ch tutcode-heading-label-char-list))))))
         (idx (+ cur-offset offset)))
    (if (and (>= idx 0)
             (< idx nr))
      (begin
        (tutcode-context-set-nth! pc idx)
        (tutcode-commit-with-auto-help pc)))))

;;; �������ϥ⡼�ɻ��ˡ����ꤵ�줿��٥�ʸ�����б�����������ꤹ��
(define (tutcode-commit-by-label-key-for-kigou-mode pc ch)
  ;; �򤼽��Ѵ����Ȱۤʤꡢ���ߤ�����θ������ꤹ���礢��
  ;; (���ѱѿ����ϥ⡼�ɤȤ��ƻȤ���褦�ˤ��뤿��)��
  ;; (�������ϥ⡼�ɻ��ϡ����ٳ��ꤷ�������Ϣ³�������ϤǤ���褦�ˡ�
  ;; ������ľ���θ�������򤷤Ƥ��뤬��
  ;; ���ΤȤ��򤼽��Ѵ�����Ʊ�ͤθ��������Ԥ��ȡ�
  ;; ��٥�ʸ���ꥹ�Ȥ�2���ܤ��б�����������ꤷ�Ƥ��ޤ���礬����
  ;; (��:th���Ǥä���硢���ѱѿ����ϤȤ��Ƥϣ���ˤʤä��ߤ������������ˤʤ�)
  ;; ���ᡢ�򤼽��Ѵ��Ȥϰۤʤ������������Ԥ�)
  (let* ((nr (tutcode-context-nr-candidates pc))
         (nth (tutcode-context-nth pc))
         (labellen (length tutcode-heading-label-char-list-for-kigou-mode))
         (cur-base (quotient nth labellen))
         (offset
           (- labellen
              (length
                (member ch tutcode-heading-label-char-list-for-kigou-mode))))
         (idx (+ (* cur-base labellen) offset)))
    (if (and (>= idx 0)
             (< idx nr))
      (begin
        (tutcode-context-set-nth! pc idx)
        (tutcode-commit pc
          (tutcode-prepare-commit-string-for-kigou-mode pc))))))

;;; �䴰/ͽ¬���ϸ���ɽ�����ˡ����ꤵ�줿��٥�ʸ�����б�����������ꤹ��
;;; @param ch ���Ϥ��줿��٥�ʸ��
;;; @param mode tutcode-context-predicting����
(define (tutcode-commit-by-label-key-for-prediction pc ch mode)
  (let*
    ((nth (tutcode-context-prediction-index pc))
     (page-limit (tutcode-context-prediction-page-limit pc))
     (cur-page (quotient nth page-limit))
     (nr-in-page (tutcode-context-prediction-nr-in-page pc))
     ;; ���߸��䥦����ɥ���ɽ����θ���ꥹ�Ȥ���Ƭ�θ����ֹ�
     (cur-offset (* cur-page nr-in-page))
     (labellen (length tutcode-heading-label-char-list-for-prediction))
     (cur-labels
       (list-tail
         tutcode-heading-label-char-list-for-prediction
         (remainder cur-offset labellen)))
     (target-labels (member ch cur-labels))
     (offset (if target-labels
               (- (length cur-labels) (length target-labels))
               (+ (length cur-labels)
                  (- labellen
                     (length
                       (member ch tutcode-heading-label-char-list-for-prediction))))))
     (nr (tutcode-lib-get-nr-predictions pc))
     (idx (+ cur-offset offset))
     (i (remainder idx nr)))
    (if (>= i 0)
      (begin
        (tutcode-context-set-prediction-index! pc i)
        (case mode
          ((tutcode-predicting-bushu)
            (tutcode-do-commit-prediction-for-bushu pc))
          ((tutcode-predicting-interactive-bushu)
            (tutcode-do-commit-prediction-for-interactive-bushu pc))
          ((tutcode-predicting-completion)
            (tutcode-do-commit-prediction pc #t))
          (else
            (tutcode-do-commit-prediction pc #f)))))))

(define (tutcode-get-prediction-string pc)
  (tutcode-lib-get-nth-prediction
   pc
   (tutcode-context-prediction-index pc)))

(define (tutcode-learn-prediction-string pc completion?)
  (tutcode-lib-commit-nth-prediction
   pc
   (tutcode-context-prediction-index pc)
   completion?))

;;; �䴰/ͽ¬���ϸ������ꤹ��
;;; @param completion? �䴰���ɤ���
(define (tutcode-do-commit-prediction pc completion?)
  (let ((str (tutcode-get-prediction-string pc)))
    (tutcode-learn-prediction-string pc completion?)
    (tutcode-reset-candidate-window pc)
    (tutcode-commit pc str)
    (tutcode-flush pc)
    (tutcode-check-auto-help-window-begin pc (string-to-list str) ())))

;;; ��������Ѵ�����ͽ¬���ϸ������ꤹ��
(define (tutcode-do-commit-prediction-for-bushu pc)
  (let ((str (tutcode-get-prediction-string pc)))
    (tutcode-reset-candidate-window pc)
    (tutcode-bushu-commit pc str)))

;;; ����Ū��������Ѵ����θ������ꤹ��
(define (tutcode-do-commit-prediction-for-interactive-bushu pc)
  (let ((str (tutcode-get-prediction-string pc)))
    (tutcode-reset-candidate-window pc)
    (tutcode-commit pc str)
    (tutcode-flush pc)
    (tutcode-check-auto-help-window-begin pc (string-to-list str) ())))

;;; �򤼽��Ѵ����񤫤顢�������򤵤�Ƥ������������롣
(define (tutcode-purge-candidate pc)
  (let ((res (skk-lib-purge-candidate
               tutcode-dic
               (cons (tutcode-make-string (tutcode-context-head pc)) "")
               ""
               (tutcode-context-nth pc)
               #f)))
    (if res
      (tutcode-save-personal-dictionary #t))
    (tutcode-reset-candidate-window pc)
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

;;; commit�Ѥ�ʸ����ꥹ��commit-strs��ʸ������ɲä��롣
;;; @param str �ɲä���ʸ����
(define (tutcode-append-commit-string pc str)
  (if (and str (string? str))
    (let* ((strlist (string-to-list str)) ; str��ʣ��ʸ���ξ�礢��
           (commit-strs (tutcode-context-commit-strs pc))
           (new-strs (append strlist commit-strs)))
      (tutcode-context-set-commit-strs! pc
        (if (> (length new-strs) tutcode-completion-chars-max)
          (take new-strs tutcode-completion-chars-max)
          new-strs)))))

;;; �򤼽��Ѵ��򳫻Ϥ���
;;; @param yomi �Ѵ��оݤ��ɤ�(ʸ����εս�ꥹ��)
;;; @param suffix ���Ѥ������Ѵ���Ԥ����γ��Ѹ���(ʸ����εս�ꥹ��)
;;; @param autocommit? ���䤬1�Ĥξ��˼�ưŪ�˳��ꤹ�뤫�ɤ���
;;; @param recursive-learning? ���䤬̵�����˺Ƶ���Ͽ�⡼�ɤ����뤫�ɤ���
;;; @return #t:���䤬ͭ�ä���硣#f:���䤬̵���ä���硣
(define (tutcode-begin-conversion pc yomi suffix autocommit?
          recursive-learning?)
  (let*
    ((yomi-str (tutcode-make-string yomi))
     (res (and (symbol-bound? 'skk-lib-get-entry)
               (skk-lib-get-entry tutcode-dic yomi-str "" "" #f)
               (skk-lib-get-nr-candidates tutcode-dic yomi-str "" "" #f))))
    (if res
      (begin
        (tutcode-context-set-head! pc yomi)
        (tutcode-context-set-mazegaki-suffix! pc suffix)
        (tutcode-context-set-nth! pc 0)
        (tutcode-context-set-nr-candidates! pc res)
        (tutcode-context-set-state! pc 'tutcode-state-converting)
        (if (and autocommit? (= res 1))
          ;; ���䤬1�Ĥ����ʤ����ϼ�ưŪ�˳��ꤹ�롣
          ;; (������Ͽ��tutcode-register-candidate-key�򲡤�������Ū�˳��Ϥ���)
          (tutcode-commit-with-auto-help pc)
          (begin
            (tutcode-check-candidate-window-begin pc)
            (if (eq? (tutcode-context-candidate-window pc)
                     'tutcode-candidate-window-converting)
              (im-select-candidate pc 0))))
        #t)
      ;; ����̵��
      (begin
        (if recursive-learning?
          (begin
            (tutcode-context-set-head! pc yomi)
            (tutcode-context-set-mazegaki-suffix! pc suffix)
            (tutcode-context-set-state! pc 'tutcode-state-converting)
            (tutcode-setup-child-context pc 'tutcode-child-type-editor)))
          ;(tutcode-flush pc) ; flush��������Ϥ���ʸ���󤬾ä��Ƥ��ä���
        #f))))

;;; ���ַ��򤼽��Ѵ��򳫻Ϥ���(���Ѥ����ˤ��б�)
;;; @param inflection? ���Ѥ����θ�����Ԥ����ɤ���
;;; @return #t:���䤬ͭ�ä���硣#f:���䤬̵���ä���硣
(define (tutcode-begin-conversion-with-inflection pc inflection?)
  (let*
    ((yomi (tutcode-context-head pc))
     (yomi-len (length yomi)))
    (tutcode-context-set-postfix-yomi-len! pc 0)
    (tutcode-context-set-mazegaki-yomi-len-specified! pc yomi-len)
    (tutcode-context-set-mazegaki-yomi-all! pc yomi)
    (if (or (not inflection?)
            (not tutcode-mazegaki-enable-inflection?)
            (tutcode-mazegaki-inflection? yomi)) ; ����Ū��"��"�դ������Ϥ��줿
      (tutcode-begin-conversion pc yomi () #t tutcode-use-recursive-learning?)
      (or
        (tutcode-begin-conversion pc yomi () #f #f)
        ;; ���Ѥ����Ȥ��ƺƸ���
          (or
            (tutcode-mazegaki-inflection-relimit-right pc yomi-len yomi-len #f)
            ;; ���Ѥ��ʤ���Ȥ��ƺƵ��ؽ�
            (and tutcode-use-recursive-learning?
              (begin
                (tutcode-begin-conversion pc yomi () #t
                  tutcode-use-recursive-learning?))))))))

;;; ���Ѥ��������ַ��򤼽��Ѵ��򳫻Ϥ���
;;; @return #t:���䤬ͭ�ä���硣#f:���䤬̵���ä���硣
(define (tutcode-begin-mazegaki-inflection-conversion pc)
  (let*
    ((yomi (tutcode-context-head pc))
     (yomi-len (length yomi)))
    (tutcode-context-set-postfix-yomi-len! pc 0)
    (tutcode-context-set-mazegaki-yomi-len-specified! pc yomi-len)
    (tutcode-context-set-mazegaki-yomi-all! pc yomi)
    (if (tutcode-mazegaki-inflection? yomi) ; ����Ū��"��"�դ������Ϥ��줿
      (tutcode-begin-conversion pc yomi () #t tutcode-use-recursive-learning?)
      (tutcode-mazegaki-inflection-relimit-right pc yomi-len yomi-len #f))))

;;; �ҥ���ƥ����Ȥ�������롣
;;; @param type 'tutcode-child-type-editor��'tutcode-child-type-dialog
(define (tutcode-setup-child-context pc type)
  (let ((cpc (tutcode-context-new (tutcode-context-uc pc)
              (tutcode-context-im pc))))
    (tutcode-context-set-child-context! pc cpc)
    (tutcode-context-set-child-type! pc type)
    (tutcode-context-set-parent-context! cpc pc)
    (if (eq? type 'tutcode-child-type-editor)
      (tutcode-context-set-state! cpc 'tutcode-state-on)
      (tutcode-context-set-state! cpc 'tutcode-state-off))))

;;; �������ϥ⡼�ɤ򳫻Ϥ��롣
;;; @param pc ����ƥ����ȥꥹ��
(define (tutcode-begin-kigou-mode pc)
  (tutcode-context-set-nth! pc 0)
  (tutcode-context-set-nr-candidates! pc (length tutcode-kigoudic))
  (tutcode-context-set-state! pc 'tutcode-state-kigou)
  (tutcode-check-candidate-window-begin pc)
  (if (eq? (tutcode-context-candidate-window pc)
           'tutcode-candidate-window-kigou)
    (im-select-candidate pc 0)))

;;; 2���ȥ����������ϥ⡼��(tutcode-kigou-rule)��tutcode-rule���ڤ��ؤ���Ԥ�
;;; @param pc ����ƥ����ȥꥹ��
(define (tutcode-toggle-kigou2-mode pc)
  (if tutcode-use-kigou2-mode?
    (let ((tmp-rkc (tutcode-context-rk-context pc))
          (tmp-stroke-help? tutcode-use-stroke-help-window?))
      (tutcode-context-set-rk-context! pc
        (tutcode-context-rk-context-another pc))
      (tutcode-context-set-rk-context-another! pc tmp-rkc)
      (set! tutcode-use-stroke-help-window?
        tutcode-use-stroke-help-window-another?)
      (set! tutcode-use-stroke-help-window-another? tmp-stroke-help?)
      (tutcode-context-set-guide-chars! pc ()))))

;;; ���䥦����ɥ���ɽ���򳫻Ϥ���
(define (tutcode-check-candidate-window-begin pc)
  (if (and (eq? (tutcode-context-candidate-window pc)
                'tutcode-candidate-window-off)
           tutcode-use-candidate-window?
           (>= (tutcode-context-nth pc) (- tutcode-candidate-op-count 1)))
    (begin
      (tutcode-context-set-candidate-window! pc
        (if (eq? (tutcode-context-state pc) 'tutcode-state-kigou)
          'tutcode-candidate-window-kigou
          'tutcode-candidate-window-converting))
      (im-activate-candidate-selector
        pc
        (tutcode-context-nr-candidates pc)
        (if (eq? (tutcode-context-state pc) 'tutcode-state-kigou)
          tutcode-nr-candidate-max-for-kigou-mode
          tutcode-nr-candidate-max)))))

;;; ���۸��פ�ɽ���򳫻Ϥ���
(define (tutcode-check-stroke-help-window-begin pc)
  (if (eq? (tutcode-context-candidate-window pc) 'tutcode-candidate-window-off)
    (let* ((rkc (tutcode-context-rk-context pc))
           (seq (rk-context-seq rkc))
           (seqlen (length seq))
           (rule (rk-context-rule rkc))
           (ret (rk-lib-find-partial-seqs (reverse seq) rule))
           (katakana? (tutcode-context-katakana-mode? pc))
           ;; ��:(("k" "��") ("i" "��") ("g" "*£"))
           (label-cand-alist
            (if (null? seq) ; tutcode-rule�����ʤ�ƺ������٤��Τǥ���å���
              (cond
                ((tutcode-kigou2-mode? pc)
                  tutcode-kigou-rule-stroke-help-top-page-alist)
                (katakana?
                  (if (null? tutcode-stroke-help-top-page-katakana-alist)
                    (set! tutcode-stroke-help-top-page-katakana-alist
                      (tutcode-stroke-help-update-alist
                        () seqlen katakana? ret)))
                  tutcode-stroke-help-top-page-katakana-alist)
                (else
                  (if (null? tutcode-stroke-help-top-page-alist)
                    (set! tutcode-stroke-help-top-page-alist
                      (tutcode-stroke-help-update-alist
                        () seqlen katakana? ret)))
                  tutcode-stroke-help-top-page-alist))
              (tutcode-stroke-help-update-alist () seqlen katakana? ret))))
      ;; �ϸ쥬���ɤ伫ư�إ�פ����³���ǡ����ϸ���ʸ���˥ޡ������դ���
      (if (and (pair? seq)
               (pair? (tutcode-context-guide-chars pc)))
        (let*
          ((guide-rule (tutcode-context-guide-chars pc))
           (ret (rk-lib-find-partial-seqs (reverse seq) guide-rule))
           (guide-alist (tutcode-stroke-help-guide-update-alist () seqlen ret))
           ;; ��:(("," "��") ("u" "+�Ӳ�"))
           (guide-candcombined
            (map
              (lambda (elem)
                (list (car elem) (tutcode-make-string (cdr elem))))
              guide-alist)))
          ;; ɽ���������ʸ����򡢽ϸ쥬����(+)�դ�ʸ������֤�������
          (for-each
            (lambda (elem)
              (let*
                ((label (car elem))
                 (label-cand (assoc label label-cand-alist)))
                (if label-cand
                  (set-cdr! label-cand (cdr elem)))))
            guide-candcombined)))
      (if (not (null? label-cand-alist))
        (let
          ((stroke-help
            (map
              (lambda (elem)
                (list (cadr elem) (car elem) ""))
              (reverse label-cand-alist))))
          (tutcode-context-set-stroke-help! pc stroke-help)
          (tutcode-context-set-candidate-window! pc
            'tutcode-candidate-window-stroke-help)
          (im-activate-candidate-selector pc
            (length stroke-help) tutcode-nr-candidate-max-for-kigou-mode))))))

;;; ���۸��פ�ɽ����Ԥ����ɤ������������Ū���ڤ��ؤ���(�ȥ���)��
;;; (���ɽ��������ܤ����ʤΤǡ��Ǥ������¤ä��Ȥ�����ɽ����������
;;;  XXX: tc2���ȡ�������ְ���˼����Ǹ���̵���ä��鲾�۸��פ�
;;;  ɽ������褦�ˤʤäƤ��뤬��������uim��Ʊ�����Ȥ򤹤�Τ��񤷤�����)
(define (tutcode-toggle-stroke-help pc)
  (if tutcode-use-stroke-help-window?
    (begin
      (set! tutcode-use-stroke-help-window? #f)
      (tutcode-reset-candidate-window pc))
    (set! tutcode-use-stroke-help-window? #t)))

;;; ���۸���ɽ���ѥǡ�������
;;; @param label-cand-alist ɽ���ѥǡ�����
;;;  ��:(("k" "��") ("i" "��") ("g" "*£"))
;;; @param seqlen �����ܤΥ��ȥ������оݤȤ��뤫��
;;; @param katakana? �������ʥ⡼�ɤ��ɤ�����
;;; @param rule-list rk-rule��
;;; @return ��������label-cand-alist
(define (tutcode-stroke-help-update-alist
         label-cand-alist seqlen katakana? rule-list)
  (if (null? rule-list)
    label-cand-alist
    (tutcode-stroke-help-update-alist
      (tutcode-stroke-help-update-alist-with-rule
        label-cand-alist seqlen katakana? (car rule-list))
      seqlen katakana? (cdr rule-list))))

;;; ���۸���ɽ���ѥǡ�������:��Ĥ�rule��ȿ�ǡ�
;;; @param label-cand-alist ɽ���ѥǡ�����
;;; @param seqlen �����ܤΥ��ȥ������оݤȤ��뤫��
;;; @param katakana? �������ʥ⡼�ɤ��ɤ�����
;;; @param rule rk-rule��ΰ�Ĥ�rule��
;;; @return ��������label-cand-alist
(define (tutcode-stroke-help-update-alist-with-rule
         label-cand-alist seqlen katakana? rule)
  (let* ((label (list-ref (caar rule) seqlen))
         (label-cand (assoc label label-cand-alist)))
    ;; ���˳����Ƥ��Ƥ��鲿�⤷�ʤ���rule��Ǻǽ�˽и�����ʸ�������
    (if label-cand
      label-cand-alist
      (let*
        ((candlist (cadr rule))
         ;; ������������?
         (has-next? (> (length (caar rule)) (+ seqlen 1)))
         (cand
          (or
            (and (not (null? (cdr candlist)))
                 katakana?
                 (cadr candlist))
            (car candlist)))
         (candstr
          (case cand
            ((tutcode-mazegaki-start) "��")
            ((tutcode-latin-conv-start) "/")
            ((tutcode-bushu-start) "��")
            ((tutcode-interactive-bushu-start) "��")
            ((tutcode-postfix-bushu-start) "��")
            ((tutcode-postfix-mazegaki-start) "��")
            ((tutcode-postfix-mazegaki-1-start) "��1")
            ((tutcode-postfix-mazegaki-2-start) "��2")
            ((tutcode-postfix-mazegaki-3-start) "��3")
            ((tutcode-postfix-mazegaki-4-start) "��4")
            ((tutcode-postfix-mazegaki-5-start) "��5")
            ((tutcode-postfix-mazegaki-6-start) "��6")
            ((tutcode-postfix-mazegaki-7-start) "��7")
            ((tutcode-postfix-mazegaki-8-start) "��8")
            ((tutcode-postfix-mazegaki-9-start) "��9")
            ((tutcode-postfix-mazegaki-inflection-start) "��")
            ((tutcode-postfix-mazegaki-inflection-1-start) "��1")
            ((tutcode-postfix-mazegaki-inflection-2-start) "��2")
            ((tutcode-postfix-mazegaki-inflection-3-start) "��3")
            ((tutcode-postfix-mazegaki-inflection-4-start) "��4")
            ((tutcode-postfix-mazegaki-inflection-5-start) "��5")
            ((tutcode-postfix-mazegaki-inflection-6-start) "��6")
            ((tutcode-postfix-mazegaki-inflection-7-start) "��7")
            ((tutcode-postfix-mazegaki-inflection-8-start) "��8")
            ((tutcode-postfix-mazegaki-inflection-9-start) "��9")
            ((tutcode-auto-help-redisplay) "��")
            (else cand)))
         (cand-hint
          (or
            ;; ������������ξ���hint-mark(*)�դ�
            (and has-next? (string-append tutcode-hint-mark candstr))
            candstr)))
        (cons (list label cand-hint) label-cand-alist)))))

;;; ���۸��׾�νϸ쥬���ɤ�ɽ���˻Ȥ�alist�˴������ɲä��롣
;;; @param kanji-stroke �ɲä�������ȥ��ȥ����Υꥹ�ȡ�
;;; ��: ((("," "r"))("��"))
(define (tutcode-stroke-help-guide-add-kanji pc kanji-stroke)
  (let ((chars (tutcode-context-guide-chars pc)))
    (if (not (member kanji-stroke chars))
      (tutcode-context-set-guide-chars! pc (cons kanji-stroke chars)))))

;;; ���۸��׾�νϸ쥬���ɤ�ɽ���˻Ȥ�alist�򹹿����롣
;;; alist�ϰʲ��Τ褦�˥�٥�ʸ����ɽ����ʸ����Υꥹ�ȡ�
;;; ��: (("," "��") ("u" "+�Ӳ�"))
;;; @param label-cands-alist ����alist
;;; @param seqlen �����ܤΥ��ȥ������оݤȤ��뤫��
;;; @param rule-list rk-rule��
;;; @return ������νϸ쥬������alist
(define (tutcode-stroke-help-guide-update-alist
         label-cands-alist seqlen rule-list)
  (if (null? rule-list)
    label-cands-alist
    (tutcode-stroke-help-guide-update-alist
      (tutcode-stroke-help-guide-update-alist-with-rule
        label-cands-alist seqlen (car rule-list))
      seqlen (cdr rule-list))))

;;; ���۸��׾�νϸ쥬����:�оݤ�1ʸ���򡢽ϸ쥬������alist���ɲä��롣
;;; @param label-cands-alist ����alist
;;; @param seqlen �����ܤΥ��ȥ������оݤȤ��뤫��
;;; @param rule rk-rule��ΰ�Ĥ�rule��
;;; @return ������νϸ쥬����alist
(define (tutcode-stroke-help-guide-update-alist-with-rule
         label-cands-alist seqlen rule)
  (let* ((label (list-ref (caar rule) seqlen))
         (label-cand (assoc label label-cands-alist))
         (has-next? (> (length (caar rule)) (+ seqlen 1))) ; ������������?
         (cand (car (cadr rule))))
    (if label-cand
      (begin
        ;; ���˳����Ƥ��Ƥ�����
        (set-cdr! label-cand (cons cand (cdr label-cand)))
        label-cands-alist)
      (cons
        (if has-next?
          (list label cand tutcode-guide-mark)
          (list label tutcode-guide-end-mark cand))
        label-cands-alist))))

;;; ��������Ѵ����򤼽��Ѵ��ǳ��ꤷ��ʸ�����Ǥ�����ɽ�����롣
;;; ɽ�����θ��䥦����ɥ��ξ��ϡ��ʲ��Τ褦��ɽ�����롣
;;; 1����1�Ǹ���2����2�Ǹ����ַȡ�
;;;  ��������        ��������
;;;  ��������        ����3 ��
;;;  ��������1(��)   ��������
;;;  ������2         ��������
;;; �򤼽��Ѵ���ʣ����ʸ���ַ��ӡפ��Ѵ��������ϡ��ʲ��Τ褦��ɽ�����롣
;;;  ������    ��        ��������
;;;  ����a(��) ��        ����3 ��
;;;  ������    ��1(��)b  ����c ��
;;;  ������    2         ��������
;;; ���ꤷ��ʸ����ľ�����ϤǤ��ʤ���硢ñ�����������Ѵ������ϤǤ���С�
;;; �ʲ��Τ褦����������Ѵ���ˡ��ɽ�����롣��ͫݵ��
;;;    ������������������������������������������������������������
;;;    ��  ��  ��  ��  ��  ��  ��            ��  ��  ��      ��  ��
;;;    ����������������������  ������������������������������������
;;;    ��  ��  ��  ��  ��b ��  ��            ��  ��  ��f     ��  ��
;;;    ����������������������  ������������������������������������
;;;    ��  ��3 ��  ��  ��  ��  ��            ��  ��  ��1(ͫ) ��  ��
;;;    ����������������������  ������������������������������������
;;;    ��  ��  ��d ��  ��e ��  ��2a(ݵ���Ӵ�)��  ��  ��      ��  ��
;;;    ������������������������������������������������������������
;;;
;;; �̾�θ��䥦����ɥ��ξ��ϡ��ʲ��Τ褦��ɽ�����롣
;;;   ͫ lns
;;;   ݵ ���Ӵ� nt cbo
;;;
;;; @param strlist ���ꤷ��ʸ����Υꥹ��(�ս�)
;;; @param yomilist �Ѵ������ɤߤ�ʸ����Υꥹ��(�ս�)
(define (tutcode-check-auto-help-window-begin pc strlist yomilist)
  (if (and (eq? (tutcode-context-candidate-window pc)
                'tutcode-candidate-window-off)
           tutcode-use-auto-help-window?)
    (begin
      (tutcode-context-set-guide-chars! pc ())
      (let*
        ((helpstrlist (lset-difference string=? (reverse strlist) yomilist))
         (label-cands-alist
          (if (not tutcode-auto-help-with-real-keys?)
            ;; ɽ�����ξ�����:(("y" "2" "1") ("t" "3"))
            (tutcode-auto-help-update-stroke-alist
              pc () tutcode-auto-help-cand-str-list helpstrlist)
            ;; �̾�ξ�����:(("��" "t" "y" "y"))
            (reverse
              (tutcode-auto-help-update-stroke-alist-normal pc () helpstrlist)))))
        (if (not (null? label-cands-alist))
          (let
            ((auto-help
              (map
                (lambda (elem)
                  (list (tutcode-make-string (cdr elem)) (car elem) ""))
                label-cands-alist)))
            (tutcode-context-set-auto-help! pc auto-help)
            (tutcode-context-set-candidate-window! pc
              'tutcode-candidate-window-auto-help)
            (im-activate-candidate-selector pc
              (length auto-help) tutcode-nr-candidate-max-for-kigou-mode)))))))

;;; ��ư�إ�פ�ɽ����ɽ���˻Ȥ�alist�򹹿����롣
;;; alist�ϰʲ��Τ褦���Ǹ��򼨤���٥�ʸ���ȡ����������ɽ������ʸ����Υꥹ��
;;;  ��:(("y" "2" "1") ("t" "3")) ; ("y" "y" "t")�Ȥ������ȥ�����ɽ����
;;;  ��������    ��������
;;;  ��������3 12��������
;;;  ��������    ��������
;;;  ��������    ��������
;;; @param label-cands-alist ����alist
;;; @param kanji-list �إ��ɽ���оݤǤ��롢���ꤵ�줿����
;;; @param cand-list �إ��ɽ���˻Ȥ������Ǹ��򼨤�ʸ���Υꥹ��
;;; @return ������μ�ư�إ����alist
(define (tutcode-auto-help-update-stroke-alist pc label-cands-alist
         cand-list kanji-list)
  (if (or (null? cand-list) (null? kanji-list))
    label-cands-alist
    (tutcode-auto-help-update-stroke-alist
      pc
      (tutcode-auto-help-update-stroke-alist-with-kanji
        pc label-cands-alist (car cand-list) (car kanji-list))
      (cdr cand-list) (cdr kanji-list))))

;;; ��ư�إ�פ��̾����ɽ���˻Ȥ�alist�򹹿����롣
;;; alist�ϰʲ��Τ褦��ʸ���ȡ�ʸ�������Ϥ��뤿��Υ����Υꥹ��(�ս�)
;;;  ��:(("��" "t" "y" "y"))
;;; @param label-cands-alist ����alist
;;; @param kanji-list �إ��ɽ���оݤǤ��롢���ꤵ�줿����
;;; @return ������μ�ư�إ����alist
(define (tutcode-auto-help-update-stroke-alist-normal pc label-cands-alist
         kanji-list)
  (if (null? kanji-list)
    label-cands-alist
    (tutcode-auto-help-update-stroke-alist-normal
      pc
      (tutcode-auto-help-update-stroke-alist-normal-with-kanji
        pc label-cands-alist (car kanji-list))
      (cdr kanji-list))))

;;; ��ư�إ��:�оݤ�1ʸ�������Ϥ��륹�ȥ�����إ����alist���ɲä��롣
;;; @param label-cands-alist ����alist
;;; @param cand-list �إ��ɽ���˻Ȥ������Ǹ��򼨤�ʸ���Υꥹ��
;;; @param kanji �إ��ɽ���о�ʸ��
;;; @return ������μ�ư�إ����alist
(define (tutcode-auto-help-update-stroke-alist-with-kanji pc label-cands-alist
         cand-list kanji)
  (let*
    ((rule (rk-context-rule (tutcode-context-rk-context pc)))
     (stroke (tutcode-reverse-find-seq kanji rule)))
    (if stroke
      (begin
        (tutcode-stroke-help-guide-add-kanji
          pc (list (list stroke) (list kanji)))
        (tutcode-auto-help-update-stroke-alist-with-stroke
          label-cands-alist
          (cons (string-append (caar cand-list) "(" kanji ")") (cdar cand-list))
          stroke))
      (let ((decomposed (tutcode-auto-help-bushu-decompose kanji rule)))
        ;; ��: "��" => (((("," "o"))("��")) ((("f" "q"))("��")))
        (if (not decomposed)
          label-cands-alist
          (begin
            (tutcode-stroke-help-guide-add-kanji pc (car decomposed))
            (tutcode-stroke-help-guide-add-kanji pc (cadr decomposed))
            (tutcode-auto-help-update-stroke-alist-with-stroke
              (tutcode-auto-help-update-stroke-alist-with-stroke
                label-cands-alist
                (cons
                  (string-append (caar cand-list) "(" kanji "��"
                    (caar (cdar decomposed)) (caar (cdadr decomposed)) ")")
                  (cdar cand-list))
                (caaar decomposed)) ; ����1
              (cadr cand-list) (caaadr decomposed)))))))) ; ����2

;;; ��ư�إ��:�оݤ�1ʸ�������Ϥ��륹�ȥ�����إ����alist���ɲä��롣
;;; @param label-cands-alist ����alist
;;; @param kanji �إ��ɽ���о�ʸ��
;;; @return ������μ�ư�إ����alist
(define (tutcode-auto-help-update-stroke-alist-normal-with-kanji
          pc label-cands-alist kanji)
  (let*
    ((rule (rk-context-rule (tutcode-context-rk-context pc)))
     (stroke (tutcode-reverse-find-seq kanji rule)))
    (if stroke
      (begin
        (tutcode-stroke-help-guide-add-kanji
          pc (list (list stroke) (list kanji)))
        (tutcode-auto-help-update-stroke-alist-normal-with-stroke
          label-cands-alist
          (cons (string-append kanji " ") stroke)
          kanji))
      (let ((decomposed (tutcode-auto-help-bushu-decompose kanji rule)))
        ;; ��: "��" => (((("," "o"))("��")) ((("f" "q"))("��")))
        (if (not decomposed)
          label-cands-alist
          (begin
            (tutcode-stroke-help-guide-add-kanji pc (car decomposed))
            (tutcode-stroke-help-guide-add-kanji pc (cadr decomposed))
            (tutcode-auto-help-update-stroke-alist-normal-with-stroke
              label-cands-alist
              (cons
                (string-append kanji "��"
                  (caar (cdar decomposed)) (caar (cdadr decomposed)) " ")
                (append
                  (caaar decomposed)    ; ����1
                  (list " ")
                  (caaadr decomposed))) ; ����2
              kanji)))))))

;;; ��ư�إ��:�оݤΥ��ȥ���(�����Υꥹ��)��إ����alist���ɲä��롣
;;; @param label-cands-alist ����alist
;;; @param cand-list �إ��ɽ���˻Ȥ������Ǹ��򼨤�ʸ���Υꥹ��
;;; @param stroke �оݥ��ȥ���
;;; @return ������μ�ư�إ����alist
(define (tutcode-auto-help-update-stroke-alist-with-stroke label-cands-alist
         cand-list stroke)
  (if (or (null? cand-list) (null? stroke))
    label-cands-alist
    (tutcode-auto-help-update-stroke-alist-with-stroke
      (tutcode-auto-help-update-stroke-alist-with-key
        label-cands-alist
        (if (pair? cand-list) (car cand-list) "")
        (car stroke))
      (cdr cand-list) (cdr stroke))))

;;; ��ư�إ��:�оݤΥ��ȥ���(�����Υꥹ��)��إ����alist���ɲä��롣
;;; @param label-cands-alist ����alist
;;; @param stroke �оݥ��ȥ���
;;; @param label ���ꤵ�줿����
;;; @return ������μ�ư�إ����alist
(define (tutcode-auto-help-update-stroke-alist-normal-with-stroke
          label-cands-alist stroke label)
  (let ((label-cand (assoc label label-cands-alist)))
    (if (not label-cand)
      (cons (cons label (reverse stroke)) label-cands-alist))))

;;; ��ư�إ��:�оݤΥ�����إ����alist���ɲä��롣
;;; @param label-cands-alist ����alist
;;; @param cand �إ��ɽ���˻Ȥ����оݥ����򼨤�ʸ��
;;; @param key �оݥ���
;;; @return ������μ�ư�إ����alist
(define (tutcode-auto-help-update-stroke-alist-with-key label-cands-alist
         cand key)
  (let*
    ((label key)
     (label-cand (assoc label label-cands-alist)))
    (if label-cand
      (begin
        (set-cdr! label-cand (cons cand (cdr label-cand)))
        label-cands-alist)
      (cons (list label cand) label-cands-alist))))

;;; ��ư�إ��:ľ��μ�ư�إ�פ��ɽ������
(define (tutcode-auto-help-redisplay pc)
  (let ((help (tutcode-context-auto-help pc)))
    (if (and help (> (length help) 0))
      (begin
        (tutcode-context-set-candidate-window! pc
          'tutcode-candidate-window-auto-help)
        (im-activate-candidate-selector pc
          (length help)
          tutcode-nr-candidate-max-for-kigou-mode)))))

;;; preeditɽ���򹹿����롣
(define (tutcode-do-update-preedit pc)
  (let ((stat (tutcode-context-state pc))
        (cpc (tutcode-context-child-context pc))
        (cursor-shown? #f))
    (case stat
      ((tutcode-state-yomi)
        (im-pushback-preedit pc preedit-none "��")
        (let ((h (tutcode-make-string (tutcode-context-head pc))))
          (if (string? h)
            (im-pushback-preedit pc preedit-none h))))
      ((tutcode-state-converting)
        (im-pushback-preedit pc preedit-none "��")
        (if (null? cpc)
          (begin
            (im-pushback-preedit pc preedit-none
              (tutcode-get-current-candidate pc))
            (let ((suffix (tutcode-context-mazegaki-suffix pc))) ; ���Ѹ���
              (if (pair? suffix)
                (begin
                  (im-pushback-preedit pc preedit-cursor "")
                  (set! cursor-shown? #t)
                  (im-pushback-preedit pc preedit-none
                    (tutcode-make-string suffix))))))
          ;; child context's preedit
          (let ((h (tutcode-make-string (tutcode-context-head pc)))
                (editor (tutcode-context-editor pc))
                (dialog (tutcode-context-dialog pc)))
            (if (string? h)
              (im-pushback-preedit pc preedit-none h))
            (im-pushback-preedit pc preedit-none "��")
            (im-pushback-preedit pc preedit-none
              (if (eq? (tutcode-context-child-type pc)
                    'tutcode-child-type-editor)
                (tutcode-editor-get-left-string editor)
                (tutcode-dialog-get-left-string dialog)))
            (tutcode-do-update-preedit cpc)
            (set! cursor-shown? #t)
            (im-pushback-preedit pc preedit-none
              (if (eq? (tutcode-context-child-type pc)
                    'tutcode-child-type-editor)
                (tutcode-editor-get-right-string editor)
                (tutcode-dialog-get-right-string dialog)))
            (im-pushback-preedit pc preedit-none "��"))))
      ;; ��������Ѵ��Υޡ�������ʸ����Ȥ���head��Ǵ���(�Ƶ�Ū��������Τ���)
      ((tutcode-state-bushu)
        (let ((h (tutcode-make-string (tutcode-context-head pc))))
          (if (string? h)
            (im-pushback-preedit pc preedit-none h))))
      ((tutcode-state-interactive-bushu)
        (im-pushback-preedit pc preedit-none "��")
        (let ((h (tutcode-make-string (tutcode-context-head pc))))
          (if (string? h)
            (im-pushback-preedit pc preedit-none h)))
        (im-pushback-preedit pc preedit-cursor "")
        (set! cursor-shown? #t)
        (if (> (tutcode-lib-get-nr-predictions pc) 0)
          (begin
            (im-pushback-preedit pc preedit-underline "=>")
            (im-pushback-preedit pc preedit-underline
              (tutcode-get-prediction-string pc)))))
      ((tutcode-state-kigou)
        ;; ���䥦����ɥ���ɽ�����Ǥ��������Ǥ���褦��preeditɽ��
        (im-pushback-preedit pc preedit-reverse
          (tutcode-get-current-candidate-for-kigou-mode pc))))
    (if (not cursor-shown?)
      (im-pushback-preedit pc preedit-cursor ""))))

;;; preeditɽ���򹹿����롣
(define (tutcode-update-preedit pc)
  (im-clear-preedit pc)
  (tutcode-do-update-preedit (tutcode-find-root-context pc))
  (im-update-preedit pc))

;; called from tutcode-editor
;;; tutcode-editor¦�Ǥ��Խ���λ���˸ƤФ�롣
;;; @param str ���ǥ���¦�ǳ��ꤵ�줿ʸ����
(define (tutcode-commit-editor-context pc str)
  (let ((yomi-len (tutcode-context-postfix-yomi-len pc))
        (suffix (tutcode-context-mazegaki-suffix pc)))
    (if (> yomi-len 0)
      (tutcode-postfix-delete-text pc yomi-len))
    (tutcode-flush pc)
    (tutcode-context-set-child-context! pc ())
    (tutcode-context-set-child-type! pc ())
    (tutcode-commit pc
      (if (null? suffix)
        str
        (string-append str (tutcode-make-string suffix))))
    (tutcode-update-preedit pc)))

;;; �䴰����򸡺����Ƹ��䥦����ɥ���ɽ������
;;; @param force-check? ɬ��������Ԥ����ɤ�����
;;;  #f�ξ���ʸ������������̤���ξ��ϸ������ʤ���
;;; @param num commit-strs���鸡���оݤˤ���ʸ������0�ξ������ơ�
(define (tutcode-check-completion pc force-check? num)
  (tutcode-context-set-commit-strs-used-len! pc 0)
  (if (eq? (tutcode-context-predicting pc) 'tutcode-predicting-off)
    (let* ((commit-strs-all (tutcode-context-commit-strs pc))
           (commit-strs
            (if (> num 0)
              (take commit-strs-all num)
              commit-strs-all))
           (len (length commit-strs)))
      (if
        (or (>= len tutcode-completion-chars-min)
            (and force-check?
                 (> len 0)))
        (let ((str (tutcode-make-string commit-strs)))
          (tutcode-lib-set-prediction-src-string pc str #t)
          (let ((nr (tutcode-lib-get-nr-predictions pc)))
            (if (and nr (> nr 0))
              (let*
                ((nr-guide
                  (if tutcode-use-kanji-combination-guide?
                    (begin
                      (tutcode-guide-set-candidates pc str #t ())
                      (length (tutcode-context-guide pc)))
                    0))
                 (res (tutcode-prediction-calc-window-param nr nr-guide))
                 (nr-all (list-ref res 0)) ; �������(�䴰����+�ϸ쥬����)
                 (page-limit (list-ref res 1)) ; �ڡ���������(�䴰+�ϸ�)
                 (nr-in-page (list-ref res 2))) ; �ڡ���������(�䴰����Τ�)
                (if (> page-limit 0)
                  (begin
                    (tutcode-context-set-commit-strs-used-len! pc len)
                    (tutcode-context-set-prediction-nr-in-page! pc nr-in-page)
                    (tutcode-context-set-prediction-page-limit! pc page-limit)
                    (tutcode-context-set-prediction-nr-all! pc nr-all)
                    (tutcode-context-set-prediction-index! pc 0)
                    (tutcode-context-set-candidate-window! pc
                      'tutcode-candidate-window-predicting)
                    (tutcode-context-set-predicting! pc
                      'tutcode-predicting-completion)
                    (im-activate-candidate-selector pc nr-all page-limit))))
              ;; �䴰���䤬���Ĥ���ʤ���硢1ʸ����ä�ʸ�����ȤäƺƸ���
              ;; (ľ��tutcode-context-set-commit-strs!��ʸ������ȡ�
              ;;  �ְ�ä�ʸ�������Ϥ���Backspace�Ǿä����Ȥ��ˡ�
              ;;  �������Ϥ���ʸ���󤬺���Ƥ��뤿�ᡢ���Ԥ����䴰�ˤʤ�ʤ�
              ;;  ���줢�ꡣ®��Ū�ˤϡ�ľ�ܺ������®������)
              (if (> len 1)
                (tutcode-check-completion pc force-check? (- len 1))))))))))

;;; �򤼽��Ѵ����ͽ¬���ϸ���򸡺����Ƹ��䥦����ɥ���ɽ������
;;; @param force-check? ɬ��������Ԥ����ɤ�����
;;;  #f�ξ���ʸ������������̤���ξ��ϸ������ʤ���
(define (tutcode-check-prediction pc force-check?)
  (if (eq? (tutcode-context-predicting pc) 'tutcode-predicting-off)
    (let* ((head (tutcode-context-head pc))
           (preedit-len (length head)))
      (if
        (or (>= preedit-len tutcode-prediction-start-char-count)
            force-check?)
        (let*
          ((preconv-str (tutcode-make-string head))
           (all-yomi (tutcode-lib-set-prediction-src-string pc preconv-str #f))
           (nr (tutcode-lib-get-nr-predictions pc)))
          (if (and nr (> nr 0))
            (let*
              ((nr-guide
                (if tutcode-use-kanji-combination-guide?
                  (begin
                    (tutcode-guide-set-candidates pc preconv-str #f all-yomi)
                    (length (tutcode-context-guide pc)))
                  0))
               (res (tutcode-prediction-calc-window-param nr nr-guide))
               (nr-all (list-ref res 0)) ; �������(ͽ¬����+�ϸ쥬����)
               (page-limit (list-ref res 1)) ; �ڡ���������(ͽ¬+�ϸ�)
               (nr-in-page (list-ref res 2))) ; �ڡ���������(ͽ¬����Τ�)
              (if (> page-limit 0)
                (begin
                  (tutcode-context-set-prediction-nr-in-page! pc nr-in-page)
                  (tutcode-context-set-prediction-page-limit! pc page-limit)
                  (tutcode-context-set-prediction-nr-all! pc nr-all)
                  (tutcode-context-set-prediction-index! pc 0)
                  (tutcode-context-set-candidate-window! pc
                    'tutcode-candidate-window-predicting)
                  (tutcode-context-set-predicting! pc
                    'tutcode-predicting-prediction)
                  (im-activate-candidate-selector pc nr-all page-limit))))))
        (tutcode-reset-candidate-window pc)))))

;;; ��������Ѵ����ͽ¬���ϸ���򸡺����Ƹ��䥦����ɥ���ɽ������
;;; @param char ���Ϥ��줿����1
(define (tutcode-check-bushu-prediction pc char)
  (if (eq? (tutcode-context-predicting pc) 'tutcode-predicting-off)
    (let* ((res (tutcode-bushu-predict char tutcode-bushudic))
           (alt (assoc char tutcode-bushudic-altchar))
           (altres
            (if alt
              (tutcode-bushu-predict (cadr alt) tutcode-bushudic)
              ()))
           (resall (append res altres)))
      (tutcode-context-set-prediction-bushu! pc resall)
      (tutcode-bushu-prediction-show-page pc 0))))

;;; ��������Ѵ���ͽ¬���ϸ���Τ��������ꤵ�줿�ֹ椫��Ϥޤ�����ɽ�����롣
;;; @param start-index �����ֹ�
(define (tutcode-bushu-prediction-show-page pc start-index)
  (tutcode-lib-set-bushu-prediction pc start-index)
  (let ((nr (tutcode-lib-get-nr-predictions pc)))
    (if (and nr (> nr 0))
      (let*
        ((nr-guide
          (if tutcode-use-kanji-combination-guide?
            (begin
              (tutcode-guide-set-candidates-for-bushu pc)
              (length (tutcode-context-guide pc)))
            0))
         (res (tutcode-prediction-calc-window-param nr nr-guide))
         (nr-all (list-ref res 0)) ; �������(ͽ¬����+�ϸ쥬����)
         (page-limit (list-ref res 1)) ; �ڡ���������(ͽ¬+�ϸ�)
         (nr-in-page (list-ref res 2))) ; �ڡ���������(ͽ¬����Τ�)
        (if (> page-limit 0)
          (begin
            (tutcode-context-set-prediction-nr-in-page! pc nr-in-page)
            (tutcode-context-set-prediction-page-limit! pc page-limit)
            (tutcode-context-set-prediction-nr-all! pc nr-all)
            (tutcode-context-set-prediction-index! pc 0)
            (tutcode-context-set-candidate-window! pc
              'tutcode-candidate-window-predicting)
            (tutcode-context-set-predicting! pc 'tutcode-predicting-bushu)
            (im-activate-candidate-selector pc nr-all page-limit)))))))

;;; �䴰����Ƚϸ쥬����ɽ���Τ����candwin�ѥѥ�᡼����׻�����
;;; @param nr �䴰�����
;;; @param nr-guide �ϸ쥬���ɸ����
;;; @return (<�������> <�ڡ������Ȥθ�������> <�ڡ������Ȥ��䴰��������>)
(define (tutcode-prediction-calc-window-param nr nr-guide)
  ;; XXX:ɽ�������䥦����ɥ���display_limit��Ĵ�������ȡ��׻��˻Ȥ�
  ;;     tutcode-nr-candidate-max-for-guide����Ŭ�ڤ��ͤˤʤäƤ��ʤ����줢�ꡣ
  (cond
    ;; 1�ڡ����˼��ޤ���
    ((and (<= nr-guide tutcode-nr-candidate-max-for-guide)
          (<= nr tutcode-nr-candidate-max-for-prediction))
      (list (+ nr-guide nr) (+ nr-guide nr) nr))
    ;; �䴰���䤬1�ڡ����˼��ޤ�ʤ����
    ((and (<= nr-guide tutcode-nr-candidate-max-for-guide)
          (> nr tutcode-nr-candidate-max-for-prediction))
      (if (= 0 tutcode-nr-candidate-max-for-prediction)
        (list nr-guide nr-guide 0) ; �䴰�����ɽ�����ʤ�
        (let*
          ((nr-page
            ;; �ڡ����������ϰ���ˤ��ʤ������ݤʤΤǡ�
            ;; �ƥڡ�����Ʊ���ϸ쥬���ɤ�ɽ����
            ;; ��������;��Υڡ����ˤ�ɽ�����ʤ���
            ;; (�ƥڡ�����Ǥ�index��nr-candidate-max-for-prediction̤����
            ;;  ������䴰/ͽ¬���ϸ��䡢�ʾ�θ����ϸ쥬���ɤȤ��ư����Τ�
            ;;  ����������ʤ��䴰����������ʤ�;��Υڡ����Ǥ�ɽ������������)
            (quotient nr tutcode-nr-candidate-max-for-prediction))
           (page-limit (+ nr-guide tutcode-nr-candidate-max-for-prediction))
           (nr-all (+ nr (* nr-guide nr-page))))
          (list nr-all page-limit tutcode-nr-candidate-max-for-prediction))))
    ;; �ϸ쥬���ɤ�1�ڡ����˼��ޤ�ʤ����
    ((and (> nr-guide tutcode-nr-candidate-max-for-guide)
          (<= nr tutcode-nr-candidate-max-for-prediction))
      (if (= 0 tutcode-nr-candidate-max-for-guide)
        (list nr nr nr) ; �ϸ쥬���ɤ�ɽ�����ʤ�
        (let*
          ((nr-page
            (+ 
              (quotient nr-guide tutcode-nr-candidate-max-for-guide)
              (if (= 0 (remainder nr-guide tutcode-nr-candidate-max-for-guide))
                0
                1)))
           (page-limit (+ nr tutcode-nr-candidate-max-for-guide))
           (nr-all (+ nr-guide (* nr nr-page))))
          (list nr-all page-limit nr))))
    ;; �䴰����Ƚϸ쥬����ξ���Ȥ�1�ڡ����˼��ޤ�ʤ����
    (else
      (cond
        ;; �ϸ쥬���ɤΤ�ɽ��
        ((= 0 tutcode-nr-candidate-max-for-prediction)
          (list nr-guide tutcode-nr-candidate-max-for-guide 0))
        ;; �䴰����Τ�ɽ��
        ((= 0 tutcode-nr-candidate-max-for-guide)
          (list nr tutcode-nr-candidate-max-for-prediction
            tutcode-nr-candidate-max-for-prediction))
        (else
          (let*
            ((nr-page-prediction
              (quotient nr tutcode-nr-candidate-max-for-prediction))
             (nr-page-guide
              (+
                (quotient nr-guide tutcode-nr-candidate-max-for-guide)
                (if (= 0 (remainder nr-guide tutcode-nr-candidate-max-for-guide))
                  0
                  1)))
             (nr-page (max nr-page-prediction nr-page-guide))
             (page-limit (+ tutcode-nr-candidate-max-for-guide
              tutcode-nr-candidate-max-for-prediction))
             (nr-all 
              (if (> nr-page-prediction nr-page-guide)
                (+ nr (* nr-page tutcode-nr-candidate-max-for-guide))
                (+ nr-guide (* nr-page tutcode-nr-candidate-max-for-prediction)))))
            (list nr-all page-limit tutcode-nr-candidate-max-for-prediction)))))))

;;; TUT-Code���Ͼ��֤ΤȤ��Υ������Ϥ�������롣
;;; @param c ����ƥ����ȥꥹ��
;;; @param key ���Ϥ��줿����
;;; @param key-state ����ȥ��륭�����ξ���
(define (tutcode-proc-state-on c key key-state)
  (let*
    ((pc (tutcode-find-descendant-context c))
     (rkc (tutcode-context-rk-context pc))
     ;; reset-candidate-window�ǥꥻ�åȤ����Τ���¸���Ƥ���
     (completing?
      (eq? (tutcode-context-predicting pc) 'tutcode-predicting-completion))
     ;; �䴰����ɽ���Υڡ�����ư���ϡ�reset-candidate-window����������
     (prediction-keys-handled?
      (if completing?
        (cond
          ((tutcode-next-page-key? key key-state)
            (tutcode-change-prediction-page pc #t)
            #t)
          ((tutcode-prev-page-key? key key-state)
            (tutcode-change-prediction-page pc #f)
            #t)
          (else
            #f))
        #f)))
    (if (not prediction-keys-handled?)
      (begin
        (tutcode-reset-candidate-window pc)
        (cond
          ((and
            (tutcode-vi-escape-key? key key-state)
            tutcode-use-with-vi?)
           (rk-flush rkc)
           (tutcode-context-set-commit-strs! pc ())
           (tutcode-context-set-state! pc 'tutcode-state-off)
           (tutcode-commit-raw pc key key-state)) ; ESC�����򥢥ץ�ˤ��Ϥ�
          ((tutcode-off-key? key key-state)
           (rk-flush rkc)
           (tutcode-context-set-commit-strs! pc ())
           (tutcode-context-set-state! pc 'tutcode-state-off))
          ((tutcode-kigou-toggle-key? key key-state)
           (rk-flush rkc)
           (tutcode-begin-kigou-mode pc))
          ((tutcode-kigou2-toggle-key? key key-state)
           (rk-flush rkc)
           (tutcode-toggle-kigou2-mode pc))
          ((and (tutcode-kana-toggle-key? key key-state)
                (not (tutcode-kigou2-mode? pc)))
           (rk-flush rkc)
           (tutcode-context-kana-toggle pc))
          ((tutcode-backspace-key? key key-state)
           (if (> (length (rk-context-seq rkc)) 0)
             (rk-flush rkc)
             (begin
               (tutcode-commit-raw pc key key-state)
               (if (and (or tutcode-use-completion?
                            tutcode-enable-fallback-surrounding-text?)
                        (pair? (tutcode-context-commit-strs pc)))
                 (tutcode-context-set-commit-strs! pc
                     (cdr (tutcode-context-commit-strs pc))))
               (if (and tutcode-use-completion?
                        completing?
                        (> tutcode-completion-chars-min 0))
                 (tutcode-check-completion pc #f 0)))))
          ((tutcode-stroke-help-toggle-key? key key-state)
           (tutcode-toggle-stroke-help pc))
          ((and tutcode-use-completion?
                (tutcode-begin-completion-key? key key-state))
           (rk-flush rkc)
           (if completing?
             ;; �䴰���begin-completin-key�������줿���о�ʸ����1���餷�ƺ��䴰
             ;; (�տޤ��ʤ�ʸ������䴰���줿���ˡ��䴰��ľ�����Ǥ���褦��)
             ;; �оݤ�1ʸ��̤���ˤʤ�����䴰������ɥ����Ĥ���(��ɽ�����ʤ�)
             (let ((len (tutcode-context-commit-strs-used-len pc)))
               (if (> len 1)
                 (tutcode-check-completion pc #t (- len 1))))
             (tutcode-check-completion pc #t 0)))
          ((or
            (symbol? key)
            (and
              (modifier-key-mask key-state)
              (not (shift-key-mask key-state))))
           (rk-flush rkc)
           (tutcode-commit-raw pc key key-state))
          ;; �䴰�����ѥ�٥륭��?
          ((and completing? (tutcode-heading-label-char-for-prediction? key))
            (tutcode-commit-by-label-key-for-prediction pc
              (charcode->string key) 'tutcode-predicting-completion))
          ;; �������ʤ������������󥹤����ƼΤƤ�(tc2�˹�碌��ư��)��
          ;; (rk-push-key!����ȡ�����ޤǤΥ������󥹤ϼΤƤ��뤬��
          ;; �ְ�ä������ϻĤäƤ��ޤ��Τǡ�rk-push-key!�ϻȤ��ʤ�)
          ((not (rk-expect-key? rkc (charcode->string key)))
           (if (> (length (rk-context-seq rkc)) 0)
             (rk-flush rkc) ; �������ʤ��������󥹤ϼΤƤ�
             ;; ñ�ȤΥ�������(TUT-Code���ϤǤʤ���)
             (tutcode-commit-raw pc key key-state)))
          (else
           (let ((res (tutcode-push-key! pc (charcode->string key))))
            (cond
              ((string? res)
                (tutcode-commit pc res)
                (if (and tutcode-use-completion?
                         (> tutcode-completion-chars-min 0))
                  (tutcode-check-completion pc #f 0)))
              ((eq? res 'tutcode-mazegaki-start)
                (tutcode-context-set-latin-conv! pc #f)
                (tutcode-context-set-postfix-yomi-len! pc 0)
                (tutcode-context-set-state! pc 'tutcode-state-yomi))
              ((eq? res 'tutcode-latin-conv-start)
                (tutcode-context-set-latin-conv! pc #t)
                (tutcode-context-set-postfix-yomi-len! pc 0)
                (tutcode-context-set-state! pc 'tutcode-state-yomi))
              ((eq? res 'tutcode-bushu-start)
                (tutcode-context-set-state! pc 'tutcode-state-bushu)
                (tutcode-append-string pc "��"))
              ((eq? res 'tutcode-interactive-bushu-start)
                (tutcode-context-set-prediction-nr! pc 0)
                (tutcode-context-set-state! pc
                  'tutcode-state-interactive-bushu))
              ((eq? res 'tutcode-postfix-bushu-start)
                (tutcode-begin-postfix-bushu-conversion pc))
              ((eq? res 'tutcode-postfix-mazegaki-start)
                (tutcode-begin-postfix-mazegaki-conversion pc #f #f #f))
              ((eq? res 'tutcode-postfix-mazegaki-1-start)
                (tutcode-begin-postfix-mazegaki-conversion pc 1 #t
                  tutcode-use-recursive-learning?))
              ((eq? res 'tutcode-postfix-mazegaki-2-start)
                (tutcode-begin-postfix-mazegaki-conversion pc 2 #t
                  tutcode-use-recursive-learning?))
              ((eq? res 'tutcode-postfix-mazegaki-3-start)
                (tutcode-begin-postfix-mazegaki-conversion pc 3 #t
                  tutcode-use-recursive-learning?))
              ((eq? res 'tutcode-postfix-mazegaki-4-start)
                (tutcode-begin-postfix-mazegaki-conversion pc 4 #t
                  tutcode-use-recursive-learning?))
              ((eq? res 'tutcode-postfix-mazegaki-5-start)
                (tutcode-begin-postfix-mazegaki-conversion pc 5 #t
                  tutcode-use-recursive-learning?))
              ((eq? res 'tutcode-postfix-mazegaki-6-start)
                (tutcode-begin-postfix-mazegaki-conversion pc 6 #t
                  tutcode-use-recursive-learning?))
              ((eq? res 'tutcode-postfix-mazegaki-7-start)
                (tutcode-begin-postfix-mazegaki-conversion pc 7 #t
                  tutcode-use-recursive-learning?))
              ((eq? res 'tutcode-postfix-mazegaki-8-start)
                (tutcode-begin-postfix-mazegaki-conversion pc 8 #t
                  tutcode-use-recursive-learning?))
              ((eq? res 'tutcode-postfix-mazegaki-9-start)
                (tutcode-begin-postfix-mazegaki-conversion pc 9 #t
                  tutcode-use-recursive-learning?))
              ((eq? res 'tutcode-postfix-mazegaki-inflection-start)
                (tutcode-begin-postfix-mazegaki-inflection-conversion pc #f))
              ((eq? res 'tutcode-postfix-mazegaki-inflection-1-start)
                (tutcode-begin-postfix-mazegaki-inflection-conversion pc 1))
              ((eq? res 'tutcode-postfix-mazegaki-inflection-2-start)
                (tutcode-begin-postfix-mazegaki-inflection-conversion pc 2))
              ((eq? res 'tutcode-postfix-mazegaki-inflection-3-start)
                (tutcode-begin-postfix-mazegaki-inflection-conversion pc 3))
              ((eq? res 'tutcode-postfix-mazegaki-inflection-4-start)
                (tutcode-begin-postfix-mazegaki-inflection-conversion pc 4))
              ((eq? res 'tutcode-postfix-mazegaki-inflection-5-start)
                (tutcode-begin-postfix-mazegaki-inflection-conversion pc 5))
              ((eq? res 'tutcode-postfix-mazegaki-inflection-6-start)
                (tutcode-begin-postfix-mazegaki-inflection-conversion pc 6))
              ((eq? res 'tutcode-postfix-mazegaki-inflection-7-start)
                (tutcode-begin-postfix-mazegaki-inflection-conversion pc 7))
              ((eq? res 'tutcode-postfix-mazegaki-inflection-8-start)
                (tutcode-begin-postfix-mazegaki-inflection-conversion pc 8))
              ((eq? res 'tutcode-postfix-mazegaki-inflection-9-start)
                (tutcode-begin-postfix-mazegaki-inflection-conversion pc 9))
              ((eq? res 'tutcode-auto-help-redisplay)
                (tutcode-auto-help-redisplay pc))))))))))

;;; ���ַ���������Ѵ���Ԥ�
(define (tutcode-begin-postfix-bushu-conversion pc)
  (and-let*
    ((former-seq (tutcode-postfix-acquire-text pc 2))
     (res (and (>= (length former-seq) 2)
               (tutcode-bushu-convert (cadr former-seq) (car former-seq)))))
    (tutcode-postfix-delete-text pc 2)
    (tutcode-commit pc res)
    (tutcode-check-auto-help-window-begin pc (list res) ())))

;;; ���ַ��򤼽��Ѵ��򳫻Ϥ���
;;; @param yomi-len ���ꤵ�줿�ɤߤ�ʸ���������ꤵ��Ƥʤ�����#f��
;;; @param autocommit? ���䤬1�Ĥξ��˼�ưŪ�˳��ꤹ�뤫�ɤ���
;;;  (yomi-len��#f�Ǥʤ�����ͭ��)
;;; @param recursive-learning? ���䤬̵�����˺Ƶ���Ͽ�⡼�ɤ����뤫�ɤ���
;;;  (yomi-len��#f�Ǥʤ�����ͭ��)
;;; @return #t:���䤬ͭ�ä���硣#f:���䤬̵���ä���硣
(define (tutcode-begin-postfix-mazegaki-conversion pc yomi-len autocommit?
          recursive-learning?)
  (tutcode-context-set-mazegaki-yomi-len-specified! pc (or yomi-len 0))
  (let*
    ((former-seq (tutcode-postfix-mazegaki-acquire-yomi pc yomi-len))
     (former-len (length former-seq)))
    (if yomi-len
      (and
        (>= former-len yomi-len)
        (let ((yomi (take former-seq yomi-len)))
          (tutcode-context-set-postfix-yomi-len! pc yomi-len)
          (if (> yomi-len (length (tutcode-context-mazegaki-yomi-all pc)))
            (tutcode-context-set-mazegaki-yomi-all! pc yomi))
          (tutcode-begin-conversion pc yomi () autocommit? recursive-learning?)))
      ;; �ɤߤ�ʸ���������ꤵ��Ƥ��ʤ����ɤߤ�̤�ʤ����Ѵ�
      (and
        (> former-len 0)
        (begin
          (tutcode-context-set-postfix-yomi-len! pc former-len)
          (tutcode-context-set-mazegaki-yomi-all! pc former-seq)
          (tutcode-mazegaki-relimit-right pc former-seq #f))))))

;;; �ɤߤ�̤�ʤ���򤼽��Ѵ���Ԥ���
;;; ���Ѥ��ʤ���Ȥ��Ƹ������Ƥ���䤬���Ĥ���ʤ����ϡ�
;;; ���Ѥ����Ȥ��Ƹ������ߤ롣
;;; @param yomi �Ѵ��оݤ��ɤ�(ʸ����εս�ꥹ��)
;;; @param relimit-first? (�ǽ�μ��񸡺�����)����ɤߤ�̤��
;;; @return #t:���䤬ͭ�ä���硣#f:���䤬̵���ä���硣
(define (tutcode-mazegaki-relimit-right pc yomi relimit-first?)
  (or
    (and
      (not relimit-first?)
      (tutcode-begin-conversion pc yomi () #f #f))
    ;; ���䤬���Ĥ���ʤ��ä�
    (or
      (and
        (> (length yomi) 1)
        (> (tutcode-context-postfix-yomi-len pc) 0) ;���ַ��ξ��ϲ��⤷�ʤ�
        (begin ; �ɤߤ�1ʸ�����餷�ƺƸ���
          (tutcode-context-set-postfix-yomi-len! pc (- (length yomi) 1))
          (tutcode-mazegaki-relimit-right pc (drop-right yomi 1) #f)))
      (and tutcode-mazegaki-enable-inflection? ; ���Ѥ����θ����˰ܹ�
        (not (tutcode-mazegaki-inflection? yomi)) ; ����Ū�������Ͻ�ʣ�����ʤ�
        (let*
          ((len-specified (tutcode-context-mazegaki-yomi-len-specified pc))
           (len
            (if (> len-specified 0)
              len-specified
              (length (tutcode-context-mazegaki-yomi-all pc)))))
          (tutcode-mazegaki-inflection-relimit-right pc len len #f))))))

;;; �ɤߤ򿭤Ф��ʤ�����ַ��򤼽��Ѵ���Ԥ���
;;; @param yomi-len ���������ɤߤ�Ĺ��
;;; @return #t:���䤬ͭ�ä���硣#f:���䤬̵���ä���硣
(define (tutcode-postfix-mazegaki-relimit-left pc yomi-len)
  (and
    (<= yomi-len tutcode-mazegaki-yomi-max)
    (let*
      ((yomi-all (tutcode-context-mazegaki-yomi-all pc))
       (yomi-all-len (length yomi-all)))
      (if (<= yomi-len yomi-all-len)
        (let ((yomi (take yomi-all yomi-len)))
          (tutcode-context-set-postfix-yomi-len! pc yomi-len)
          (or
            (tutcode-begin-conversion pc yomi () #f #f)
            (tutcode-postfix-mazegaki-relimit-left pc (+ yomi-len 1))))
        ;; �����Ѥ��ɤߤ�­��ʤ��ʤä���硢��¤�yomi-maxĹ���ɤߤ����
        (and
          (< yomi-all-len tutcode-mazegaki-yomi-max)
          (let ((former-seq (tutcode-postfix-mazegaki-acquire-yomi pc
                             tutcode-mazegaki-yomi-max)))
            (and
              (> (length former-seq) yomi-all-len)
              (begin
                (tutcode-context-set-mazegaki-yomi-all! pc former-seq)
                (tutcode-postfix-mazegaki-relimit-left pc yomi-len)))))))))

;;; ���ꤵ�줿�ɤߤ������Ѥ���줫�ɤ������֤�
;;; @param head �оݤ��ɤ�
;;; @return #t:���Ѥ����ξ�硣#f:����ʳ��ξ�硣
(define (tutcode-mazegaki-inflection? head)
  (and
    (pair? head)
    (string=? "��" (car head))))

;;; ���Ѥ����Ȥ��Ƹ��ַ��򤼽��Ѵ��򳫻Ϥ���
;;; @param yomi-len ���ꤵ�줿�ɤߤ�ʸ���������ꤵ��Ƥʤ�����#f��
;;; @return #t:���䤬ͭ�ä���硣#f:���䤬̵���ä���硣
(define (tutcode-begin-postfix-mazegaki-inflection-conversion pc yomi-len)
  (tutcode-context-set-mazegaki-yomi-len-specified! pc (or yomi-len 0))
  (let*
    ((former-seq (tutcode-postfix-mazegaki-acquire-yomi pc yomi-len))
     (former-len (length former-seq)))
    (if yomi-len
      (and
        (>= former-len yomi-len)
        (let ((yomi (take former-seq yomi-len)))
          (tutcode-context-set-postfix-yomi-len! pc yomi-len)
          (tutcode-context-set-mazegaki-yomi-all! pc yomi)
          (if (tutcode-mazegaki-inflection? yomi)
            ;; ����Ū��"��"�դ������Ϥ��줿��硢���Ѥ��ʤ���Ȥ��Ƹ�������
            ;; (���Ѥ����Ȥ��Ƽ�갷�����ϡ�"��"�ΰ��֤�Ĵ�����ʤ���
            ;;  ����������ˤʤ뤬������Ū�˻��ꤵ��Ƥ�����ϰ���Ĵ������)
            (tutcode-begin-conversion pc yomi () #t
              tutcode-use-recursive-learning?)
            (tutcode-mazegaki-inflection-relimit-right pc
              yomi-len yomi-len #f))))
      ;; �ɤߤ�ʸ���������ꤵ��Ƥ��ʤ����ɤ�/�촴��̤�ʤ����Ѵ�
      (and
        (> former-len 0)
        ;; �촴��Ĺ����Τ�ͥ�褷���Ѵ�
        (begin
          (tutcode-context-set-postfix-yomi-len! pc former-len)
          (tutcode-context-set-mazegaki-yomi-all! pc former-seq)
          (if (tutcode-mazegaki-inflection? former-seq) ; ����Ū"��"
            (tutcode-mazegaki-relimit-right pc former-seq #f)
            (tutcode-mazegaki-inflection-relimit-right pc
              former-len former-len #f)))))))

;;; ���Ѥ����θ򤼽��Ѵ��Τ��ᡢ
;;; �ɤ�/�촴��̤�ʤ��顢�촴����Ĺ�Ȥʤ��ɤߤ򸫤Ĥ����Ѵ���Ԥ���
;;; @param yomi-cur-len yomi-all�Τ����Ǹ����Ѵ��оݤȤʤäƤ����ɤߤ�Ĺ��
;;; @param len �����оݤȤ���촴��Ĺ��
;;; @param relimit-first? (�ǽ�μ��񸡺�����)����ɤߤ�̤�뤫�ɤ���
;;; @return #t:���䤬ͭ�ä���硣#f:���䤬̵���ä���硣
(define (tutcode-mazegaki-inflection-relimit-right pc yomi-cur-len len
          relimit-first?)
  (and
    (> len 0)
    (let*
      ((yomi-all (tutcode-context-mazegaki-yomi-all pc))
       (len-specified (tutcode-context-mazegaki-yomi-len-specified pc)))
      (or
        ;; �촴��Ĺ��(len=length head)���ݻ������ޤޡ��ɤߤ�̤�ʤ��鸡��
        (let loop
          ((yomi-cur (take yomi-all yomi-cur-len))
           (skip-search? relimit-first?))
          (let* ((yomi-len (length yomi-cur))
                 (suffix-len (- yomi-len len)))
            (and
              (>= suffix-len 0)
              (or
                (and
                  (not skip-search?)
                  (<= suffix-len tutcode-mazegaki-suffix-max)
                  (receive (suffix head) (split-at yomi-cur suffix-len)
                    (if (> (tutcode-context-postfix-yomi-len pc) 0) ; ���ַ�?
                      (tutcode-context-set-postfix-yomi-len! pc yomi-len))
                    (tutcode-begin-conversion pc (cons "��" head) suffix #f #f)))
                (and
                  (= len-specified 0)
                  ;; �ɤߤ�1ʸ���̤�Ƹ���
                  (loop (drop-right yomi-cur 1) #f))))))
        ;; �촴��1ʸ���̤�Ƹ���
        (tutcode-mazegaki-inflection-relimit-right pc
          (if (> len-specified 0)
            len-specified
            (length yomi-all))
          (- len 1) #f)))))

;;; ���Ѥ����θ򤼽��Ѵ��Τ��ᡢ
;;; �ɤ�/�촴�򿭤Ф��ʤ��顢�촴����Ĺ�Ȥʤ��ɤߤ򸫤Ĥ����Ѵ���Ԥ���
;;; @param yomi-cur-len yomi-all�Τ����Ǹ����Ѵ��оݤȤʤäƤ����ɤߤ�Ĺ��
;;; @param len �����оݤȤ���촴��Ĺ��
;;; @param relimit-first? (�ǽ�μ��񸡺�����)����ɤߤ򿭤Ф�
;;; @return #t:���䤬ͭ�ä���硣#f:���䤬̵���ä���硣
(define (tutcode-mazegaki-inflection-relimit-left pc yomi-cur-len len
          relimit-first?)
  (let*
    ((yomi-all (tutcode-context-mazegaki-yomi-all pc))
     (yomi-all-len (length yomi-all))
     (len-specified (tutcode-context-mazegaki-yomi-len-specified pc)))
    (or
      (and
        (<= len yomi-all-len)
        (or
          (let loop
            ((yomi-len yomi-cur-len)
             (skip-search? relimit-first?))
            ;; �촴��Ĺ��(len=length head)���ݻ������ޤ��ɤߤ򿭤Ф��ʤ��鸡��
            (and
              (<= len yomi-len yomi-all-len)
              (or
                (and
                  (not skip-search?)
                  (<= (- yomi-len len) tutcode-mazegaki-suffix-max)
                  (receive (suffix head)
                           (split-at (take yomi-all yomi-len) (- yomi-len len))
                    (if (> (tutcode-context-postfix-yomi-len pc) 0) ; ���ַ�?
                      (tutcode-context-set-postfix-yomi-len! pc yomi-len))
                    (tutcode-begin-conversion pc
                      (cons "��" head) suffix #f #f)))
                ;; �ɤߤ�1ʸ�����Ф��Ƹ���
                (and
                  (= len-specified 0)
                  (loop (+ yomi-len 1) #f)))))
          ;; �촴��1ʸ�����Ф��Ƹ���
          (tutcode-mazegaki-inflection-relimit-left pc
            (if (> len-specified 0)
              yomi-cur-len
              (+ len 1)) ; ��Ĺ��θ촴����Ƥ��ɤߤκ�ûĹ
            (+ len 1) #f)))
      ;; ����˿��Ф����ϡ����Ѥ��ʤ���θ����˰ܹ�
      (if (> (tutcode-context-postfix-yomi-len pc) 0) ; ���ַ�?
        (let ((len-new (if (> len-specified 0) len-specified 1)))
          (tutcode-postfix-mazegaki-relimit-left pc len-new))
        ;; ���ַ�
        (tutcode-begin-conversion pc yomi-all () #f #f)))))

;;; �򤼽��Ѵ����relimit-right�������ϻ��ν�����Ԥ�:
;;; �ɤ�/�촴��̤�ƺƸ���
(define (tutcode-mazegaki-proc-relimit-right pc)
  (tutcode-reset-candidate-window pc)
  (let*
    ((head (tutcode-context-head pc))
     (head-len (length head))
     (postfix-yomi-len (tutcode-context-postfix-yomi-len pc))
     (yomi-all (tutcode-context-mazegaki-yomi-all pc))
     (inflection?
      (and (tutcode-mazegaki-inflection? head)
           (not (tutcode-mazegaki-inflection? yomi-all)))) ; ����Ū"��"
     (found?
      (if (not inflection?)
        (tutcode-mazegaki-relimit-right pc head #t)
        (tutcode-mazegaki-inflection-relimit-right pc
          (+ (- head-len 1)
             (length (tutcode-context-mazegaki-suffix pc)))
          (- head-len 1) #t)))) ; (car head)��"��"
    (if (not found?) ; ����̵�����ɤ�/�촴��̤��Τ����
      (tutcode-context-set-postfix-yomi-len! pc postfix-yomi-len))))

;;; �򤼽��Ѵ����relimit-left�������ϻ��ν�����Ԥ�:
;;; �ɤ�/�촴�򿭤Ф��ƺƸ���
(define (tutcode-mazegaki-proc-relimit-left pc)
  (tutcode-reset-candidate-window pc)
  (let*
    ((head (tutcode-context-head pc))
     (head-len (length head))
     (postfix-yomi-len (tutcode-context-postfix-yomi-len pc))
     (yomi-all (tutcode-context-mazegaki-yomi-all pc))
     (inflection?
      (and (tutcode-mazegaki-inflection? head)
           (not (tutcode-mazegaki-inflection? yomi-all)))) ; ����Ū"��"
     (found?
      (if (not inflection?)
        (and (> postfix-yomi-len 0) ; ���ַ��ξ����ɤߤ򿭤Ф�
             (tutcode-postfix-mazegaki-relimit-left pc (+ head-len 1)))
        (tutcode-mazegaki-inflection-relimit-left pc
          (+ (- head-len 1)
             (length (tutcode-context-mazegaki-suffix pc)))
          (- head-len 1) #t)))) ; (car head)��"��"
    (if (not found?) ; ����̵�����ɤ�/�촴�򿭤Ф��Τ����
      (tutcode-context-set-postfix-yomi-len! pc postfix-yomi-len))))

;;; ���ַ��򤼽��Ѵ��Ѥ��ɤߤ��������
;;; @param yomi-len ���ꤵ�줿�ɤߤ�ʸ���������ꤵ��Ƥʤ�����#f��
;;; @return ���������ɤ�(ʸ����εս�ꥹ��)
(define (tutcode-postfix-mazegaki-acquire-yomi pc yomi-len)
  (let ((former-seq (tutcode-postfix-acquire-text pc
                     (or yomi-len tutcode-mazegaki-yomi-max))))
    (if yomi-len
      ;; XXX:�ɤߤ�ʸ���������ꤵ��Ƥ������"��"����ޤ�롣relimit-left
      ;;     ��ͳ�ξ���桼��������Ū�˻��ꤷ����ΤȤߤʤ���Ʊ�ͤ˴ޤ�롣
      former-seq
      ;; �ɤߤ�ʸ���������ꤵ��Ƥ��ʤ��������Ǥ���ʸ�������(���yomi-max)��
      (let*
        ;; ���ܸ�ʸ����ASCIIʸ���ζ��ܤ�����С������ޤǤ��������
        ((ascii?
          (lambda (str)
            (let ((ch (string->ichar str)))
              (and ch (<= ch 127)))))
         (last-ascii? (and (pair? former-seq) (ascii? (car former-seq)))))
        (take-while
          (lambda (elem)
            (and
              (eq? (ascii? elem) last-ascii?)
              ;; "��"��"��"������ʸ�����ɤߤ˴ޤ�ʤ���
              (not (member elem tutcode-postfix-mazegaki-terminate-char-list))))
          former-seq)))))

;;; �����ʸ������������
;;; @param len ��������ʸ����
;;; @return ��������ʸ����Υꥹ��(�ս�)
(define (tutcode-postfix-acquire-text pc len)
  (let ((ppc (tutcode-context-parent-context pc)))
    (if (not (null? ppc))
      (if (eq? (tutcode-context-child-type ppc) 'tutcode-child-type-dialog)
        ()
        (let*
          ((ec (tutcode-context-editor ppc))
           (left-string (tutcode-editor-left-string ec)))
          (if (> (length left-string) len)
            (take left-string len)
            left-string)))
      (let*
        ((ustr (im-acquire-text pc 'primary 'cursor len 0))
         (former (and ustr (ustr-former-seq ustr)))
         (former-seq (and (pair? former) (string-to-list (car former)))))
        (if ustr
          (or former-seq ())
          ;; im-acquire-text̤�б��Ķ��ξ�硢�����γ����ʸ����Хåե������
          (if tutcode-enable-fallback-surrounding-text?
            (let ((commit-strs (tutcode-context-commit-strs pc)))
              (if (> (length commit-strs) len)
                (take commit-strs len)
                commit-strs))
            ()))))))

;;; �����ʸ�����������
;;; @param len �������ʸ����
(define (tutcode-postfix-delete-text pc len)
  (let ((ppc (tutcode-context-parent-context pc)))
    (if (not (null? ppc))
      (if (eq? (tutcode-context-child-type ppc) 'tutcode-child-type-editor)
        (let*
          ((ec (tutcode-context-editor ppc))
           (left-string (tutcode-editor-left-string ec)))
          (tutcode-editor-set-left-string! ec
            (if (> (length left-string) len)
              (drop left-string len)
              ()))))
      (or
        (im-delete-text pc 'primary 'cursor len 0)
        ;; im-delete-text̤�б��Ķ��ξ�硢"\b"�����롣
        ;; XXX:"\b"��ǧ������ʸ���������륢�ץ�Ǥʤ���ư��ʤ�
        ;; (tutcode-commit-raw�����Ϻѥ����򤽤Τޤޥ��ץ���Ϥ����Ȥ���ꤹ��
        ;;  ��ΤʤΤǡ��ʲ��Τ褦��backspace�����Ǹ��������ˤϻȤ��ʤ�
        ;;  (tutcode-commit-raw pc 'backspace 0))
        (and tutcode-enable-fallback-surrounding-text?
          (begin
            (let ((commit-strs (tutcode-context-commit-strs pc)))
              (tutcode-context-set-commit-strs! pc
                (if (> (length commit-strs) len)
                  (drop commit-strs len)
                  ())))
            (if (> (string-length tutcode-fallback-backspace-string) 0)
              (tutcode-commit pc
                (tutcode-make-string
                  (make-list len tutcode-fallback-backspace-string))
                #t))))))))

;;; ľ�����Ͼ��֤ΤȤ��Υ������Ϥ�������롣
;;; @param c ����ƥ����ȥꥹ��
;;; @param key ���Ϥ��줿����
;;; @param key-state ����ȥ��륭�����ξ���
(define (tutcode-proc-state-off c key key-state)
  (let ((pc (tutcode-find-descendant-context c)))
    (if (tutcode-on-key? key key-state)
      (tutcode-context-set-state! pc 'tutcode-state-on)
      (tutcode-commit-raw pc key key-state))))

;;; �������ϥ⡼�ɻ��Υ������Ϥ�������롣
;;; @param c ����ƥ����ȥꥹ��
;;; @param key ���Ϥ��줿����
;;; @param key-state ����ȥ��륭�����ξ���
(define (tutcode-proc-state-kigou c key key-state)
  (let ((pc (tutcode-find-descendant-context c)))
    (cond
      ((and
        (tutcode-vi-escape-key? key key-state)
        tutcode-use-with-vi?)
       (tutcode-reset-candidate-window pc)
       (tutcode-context-set-state! pc 'tutcode-state-off)
       (tutcode-commit-raw pc key key-state)) ; ESC�����򥢥ץ�ˤ��Ϥ�
      ((tutcode-off-key? key key-state)
       (tutcode-reset-candidate-window pc)
       (tutcode-context-set-state! pc 'tutcode-state-off))
      ((tutcode-kigou-toggle-key? key key-state)
       (tutcode-reset-candidate-window pc)
       (tutcode-context-set-state! pc 'tutcode-state-on))
      ((tutcode-kigou2-toggle-key? key key-state)
       (tutcode-reset-candidate-window pc)
       (if (not (tutcode-kigou2-mode? pc))
         (tutcode-toggle-kigou2-mode pc))
       (tutcode-context-set-state! pc 'tutcode-state-on))
      ;; ���ڡ������������ѥ��ڡ������ϲ�ǽ�Ȥ��뤿�ᡢ
      ;; next-candidate-key?�Υ����å��������heading-label-char?������å�
      ((and (not (and (modifier-key-mask key-state)
                      (not (shift-key-mask key-state))))
            (tutcode-heading-label-char-for-kigou-mode? key))
        (tutcode-commit-by-label-key-for-kigou-mode pc (charcode->string key))
        (if (eq? (tutcode-context-candidate-window pc)
                 'tutcode-candidate-window-kigou)
          (im-select-candidate pc (tutcode-context-nth pc))))
      ((tutcode-next-candidate-key? key key-state)
        (tutcode-change-candidate-index pc 1))
      ((tutcode-prev-candidate-key? key key-state)
        (tutcode-change-candidate-index pc -1))
      ((tutcode-cancel-key? key key-state)
        (tutcode-reset-candidate-window pc)
        (tutcode-begin-kigou-mode pc))
      ((tutcode-next-page-key? key key-state)
        (tutcode-change-candidate-index pc
          tutcode-nr-candidate-max-for-kigou-mode))
      ((tutcode-prev-page-key? key key-state)
        (tutcode-change-candidate-index pc
          (- tutcode-nr-candidate-max-for-kigou-mode)))
      ((tutcode-commit-key? key key-state) ; return-key�ϥ��ץ���Ϥ�
        (tutcode-commit pc (tutcode-prepare-commit-string-for-kigou-mode pc)))
      ((or
        (symbol? key)
        (and
          (modifier-key-mask key-state)
          (not (shift-key-mask key-state))))
        (tutcode-commit-raw pc key key-state))
      (else
        (tutcode-commit-raw pc key key-state)))))

;;; �򤼽��Ѵ����ɤ����Ͼ��֤ΤȤ��Υ������Ϥ�������롣
;;; @param c ����ƥ����ȥꥹ��
;;; @param key ���Ϥ��줿����
;;; @param key-state ����ȥ��륭�����ξ���
(define (tutcode-proc-state-yomi c key key-state)
  (let*
    ((pc (tutcode-find-descendant-context c))
     (rkc (tutcode-context-rk-context pc))
     (head (tutcode-context-head pc))
     (kigou2-mode? (tutcode-kigou2-mode? pc))
     (res #f)
     ;; reset-candidate-window�ǥꥻ�åȤ����Τ���¸���Ƥ���
     (predicting?
      (eq? (tutcode-context-predicting pc) 'tutcode-predicting-prediction))
     ;; ͽ¬���ϸ���ɽ���Υڡ�����ư���ϡ�reset-candidate-window����������
     (prediction-keys-handled?
      (if predicting?
        (cond
          ((tutcode-next-page-key? key key-state)
            (tutcode-change-prediction-page pc #t)
            #t)
          ((tutcode-prev-page-key? key key-state)
            (tutcode-change-prediction-page pc #f)
            #t)
          (else
            #f))
        #f)))
    (if (not prediction-keys-handled?)
      (begin
        (tutcode-reset-candidate-window pc)
        (cond
          ((tutcode-off-key? key key-state)
           (tutcode-flush pc)
           (tutcode-context-set-state! pc 'tutcode-state-off))
          ((and (tutcode-kana-toggle-key? key key-state)
                (not (tutcode-context-latin-conv pc))
                (not kigou2-mode?))
           (rk-flush rkc)
           (tutcode-context-kana-toggle pc))
          ((tutcode-kigou2-toggle-key? key key-state)
           (rk-flush rkc)
           (tutcode-toggle-kigou2-mode pc))
          ((tutcode-backspace-key? key key-state)
           (if (> (length (rk-context-seq rkc)) 0)
            (rk-flush rkc)
            (if (> (length head) 0)
              (begin
                (tutcode-context-set-head! pc (cdr head))
                (if (and predicting? (> tutcode-prediction-start-char-count 0))
                  (tutcode-check-prediction pc #f))))))
          ((or
            (tutcode-commit-key? key key-state)
            (tutcode-return-key? key key-state))
           (tutcode-commit pc (tutcode-make-string head))
           (tutcode-flush pc))
          ((tutcode-cancel-key? key key-state)
           (tutcode-flush pc))
          ((tutcode-stroke-help-toggle-key? key key-state)
           (tutcode-toggle-stroke-help pc))
          ((and tutcode-use-prediction?
                (tutcode-begin-completion-key? key key-state))
           (rk-flush rkc)
           (if (not predicting?)
             (tutcode-check-prediction pc #t)))
          ;; �������1�Ĥξ�硢�Ѵ��弫ư���ꤵ���converting�⡼�ɤ�����ʤ�
          ;; �Τǡ����ξ��Ǥ�purge�Ǥ���褦�ˡ������ǥ����å�
          ((and (tutcode-purge-candidate-key? key key-state)
                (not (null? head))
                (not kigou2-mode?))
           ;; converting�⡼�ɤ˰ܹԤ��Ƥ���purge
           (tutcode-begin-conversion pc head () #f #f)
           (if (eq? (tutcode-context-state pc) 'tutcode-state-converting)
             (tutcode-proc-state-converting pc key key-state)))
          ((and (tutcode-register-candidate-key? key key-state)
                tutcode-use-recursive-learning?
                (not kigou2-mode?))
           (tutcode-context-set-state! pc 'tutcode-state-converting)
           (tutcode-setup-child-context pc 'tutcode-child-type-editor))
          ((tutcode-katakana-commit-key? key key-state)
            (tutcode-commit pc
              ;;XXX:���ʥ��ʺ��߻���ȿž(�����ʤ���)�䡢�֤��פ�̤�б�
              (ja-make-kana-str (ja-make-kana-str-list head)
                (if (tutcode-context-katakana-mode? pc)
                  ja-type-hiragana
                  ja-type-katakana)))
            (tutcode-flush pc))
          ((symbol? key)
           (tutcode-flush pc)
           (tutcode-proc-state-on pc key key-state))
          ((and
            (modifier-key-mask key-state)
            (not (shift-key-mask key-state)))
           ;; <Control>n���Ǥ��Ѵ�����?
           (if (tutcode-begin-conv-key? key key-state)
             (if (not (null? head))
               (tutcode-begin-conversion-with-inflection pc #t)
               (tutcode-flush pc))
             (begin
               (tutcode-flush pc)
               (tutcode-proc-state-on pc key key-state))))
          ;; ͽ¬���ϸ����ѥ�٥륭��?
          ((and predicting? (tutcode-heading-label-char-for-prediction? key))
            (tutcode-commit-by-label-key-for-prediction pc
              (charcode->string key) 'tutcode-predicting-prediction))
          ((tutcode-context-latin-conv pc)
           (if (tutcode-begin-conv-key? key key-state) ; space�����Ǥ��Ѵ�����?
             (if (not (null? head))
               (tutcode-begin-conversion-with-inflection pc #t)
               (tutcode-flush pc))
             (set! res (charcode->string key))))
          ((not (rk-expect-key? rkc (charcode->string key)))
           (if (> (length (rk-context-seq rkc)) 0)
             (rk-flush rkc)
             ;; space�����Ǥ��Ѵ�����?
             ;; (space�ϥ����������󥹤˴ޤޤ���礬����Τǡ�
             ;;  rk-expect��space��̵�����Ȥ����)
             ;; (trycode��space�ǻϤޤ륭���������󥹤�ȤäƤ����硢
             ;;  space���Ѵ����ϤϤǤ��ʤ��Τǡ�<Control>n����Ȥ�ɬ�פ���)
             (if (tutcode-begin-conv-key? key key-state)
               (if (not (null? head))
                 (tutcode-begin-conversion-with-inflection pc #t)
                 (tutcode-flush pc))
               (set! res (charcode->string key)))))
          (else
           (set! res (tutcode-push-key! pc (charcode->string key)))
           (cond
            ((eq? res 'tutcode-auto-help-redisplay)
              (tutcode-auto-help-redisplay pc)
              (set! res #f))
            ((eq? res 'tutcode-postfix-bushu-start)
              (set! res
                (and (>= (length head) 2)
                     (tutcode-bushu-convert (cadr head) (car head))))
              (if res
                (begin
                  (tutcode-context-set-head! pc (cddr head))
                  (tutcode-check-auto-help-window-begin pc (list res) ()))))
            ;; ���Ѥ��ʤ���Ȥ����Ѵ����ϡ����䤬1�Ĥξ��ϼ�ư����
            ((eq? res 'tutcode-postfix-mazegaki-start)
              (set! res #f)
              (if (not (null? head))
                (tutcode-begin-conversion-with-inflection pc #f)
                (begin
                  (tutcode-flush pc)
                  (tutcode-begin-postfix-mazegaki-conversion pc #f #f #f))))
            ;; ���Ѥ����Ȥ����Ѵ�����(postfix�ѥ����������󥹤�ή��)
            ((eq? res 'tutcode-postfix-mazegaki-inflection-start)
              (set! res #f)
              (if (not (null? head))
                (tutcode-begin-mazegaki-inflection-conversion pc)
                (begin
                  (tutcode-flush pc)
                  (tutcode-begin-postfix-mazegaki-inflection-conversion pc #f))))
            ((symbol? res)
              (set! res #f)))))
        (if res
          (begin
            (tutcode-append-string pc res)
            (if (and tutcode-use-prediction?
                     (> tutcode-prediction-start-char-count 0)
                     ;; ���ַ���������Ѵ��ˤ��auto-helpɽ���ѻ��ϲ��⤷�ʤ�
                     (eq? (tutcode-context-candidate-window pc)
                          'tutcode-candidate-window-off))
              (tutcode-check-prediction pc #f))))))))

;;; ��������Ѵ����������Ͼ��֤ΤȤ��Υ������Ϥ�������롣
;;; @param c ����ƥ����ȥꥹ��
;;; @param key ���Ϥ��줿����
;;; @param key-state ����ȥ��륭�����ξ���
(define (tutcode-proc-state-bushu c key key-state)
  (let*
    ((pc (tutcode-find-descendant-context c))
     (rkc (tutcode-context-rk-context pc))
     (res #f)
     (predicting?
      (eq? (tutcode-context-predicting pc) 'tutcode-predicting-bushu)))
    (tutcode-reset-candidate-window pc)
    (cond
      ((tutcode-off-key? key key-state)
       (tutcode-flush pc)
       (tutcode-context-set-state! pc 'tutcode-state-off))
      ((and (tutcode-kana-toggle-key? key key-state)
            (not (tutcode-kigou2-mode? pc)))
       (rk-flush rkc)
       (tutcode-context-kana-toggle pc))
      ((tutcode-kigou2-toggle-key? key key-state)
       (rk-flush rkc)
       (tutcode-toggle-kigou2-mode pc))
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
              (tutcode-commit pc res))
            (tutcode-flush pc)
            (if res (tutcode-check-auto-help-window-begin pc (list res) ()))
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
      ((tutcode-stroke-help-toggle-key? key key-state)
       (tutcode-toggle-stroke-help pc))
      ((and predicting? (tutcode-next-page-key? key key-state))
       (tutcode-change-bushu-prediction-page pc #t))
      ((and predicting? (tutcode-prev-page-key? key key-state))
       (tutcode-change-bushu-prediction-page pc #f))
      ((or
        (symbol? key)
        (and
          (modifier-key-mask key-state)
          (not (shift-key-mask key-state))))
       (tutcode-flush pc)
       (tutcode-proc-state-on pc key key-state))
      ;; ͽ¬���ϸ����ѥ�٥륭��?
      ((and predicting? (tutcode-heading-label-char-for-prediction? key))
        (tutcode-commit-by-label-key-for-prediction pc
          (charcode->string key) 'tutcode-predicting-bushu))
      ((not (rk-expect-key? rkc (charcode->string key)))
       (if (> (length (rk-context-seq rkc)) 0)
         (rk-flush rkc)
         (set! res (charcode->string key))))
      (else
       (set! res (tutcode-push-key! pc (charcode->string key)))
       (cond
        ((eq? res 'tutcode-bushu-start) ; �Ƶ�Ū����������Ѵ�
          (tutcode-append-string pc "��")
          (set! res #f))
        ((eq? res 'tutcode-auto-help-redisplay)
          (tutcode-auto-help-redisplay pc)
          (set! res #f))
        ((symbol? res) ;XXX ��������Ѵ���ϸ򤼽��Ѵ�����̵���ˤ���
          (set! res #f)))))
    (if res
      (tutcode-begin-bushu-conversion pc res))))

;;; ��������Ѵ�����
;;; @param char ���������Ϥ��줿ʸ��(2���ܤ�����)
(define (tutcode-begin-bushu-conversion pc char)
  (let ((prevchar (car (tutcode-context-head pc))))
    (if (string=? prevchar "��")
      (begin
        (tutcode-append-string pc char)
        (if tutcode-use-bushu-prediction?
          (tutcode-check-bushu-prediction pc char)))
      ;; ľ����ʸ������������ޡ����Ǥʤ���2ʸ���ܤ����Ϥ��줿���Ѵ�����
      (let ((convchar (tutcode-bushu-convert prevchar char)))
        (if (string? convchar)
          ;; ��������
          (tutcode-bushu-commit pc convchar)
          ;; �������Ի������Ϥ�ľ�����Ԥ�
          )))))

;;; ��������Ѵ����Ѵ�����ʸ������ꤹ��
;;; @param convchar �Ѵ����ʸ��
(define (tutcode-bushu-commit pc convchar)
  ;; 1���ܤ�����Ȣ���ä�
  (tutcode-context-set-head! pc (cddr (tutcode-context-head pc)))
  (if (null? (tutcode-context-head pc))
    ;; �Ѵ��Ԥ������󤬻ĤäƤʤ���С����ꤷ�ƽ�λ
    (begin
      (tutcode-commit pc convchar)
      (tutcode-flush pc)
      (tutcode-check-auto-help-window-begin pc (list convchar) ()))
    ;; ���󤬤ޤ��ĤäƤ�С��Ƴ�ǧ��
    ;; (��������ʸ����2ʸ���ܤʤ�С�Ϣ³������������Ѵ�)
    (tutcode-begin-bushu-conversion pc convchar)))

;;; ����Ū��������Ѵ��ΤȤ��Υ������Ϥ�������롣
;;; @param c ����ƥ����ȥꥹ��
;;; @param key ���Ϥ��줿����
;;; @param key-state ����ȥ��륭�����ξ���
(define (tutcode-proc-state-interactive-bushu c key key-state)
  (let*
    ((pc (tutcode-find-descendant-context c))
     (rkc (tutcode-context-rk-context pc))
     (head (tutcode-context-head pc))
     (res #f)
     (has-candidate? (> (tutcode-context-prediction-nr pc) 0))
     ;; ����ɽ���Υڡ�����ư���ϡ�reset-candidate-window����������
     (candidate-selection-keys-handled?
      (if has-candidate?
        (cond
          ((tutcode-next-page-key? key key-state)
            (tutcode-change-prediction-page pc #t)
            #t)
          ((tutcode-prev-page-key? key key-state)
            (tutcode-change-prediction-page pc #f)
            #t)
          ((and (tutcode-next-candidate-key? key key-state)
                ;; 2�Ǹ��ܤΥ��ڡ��������ξ��ϸ�������ǤϤʤ�
                (= (length (rk-context-seq rkc)) 0))
            (tutcode-change-prediction-index pc 1)
            #t)
          ((tutcode-prev-candidate-key? key key-state)
            (tutcode-change-prediction-index pc -1)
            #t)
          (else
            #f))
        #f)))
    (if (not candidate-selection-keys-handled?)
      (begin
        (tutcode-reset-candidate-window pc)
        (cond
          ((tutcode-off-key? key key-state)
           (tutcode-flush pc)
           (tutcode-context-set-state! pc 'tutcode-state-off))
          ((and (tutcode-kana-toggle-key? key key-state)
                (not (tutcode-kigou2-mode? pc)))
           (rk-flush rkc)
           (tutcode-context-kana-toggle pc))
          ((tutcode-kigou2-toggle-key? key key-state)
           (rk-flush rkc)
           (tutcode-toggle-kigou2-mode pc))
          ((tutcode-backspace-key? key key-state)
           (if (> (length (rk-context-seq rkc)) 0)
            (rk-flush rkc)
            (if (> (length head) 0)
              (begin
                (tutcode-context-set-head! pc (cdr head))
                (if has-candidate?
                  (tutcode-begin-interactive-bushu-conversion pc))))))
          ((or
            (tutcode-commit-key? key key-state)
            (tutcode-return-key? key key-state))
           (let ((str
                  (cond
                    (has-candidate?
                      (tutcode-get-prediction-string pc))
                    ((> (length head) 0)
                      (tutcode-make-string (tutcode-context-head pc)))
                    (else
                      #f))))
             (if str (tutcode-commit pc str))
             (tutcode-flush pc)
             (if str (tutcode-check-auto-help-window-begin pc (list str) ()))))
          ((tutcode-cancel-key? key key-state)
           (tutcode-flush pc))
          ((tutcode-stroke-help-toggle-key? key key-state)
           (tutcode-toggle-stroke-help pc))
          ((or
            (symbol? key)
            (and
              (modifier-key-mask key-state)
              (not (shift-key-mask key-state))))
           (tutcode-flush pc)
           (tutcode-proc-state-on pc key key-state))
          ((and (tutcode-heading-label-char-for-prediction? key)
                (= (length (rk-context-seq rkc)) 0))
            (tutcode-commit-by-label-key-for-prediction pc
              (charcode->string key) 'tutcode-predicting-interactive-bushu))
          ((not (rk-expect-key? rkc (charcode->string key)))
           (if (> (length (rk-context-seq rkc)) 0)
             (rk-flush rkc)
             (set! res (charcode->string key))))
          (else
           (set! res (tutcode-push-key! pc (charcode->string key)))
           (cond
            ((eq? res 'tutcode-auto-help-redisplay)
              (tutcode-auto-help-redisplay pc)
              (set! res #f))
            ((symbol? res) ;XXX ��������Ѵ���ϸ򤼽��Ѵ�����̵���ˤ���
              (set! res #f)))))
        (if res
          (begin
            (tutcode-append-string pc res)
            (tutcode-begin-interactive-bushu-conversion pc)))))))

;;; ����Ū��������Ѵ�����
(define (tutcode-begin-interactive-bushu-conversion pc)
  (let*
    ((head (tutcode-context-head pc))
     (res
      (if (null? head)
        ()
        (tutcode-bushu-compose-interactively (reverse head)))))
    (cond
      ;; BS������ʸ���������ä��줿��硢preedit�θ����ä�����nr��0��
      ((null? head)
        (tutcode-context-set-prediction-nr! pc 0)
        (tutcode-context-set-prediction-candidates! pc ()))
      ;; ����������ʸ����ä���������ǽ������������ʸ������
      ((null? res)
        (tutcode-context-set-head! pc (cdr (tutcode-context-head pc)))
        (if (> (tutcode-context-prediction-nr pc) 0)
          (begin
            (tutcode-context-set-candidate-window! pc
              'tutcode-candidate-window-interactive-bushu)
            (im-activate-candidate-selector pc
              (tutcode-context-prediction-nr-all pc)
              (tutcode-context-prediction-page-limit pc)))))
      (else
        (let ((nr (length res)))
          (tutcode-context-set-prediction-word! pc ())
          (tutcode-context-set-prediction-candidates! pc res)
          (tutcode-context-set-prediction-appendix! pc ())
          (tutcode-context-set-prediction-nr! pc nr)
          (tutcode-context-set-prediction-index! pc 0)
          (let*
            ((params (tutcode-prediction-calc-window-param nr 0))
             (nr-all (list-ref params 0)) ; �������
             (page-limit (list-ref params 1)) ; �ڡ���������
             (nr-in-page (list-ref params 2))) ; �ڡ���������
            (if (> page-limit 0)
              (begin
                ;; ͽ¬���ϸ������ѿ���ή��
                (tutcode-context-set-prediction-nr-in-page! pc nr-in-page)
                (tutcode-context-set-prediction-page-limit! pc page-limit)
                (tutcode-context-set-prediction-nr-all! pc nr-all)
                (tutcode-context-set-candidate-window! pc
                  'tutcode-candidate-window-interactive-bushu)
                (im-activate-candidate-selector pc nr-all page-limit)))))))))

;;; ��������������򤹤�
;;; @param pc ����ƥ����ȥꥹ��
;;; @param num ���ߤθ����ֹ椫�鿷�����ֹ�ޤǤΥ��ե��å�
(define (tutcode-change-candidate-index pc num)
  (let* ((nr (tutcode-context-nr-candidates pc))
         (nth (tutcode-context-nth pc))
         (new-nth (+ nth num)))
    (cond
      ((< new-nth 0)
       (set! new-nth 0))
      ((and tutcode-use-recursive-learning? (= nth (- nr 1)) (>= new-nth nr))
       (tutcode-reset-candidate-window pc)
       (tutcode-setup-child-context pc 'tutcode-child-type-editor))
      ((>= new-nth nr)
       (set! new-nth (- nr 1))))
    (tutcode-context-set-nth! pc new-nth))
  (if (null? (tutcode-context-child-context pc))
    (begin
      (tutcode-check-candidate-window-begin pc)
      (if (not (eq? (tutcode-context-candidate-window pc)
                    'tutcode-candidate-window-off))
        (im-select-candidate pc (tutcode-context-nth pc))))))

;;; �������䴰/ͽ¬���ϸ�������򤹤�
;;; @param num ���ߤθ����ֹ椫�鿷�����ֹ�ޤǤΥ��ե��å�
(define (tutcode-change-prediction-index pc num)
  (let* ((nr-all (tutcode-context-prediction-nr-all pc))
         (idx (tutcode-context-prediction-index pc))
         (n (+ idx num))
         (compensated-n
          (cond
           ((>= n nr-all) (- nr-all 1))
           ((< n 0) 0)
           (else n))))
    (tutcode-context-set-prediction-index! pc compensated-n)
    (im-select-candidate pc compensated-n)))

;;; ��/���ڡ������䴰/ͽ¬���ϸ����ɽ������
;;; @param next? #t:���ڡ���, #f:���ڡ���
(define (tutcode-change-prediction-page pc next?)
  (let ((page-limit (tutcode-context-prediction-page-limit pc)))
    (tutcode-change-prediction-index pc (if next? page-limit (- page-limit)))))

;;; ��/���ڡ�������������Ѵ���ͽ¬���ϸ����ɽ������
;;; @param next? #t:���ڡ���, #f:���ڡ���
(define (tutcode-change-bushu-prediction-page pc next?)
  (let* ((idx (tutcode-context-prediction-bushu-page-start pc))
         (n (+ idx
              (if next?
                tutcode-nr-candidate-max-for-prediction
                (- tutcode-nr-candidate-max-for-prediction)))))
    (tutcode-bushu-prediction-show-page pc n)))

;;; ���䥦����ɥ����Ĥ���
(define (tutcode-reset-candidate-window pc)
  (if (not (eq? (tutcode-context-candidate-window pc)
                'tutcode-candidate-window-off))
    (begin
      (im-deactivate-candidate-selector pc)
      (tutcode-context-set-candidate-window! pc 'tutcode-candidate-window-off)
      (tutcode-context-set-predicting! pc 'tutcode-predicting-off))))

;;; �򤼽��Ѵ��θ���������֤��顢�ɤ����Ͼ��֤��᤹��
;;; @param pc ����ƥ����ȥꥹ��
(define (tutcode-back-to-yomi-state pc)
  (if (> (tutcode-context-postfix-yomi-len pc) 0) ; ���ַ�?
    (tutcode-flush pc)
    (begin
      (tutcode-reset-candidate-window pc)
      (tutcode-context-set-state! pc 'tutcode-state-yomi)
      (tutcode-context-set-head! pc (tutcode-context-mazegaki-yomi-all pc))
      (tutcode-context-set-nr-candidates! pc 0))))

;;; �򤼽��Ѵ��μ�����Ͽ���֤��顢����������֤��᤹��
;;; @param pc ����ƥ����ȥꥹ��
(define (tutcode-back-to-converting-state pc)
  (tutcode-context-set-nth! pc (- (tutcode-context-nr-candidates pc) 1))
  (tutcode-check-candidate-window-begin pc)
  (if (eq? (tutcode-context-candidate-window pc)
           'tutcode-candidate-window-converting)
    (im-select-candidate pc (tutcode-context-nth pc)))
  (tutcode-context-set-state! pc 'tutcode-state-converting))

;;; ���Ϥ��줿�����������٥�ʸ�����ɤ�����Ĵ�٤�
;;; @param key ���Ϥ��줿����
(define (tutcode-heading-label-char? key)
  (member (charcode->string key) tutcode-heading-label-char-list))

;;; ���Ϥ��줿�������������ϥ⡼�ɻ��θ����٥�ʸ�����ɤ�����Ĵ�٤�
;;; @param key ���Ϥ��줿����
(define (tutcode-heading-label-char-for-kigou-mode? key)
  (member (charcode->string key) tutcode-heading-label-char-list-for-kigou-mode))

;;; ���Ϥ��줿�������䴰/ͽ¬���ϻ��θ����٥�ʸ�����ɤ�����Ĵ�٤�
;;; @param key ���Ϥ��줿����
(define (tutcode-heading-label-char-for-prediction? key)
  (member (charcode->string key) tutcode-heading-label-char-list-for-prediction))

;;; �򤼽��Ѵ��θ���������֤ΤȤ��Υ������Ϥ�������롣
;;; @param c ����ƥ����ȥꥹ��
;;; @param key ���Ϥ��줿����
;;; @param key-state ����ȥ��륭�����ξ���
(define (tutcode-proc-state-converting c key key-state)
  (let ((pc (tutcode-find-descendant-context c)))
    (cond
      ((tutcode-next-candidate-key? key key-state)
        (tutcode-change-candidate-index pc 1))
      ((tutcode-prev-candidate-key? key key-state)
        (tutcode-change-candidate-index pc -1))
      ((tutcode-cancel-key? key key-state)
        (tutcode-back-to-yomi-state pc))
      ((tutcode-next-page-key? key key-state)
        (tutcode-change-candidate-index pc tutcode-nr-candidate-max))
      ((tutcode-prev-page-key? key key-state)
        (tutcode-change-candidate-index pc (- tutcode-nr-candidate-max)))
      ((or (tutcode-commit-key? key key-state)
           (tutcode-return-key? key key-state))
        (tutcode-commit-with-auto-help pc))
      ((tutcode-purge-candidate-key? key key-state)
        (tutcode-reset-candidate-window pc)
        (tutcode-setup-child-context pc 'tutcode-child-type-dialog))
      ((and (tutcode-register-candidate-key? key key-state)
            tutcode-use-recursive-learning?)
        (tutcode-reset-candidate-window pc)
        (tutcode-setup-child-context pc 'tutcode-child-type-editor))
      ((tutcode-mazegaki-relimit-right-key? key key-state)
        (tutcode-mazegaki-proc-relimit-right pc))
      ((tutcode-mazegaki-relimit-left-key? key key-state)
        (tutcode-mazegaki-proc-relimit-left pc))
      ((and tutcode-commit-candidate-by-label-key?
            (> (tutcode-context-nr-candidates pc) 1)
            (tutcode-heading-label-char? key))
        (tutcode-commit-by-label-key pc (charcode->string key)))
      (else
        (let ((postfix-yomi-len (tutcode-context-postfix-yomi-len pc)))
          (if (> postfix-yomi-len 0)
            (tutcode-postfix-delete-text pc postfix-yomi-len)))
        (tutcode-commit pc (tutcode-prepare-commit-string pc))
        (tutcode-proc-state-on pc key key-state)))))

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
  (if (null? tutcode-reverse-bushudic-alist)
    (set! tutcode-reverse-bushudic-alist
      (map
        (lambda (elem)
          (cons (caadr elem) (caar elem)))
        tutcode-bushudic)))
  (let ((res (assoc c tutcode-reverse-bushudic-alist)))
    (and res
      (cdr res))))

;;; ��ư�إ��:�о�ʸ���������������Τ�ɬ�פȤʤ롢
;;; �����Ǥʤ�2�Ĥ�ʸ���Υꥹ�Ȥ��֤�
;;; ��: "��" => (((("," "o"))("��")) ((("f" "q"))("��")))
;;; @param c �о�ʸ��
;;; @param rule tutcode-rule
;;; @return �о�ʸ�������������ɬ�פ�2�Ĥ�ʸ���ȥ��ȥ����Υꥹ�ȡ�
;;;  ���Ĥ���ʤ��ä�����#f
(define (tutcode-auto-help-bushu-decompose c rule)
  (let*
    ((bushu (tutcode-bushu-decompose c))
     (b1 (and bushu (car bushu)))
     (b2 (and bushu (cadr bushu)))
     (seq1 (and b1 (tutcode-auto-help-get-stroke b1 rule)))
     (seq2 (and b2 (tutcode-auto-help-get-stroke b2 rule))))
    (or
      ;; ­�����ˤ�����
      (and seq1 seq2
        (list seq1 seq2))
      ;; ñ��ʰ������ˤ�����
      (tutcode-auto-help-bushu-decompose-by-subtraction c rule)
      ;; ���ʤˤ�����
      (or
        ;; ����1��ľ�����ϲ�ǽ
        ;; ��(����1)��(����2�����ʤȤ��ƻ��Ĵ���)�ˤ���������ǽ��?
        (and seq1 b2
          (tutcode-auto-help-bushu-decompose-looking-bushudic tutcode-bushudic
            () 99
            (lambda (elem)
              (tutcode-auto-help-get-stroke-list-with-right-part
                c b1 b2 seq1 rule elem))))
        ;; ����2��ľ�����ϲ�ǽ
        ;; ��(����2)��(����1�����ʤȤ��ƻ��Ĵ���)�ˤ���������ǽ��?
        (and seq2 b1
          (tutcode-auto-help-bushu-decompose-looking-bushudic tutcode-bushudic
            () 99
            (lambda (elem)
              (tutcode-auto-help-get-stroke-list-with-left-part
                c b1 b2 seq2 rule elem))))
        ;; XXX: ���ʤɤ����ι����䡢3ʸ���ʾ�Ǥι�����̤�б�
        ))))

;;; ��ư�إ��:�о�ʸ�������Ϥ���ݤ��Ǹ��Υꥹ�Ȥ�������롣
;;; ��: "��" => ((("," "o")) ("��"))
;;; @param b �о�ʸ��
;;; @param rule tutcode-rule
;;; @return �Ǹ��ꥹ�ȡ������Բ�ǽ�ʾ���#f
(define (tutcode-auto-help-get-stroke b rule)
  (let
    ((seq
      (or (tutcode-reverse-find-seq b rule)
          ;; ��������ǻȤ���"3"�Τ褦��ľ�����ϲ�ǽ��������б����뤿�ᡢ
          ;; ��٥�ʸ���˴ޤޤ�Ƥ���С�ľ�����ϲ�ǽ�Ȥߤʤ�
          (and
            (member b tutcode-heading-label-char-list-for-kigou-mode)
            (list b)))))
    (and seq
      (list (list seq) (list b)))))

;;; ��ư�إ��:���������������Ǥ��˸���
;;; �ǽ�˸��Ĥ��ä�2�Ǹ���������Ȥ߹�碌���֤���
;;; (filter��map��Ȥäơ��Ǿ��Υ��ȥ����Τ�Τ�õ���Ȼ��֤�������Τǡ�)
;;; ξ���Ȥ�2�Ǹ���������Ȥ߹�碌�����Ĥ���ʤ��ä��顢
;;; 3�Ǹ�������Ȥ��Ȥ߹�碌��������֤���
;;; @param long-stroke-result 3�Ǹ��ʾ��ʸ����ޤ���
;;; @param min-stroke long-stroke-result��θ��ߤκǾ��Ǹ���
;;; @param get-stroke-list ��������Ѥ�2�Ĥ�ʸ���ȥ��ȥ����Υꥹ�Ȥ��֤��ؿ�
;;; @return ��������Ѥ�2�Ĥ�ʸ���ȥ��ȥ����Υꥹ�ȡ�
;;;  ���Ĥ���ʤ��ä�����#f
(define (tutcode-auto-help-bushu-decompose-looking-bushudic bushudic
          long-stroke-result min-stroke get-stroke-list)
  (if (null? bushudic)
    (and
      (not (null? long-stroke-result))
      long-stroke-result)
    (let*
      ((res
        (get-stroke-list (list min-stroke (car bushudic))))
       (len (if (not res) 99 (tutcode-auto-help-count-stroke-length res)))
       (min (if (< len min-stroke) len min-stroke)))
      (if (<= len 4) ; "5"����Ȥ����������4�Ǹ�̤���⤢�뤬�������ޤǤϸ��ʤ�
        res
        (tutcode-auto-help-bushu-decompose-looking-bushudic (cdr bushudic)
          (if (< len min-stroke) res long-stroke-result)
          min get-stroke-list)))))

;;; ��ư�إ��:�о�ʸ����������ˤ�������������Τ�ɬ�פȤʤ롢
;;; �����Ǥʤ�ʸ���Υꥹ�Ȥ��֤���
;;; ��: "��" => (((("g" "t" "h")) ("��")) ((("G" "I")) ("��")))
;;;    (���Ȥʤ�tutcode-bushudic������Ǥ�((("��" "��")) ("��")))
;;; @param c �о�ʸ��
;;; @param rule tutcode-rule
;;; @return �о�ʸ�������������ɬ�פ�2�Ĥ�ʸ���ȥ��ȥ����Υꥹ�ȡ�
;;;  ���Ĥ���ʤ��ä�����#f
(define (tutcode-auto-help-bushu-decompose-by-subtraction c rule)
  (tutcode-auto-help-bushu-decompose-looking-bushudic tutcode-bushudic
    () 99
    (lambda (elem)
      (tutcode-auto-help-get-stroke-list-by-subtraction c rule elem))))

;;; ��ư�إ��:���������ɬ�פ��Ǹ����������
;;; @param bushu-compose-list ��������˻Ȥ�2ʸ���ȥ��ȥ����Υꥹ�ȡ�
;;;  ��: (((("g" "t" "h")) ("��")) ((("G" "I")) ("��")))
;;; @return bushu-compose-list�˴ޤޤ���Ǹ�����(�����ξ���5)
(define (tutcode-auto-help-count-stroke-length bushu-compose-list)
  (+ (length (caaar bushu-compose-list))
     (length (caaadr bushu-compose-list))))

;;; ��ư�إ��:�о�ʸ����������ˤ����������Ǥ�����ϡ�
;;; �����˻Ȥ���ʸ���ȡ����Υ��ȥ����Υꥹ�Ȥ��֤���
;;; @param c �о�ʸ��
;;; @param rule tutcode-rule
;;; @param min-stroke-bushu-list min-stroke��bushudic������ǤΥꥹ�ȡ�
;;;  ��: (6 ((("��" "��")) ("��")))
;;; @return �о�ʸ�������������ɬ�פ�2�Ĥ�ʸ���ȥ��ȥ����Υꥹ�ȡ�
;;;  bushu-list��Ȥäƹ����Ǥ��ʤ�����#f��
;;;  ��: (((("g" "t" "h")) ("��")) ((("G" "I")) ("��")))
(define (tutcode-auto-help-get-stroke-list-by-subtraction
          c rule min-stroke-bushu-list)
  (and-let*
    ((min-stroke (car min-stroke-bushu-list))
     (bushu-list (cadr min-stroke-bushu-list))
     (mem (member c (caar bushu-list)))
     (b1 (caadr bushu-list))
     ;; 2�Ĥ�����Τ�����c�ʳ�����������
     (b2 (if (= 2 (length mem)) (cadr mem) (car (caar bushu-list))))
     (seq1 (tutcode-auto-help-get-stroke b1 rule))
     (seq2 (tutcode-auto-help-get-stroke b2 rule))
     (ret (list seq1 seq2))
     ;; ����������٤��Τǡ�����Ǹ���������å�
     (small-stroke? (< (tutcode-auto-help-count-stroke-length ret) min-stroke))
     ;; �ºݤ�����������ơ��о�ʸ������������ʤ���Τ�����
     (composed (tutcode-bushu-convert b1 b2))
     (c-composed? (string=? composed c)))
    ret))

;;; ��ư�إ��:�о�ʸ���������1�פȡ�����2�����ʤȤ��ƻ��Ĵ����פˤ��
;;; ��������Ǥ�����ϡ�
;;; �����˻Ȥ���ʸ���ȡ����Υ��ȥ����Υꥹ�Ȥ��֤���
;;; @param c �о�ʸ��
;;; @param b1 ����1(ľ�����ϲ�ǽ)
;;; @param b2 ����2(ľ�������Բ�ǽ)
;;; @param seq1 b1�����ϥ����������󥹤�����Υꥹ��
;;; @param rule tutcode-rule
;;; @param min-stroke-bushu-list min-stroke��bushudic������ǤΥꥹ�ȡ�
;;; @return �о�ʸ�������������ɬ�פ�2�Ĥ�ʸ���ȥ��ȥ����Υꥹ�ȡ�
;;;  bushu-list��Ȥäƹ����Ǥ��ʤ�����#f��
(define (tutcode-auto-help-get-stroke-list-with-right-part
         c b1 b2 seq1 rule min-stroke-bushu-list)
  (and-let*
    ((min-stroke (car min-stroke-bushu-list))
     (bushu-list (cadr min-stroke-bushu-list))
     (mem (member b2 (caar bushu-list)))
     (kanji (caadr bushu-list)) ; ����2�����ʤȤ��ƻ��Ĵ���
     (seq (tutcode-auto-help-get-stroke kanji rule))
     (ret (list seq1 seq))
     ;; ����������٤��Τǡ�����Ǹ���������å�
     (small-stroke? (< (tutcode-auto-help-count-stroke-length ret) min-stroke))
     ;; �ºݤ�����������ơ��о�ʸ������������ʤ���Τ�����
     (composed (tutcode-bushu-convert b1 kanji))
     (c-composed? (string=? composed c)))
    ret))

;;; ��ư�إ��:�о�ʸ���������1�����ʤȤ��ƻ��Ĵ����פȡ�����2�פˤ��
;;; ��������Ǥ�����ϡ�
;;; �����˻Ȥ���ʸ���ȡ����Υ��ȥ����Υꥹ�Ȥ��֤���
;;; @param c �о�ʸ�� (��: "��")
;;; @param b1 ����1(ľ�������Բ�ǽ) (��: "�")
;;; @param b2 ����2(ľ�����ϲ�ǽ) (��: "��")
;;; @param seq2 b2�����ϥ����������󥹤�����Υꥹ�ȡ�
;;;  ��: ((("b" ",")) ("��"))
;;; @param rule tutcode-rule
;;; @param min-stroke-bushu-list min-stroke��bushudic������ǤΥꥹ�ȡ�
;;;  ��: (6 ((("��" "�")) ("��")))
;;; @return �о�ʸ�������������ɬ�פ�2�Ĥ�ʸ���ȥ��ȥ����Υꥹ�ȡ�
;;;  bushu-list��Ȥäƹ����Ǥ��ʤ�����#f��
;;;  ��: (((("e" "v" ".")) ("��")) ((("b" ",")) ("��")))
(define (tutcode-auto-help-get-stroke-list-with-left-part
         c b1 b2 seq2 rule min-stroke-bushu-list)
  (and-let*
    ((min-stroke (car min-stroke-bushu-list))
     (bushu-list (cadr min-stroke-bushu-list))
     (mem (member b1 (caar bushu-list)))
     (kanji (caadr bushu-list)) ; ����1�����ʤȤ��ƻ��Ĵ���
     (seq (tutcode-auto-help-get-stroke kanji rule))
     (ret (list seq seq2))
     ;; ����������٤��Τǡ�����Ǹ���������å�
     (small-stroke? (< (tutcode-auto-help-count-stroke-length ret) min-stroke))
     ;; �ºݤ�����������ơ��о�ʸ������������ʤ���Τ�����
     (composed (tutcode-bushu-convert kanji b2))
     (c-composed? (string=? composed c)))
    ret))

;;; ��������Ѵ�����ͽ¬���ϸ���򸡺�
;;; @param str ����1
;;; @param bushudic ��������ꥹ��
;;; @return (<����2> <����ʸ��>)�Υꥹ��
(define (tutcode-bushu-predict str bushudic)
  (let*
    ((rules (rk-lib-find-partial-seqs (list str) bushudic))
     (words1 (map (lambda (elem) (cadaar elem)) rules))
     (more-cands
      (filter
        (lambda (elem)
          (let
            ;; (((����1 ����2))(����ʸ��))
            ((bushu1 (caaar elem))
             (bushu2 (cadaar elem))
             (gosei (caadr elem)))
            (or
              ;; str��1ʸ���ܤξ���rk-lib-find-partial-seqs�Ǹ�����
              ;(string=? str bushu1) ; (((str ����2))(����ʸ��))
              (and (string=? str bushu2) ; (((����1 str))(����ʸ��))
                    ;; ���˾�ǽи��Ѥξ��Ͻ�����
                    ;; ��: ((("��" "��"))("��"))��"��"���и��Ѥξ�硢
                    ;;     ((("��" "��"))("��"))��"��"�Ͻ�����
                   (not (member bushu1 words1)))
              (string=? str gosei)))) ; (((����1 ����2))(str))
              ;; XXX:���ξ�硢str��bushu1��bushu2�������Ǥ��뤳�Ȥ�
              ;;     ��ǧ���٤�������tutcode-bushu-convert���٤��ΤǾ�ά��
          bushudic))
     (res (append rules more-cands))
     (word/cand
      (map
       (lambda (elem)
        (let
         ((bushu1 (caaar elem))
          (bushu2 (cadaar elem))
          (gosei (caadr elem)))
         (cond
          ((string=? str bushu1) ; (((str ����2))(����ʸ��))
           (list bushu2 gosei))
          ((string=? str bushu2) ; (((����1 str))(����ʸ��))
           (list bushu1 gosei))
          ((string=? str gosei) ; (((����1 ����2))(str))
           (list bushu1 bushu2)))))
       res)))
    word/cand))

;;; tutcode-rule��հ������ơ��Ѵ����ʸ�����顢���ϥ������������롣
;;; ��: (tutcode-reverse-find-seq "��" tutcode-rule) => ("r" "k")
;;; @param c �Ѵ����ʸ��
;;; @param rule tutcode-rule
;;; @return ���ϥ����Υꥹ�ȡ�tutcode-rule���c�����Ĥ���ʤ��ä�����#f
(define (tutcode-reverse-find-seq c rule)
  (let*
    ((make-reverse-rule-alist
      (lambda (r)
        (map
          (lambda (elem)
            (cons (caadr elem) (caar elem)))
          r)))
     (alist
      (if (eq? rule tutcode-kigou-rule)
        (begin
          (if (null? tutcode-reverse-kigou-rule-alist)
            (set! tutcode-reverse-kigou-rule-alist
              (make-reverse-rule-alist rule)))
          tutcode-reverse-kigou-rule-alist)
        (begin
          (if (null? tutcode-reverse-rule-alist)
            (set! tutcode-reverse-rule-alist
              (make-reverse-rule-alist rule)))
          tutcode-reverse-rule-alist)))
     (res (assoc c alist)))
    (and res
      (cdr res))))

;;; ���ߤ�state��preedit����Ĥ��ɤ������֤���
;;; @param pc ����ƥ����ȥꥹ��
(define (tutcode-state-has-preedit? pc)
  (or
    (not (null? (tutcode-context-child-context pc)))
    (memq (tutcode-context-state pc)
      '(tutcode-state-yomi tutcode-state-bushu tutcode-state-converting
        tutcode-state-interactive-bushu tutcode-state-kigou))))

;;; �����������줿�Ȥ��ν����ο���ʬ����Ԥ���
;;; @param c ����ƥ����ȥꥹ��
;;; @param key ���Ϥ��줿����
;;; @param key-state ����ȥ��륭�����ξ���
(define (tutcode-key-press-handler c key key-state)
  (if (ichar-control? key)
      (im-commit-raw c)
      (let ((pc (tutcode-find-descendant-context c)))
        (case (tutcode-context-state pc)
          ((tutcode-state-on)
           (tutcode-proc-state-on pc key key-state)
           (if (or
                 ;; �򤼽��Ѵ�����������Ѵ����ϡ����䢥��ɽ������
                 (tutcode-state-has-preedit? c)
                 ;; ʸ����������ַ��򤼽��Ѵ��κƵ��ؽ�����󥻥�
                 (not (eq? (tutcode-find-descendant-context c) pc)))
             (tutcode-update-preedit pc)))
          ((tutcode-state-kigou)
           (tutcode-proc-state-kigou pc key key-state)
           (tutcode-update-preedit pc))
          ((tutcode-state-yomi)
           (tutcode-proc-state-yomi pc key key-state)
           (tutcode-update-preedit pc))
          ((tutcode-state-converting)
           (tutcode-proc-state-converting pc key key-state)
           (tutcode-update-preedit pc))
          ((tutcode-state-bushu)
           (tutcode-proc-state-bushu pc key key-state)
           (tutcode-update-preedit pc))
          ((tutcode-state-interactive-bushu)
           (tutcode-proc-state-interactive-bushu pc key key-state)
           (tutcode-update-preedit pc))
          (else
           (tutcode-proc-state-off pc key key-state)
           (if (tutcode-state-has-preedit? c) ; �Ƶ��ؽ���
             (tutcode-update-preedit pc))))
        (if tutcode-use-stroke-help-window?
          ;; editor�κ���������β�ǽ��������Τ�descendant-context������ľ��
          (let ((newpc (tutcode-find-descendant-context c)))
            (if
              (and
                (memq (tutcode-context-state newpc)
                  '(tutcode-state-on tutcode-state-yomi tutcode-state-bushu
                    tutcode-state-interactive-bushu))
                (not (tutcode-context-latin-conv newpc)))
              (tutcode-check-stroke-help-window-begin newpc)))))))

;;; ������Υ���줿�Ȥ��ν�����Ԥ���
;;; @param pc ����ƥ����ȥꥹ��
;;; @param key ���Ϥ��줿����
;;; @param key-state ����ȥ��륭�����ξ���
(define (tutcode-key-release-handler pc key key-state)
  (if (or (ichar-control? key)
	  (not (tutcode-context-on? pc)))
      ;; don't discard key release event for apps
      (im-commit-raw pc)))

;;; TUT-Code IM�ν������Ԥ���
(define (tutcode-init-handler id im arg)
  (let ((tc (tutcode-context-new id im)))
    (set! tutcode-context-list (cons tc tutcode-context-list))
    tc))

(define (tutcode-release-handler tc)
  (tutcode-save-personal-dictionary #f)
  (set! tutcode-context-list (delete! tc tutcode-context-list))
  (if (null? tutcode-context-list)
    (begin
      (skk-lib-free-dic tutcode-dic)
      (set! tutcode-dic #f))))

(define (tutcode-reset-handler tc)
  (tutcode-flush tc))

(define (tutcode-focus-in-handler tc) #f)

(define (tutcode-focus-out-handler c)
  (let* ((tc (tutcode-find-descendant-context c))
         (rkc (tutcode-context-rk-context tc)))
    (rk-flush rkc)))

(define tutcode-place-handler tutcode-focus-in-handler)
(define tutcode-displace-handler tutcode-focus-out-handler)

;;; ���䥦����ɥ�������ʸ�����������뤿��˸Ƥִؿ�
(define (tutcode-get-candidate-handler c idx accel-enum-hint)
  (let ((tc (tutcode-find-descendant-context c)))
    (cond
      ((= accel-enum-hint 9999) ;XXX ɽ�������䥦����ɥ������display_limitĴ����
        (set! tutcode-nr-candidate-max (length tutcode-heading-label-char-list))
        (set! tutcode-nr-candidate-max-for-kigou-mode
          (length tutcode-heading-label-char-list-for-kigou-mode))
        (set! tutcode-nr-candidate-max-for-prediction
          (length tutcode-heading-label-char-list-for-prediction))
        (set! tutcode-nr-candidate-max-for-guide
          (- tutcode-nr-candidate-max-for-kigou-mode
             tutcode-nr-candidate-max-for-prediction))
        (list "" ""
          (string-append "display_limit="
            (number->string
              (cond
                ((eq? (tutcode-context-state tc) 'tutcode-state-kigou)
                  tutcode-nr-candidate-max-for-kigou-mode)
                ((eq? (tutcode-context-state tc)
                      'tutcode-state-interactive-bushu)
                  (tutcode-context-prediction-page-limit tc))
                ((not (eq? (tutcode-context-predicting tc)
                           'tutcode-predicting-off))
                  (tutcode-context-prediction-page-limit tc))
                (else
                  tutcode-nr-candidate-max))))))
      ;; ��������
      ((eq? (tutcode-context-state tc) 'tutcode-state-kigou)
        (let* ((cand (tutcode-get-nth-candidate-for-kigou-mode tc idx))
               (n (remainder idx
                    (length tutcode-heading-label-char-list-for-kigou-mode)))
               (label (nth n tutcode-heading-label-char-list-for-kigou-mode)))
          ;; XXX:annotationɽ���ϸ���̵��������Ƥ���Τǡ����""���֤��Ƥ���
          (list cand label "")))
      ;; �䴰/ͽ¬���ϸ���
      ((not (eq? (tutcode-context-predicting tc) 'tutcode-predicting-off))
        (let*
          ((nr-in-page (tutcode-context-prediction-nr-in-page tc))
           (page-limit (tutcode-context-prediction-page-limit tc))
           (pages (quotient idx page-limit))
           (idx-in-page (remainder idx page-limit)))
          ;; �ƥڡ����ˤϡ�nr-in-page�Ĥ��䴰/ͽ¬���ϸ���ȡ��ϸ쥬���ɤ�ɽ��
          (if (< idx-in-page nr-in-page)
            ;; �䴰/ͽ¬���ϸ���ʸ����
            (let*
              ((nr-predictions (tutcode-lib-get-nr-predictions tc))
               (p-idx (+ idx-in-page (* pages nr-in-page)))
               (i (remainder p-idx nr-predictions))
               (cand (tutcode-lib-get-nth-prediction tc i))
               (cand-guide
                (if (eq? (tutcode-context-predicting tc)
                          'tutcode-predicting-bushu)
                  (string-append
                    cand "(" (tutcode-lib-get-nth-word tc i) ")")
                  cand))
               (n (remainder p-idx
                    (length tutcode-heading-label-char-list-for-prediction)))
               (label (nth n tutcode-heading-label-char-list-for-prediction)))
              (list cand-guide label ""))
            ;; �ϸ쥬����
            (let*
              ((guide (tutcode-context-guide tc))
               (guide-len (length guide)))
              (if (= guide-len 0)
                (list "" "" "")
                (let*
                  ((guide-idx-in-page (- idx-in-page nr-in-page))
                   (nr-guide-in-page (- page-limit nr-in-page))
                   (guide-idx (+ guide-idx-in-page (* pages nr-guide-in-page)))
                   (n (remainder guide-idx guide-len))
                   (label-cands-alist (nth n guide))
                   (label (car label-cands-alist))
                   (cands (cdr label-cands-alist))
                   (cand
                    (tutcode-make-string
                      (append cands (list tutcode-guide-mark)))))
                  (list cand label "")))))))
      ;; ���۸���
      ((eq? (tutcode-context-candidate-window tc)
            'tutcode-candidate-window-stroke-help)
        (nth idx (tutcode-context-stroke-help tc)))
      ;; ��ư�إ��
      ((eq? (tutcode-context-candidate-window tc)
            'tutcode-candidate-window-auto-help)
        (nth idx (tutcode-context-auto-help tc)))
      ;; ����Ū��������Ѵ�
      ((eq? (tutcode-context-state tc) 'tutcode-state-interactive-bushu)
        (let*
          ;; ͽ¬���ϸ������ѿ���ή��
          ((nr-in-page (tutcode-context-prediction-nr-in-page tc))
           (page-limit (tutcode-context-prediction-page-limit tc))
           (pages (quotient idx page-limit))
           (idx-in-page (remainder idx page-limit))
           (nr-predictions (tutcode-lib-get-nr-predictions tc))
           (p-idx (+ idx-in-page (* pages nr-in-page)))
           (i (remainder p-idx nr-predictions))
           (cand (tutcode-lib-get-nth-prediction tc i))
           (n (remainder p-idx
                (length tutcode-heading-label-char-list-for-prediction)))
           (label (nth n tutcode-heading-label-char-list-for-prediction)))
          (list cand label "")))
      ;; �򤼽��Ѵ�
      (else
        (let* ((cand (tutcode-get-nth-candidate tc idx))
               (n (remainder idx (length tutcode-heading-label-char-list)))
               (label (nth n tutcode-heading-label-char-list)))
          (list cand label ""))))))

;;; ���䥦����ɥ�����������򤷤��Ȥ��˸Ƥִؿ���
;;; ���򤵤줿�������ꤹ�롣
(define (tutcode-set-candidate-index-handler c idx)
  (let* ((pc (tutcode-find-descendant-context c))
         (candwin (tutcode-context-candidate-window pc)))
    (cond
      ((and (or (eq? candwin 'tutcode-candidate-window-converting)
                (eq? candwin 'tutcode-candidate-window-kigou))
          (>= idx 0)
          (< idx (tutcode-context-nr-candidates pc)))
        (tutcode-context-set-nth! pc idx)
        (if (eq? (tutcode-context-state pc) 'tutcode-state-kigou)
          (tutcode-commit pc (tutcode-prepare-commit-string-for-kigou-mode pc))
          (tutcode-commit-with-auto-help pc))
        (tutcode-update-preedit pc))
      ((and (or (eq? candwin 'tutcode-candidate-window-predicting)
                (eq? candwin 'tutcode-candidate-window-interactive-bushu))
            (>= idx 0))
        (let*
          ((nr-in-page (tutcode-context-prediction-nr-in-page pc))
           (page-limit (tutcode-context-prediction-page-limit pc))
           (idx-in-page (remainder idx page-limit)))
          (if (< idx-in-page nr-in-page)
            (let*
              ((nr-predictions (tutcode-lib-get-nr-predictions pc))
               (pages (quotient idx page-limit))
               (p-idx (+ idx-in-page (* pages nr-in-page)))
               (i (remainder p-idx nr-predictions))
               (mode (tutcode-context-predicting pc)))
              (tutcode-context-set-prediction-index! pc i)
              (if (eq? candwin 'tutcode-candidate-window-interactive-bushu)
                (tutcode-do-commit-prediction-for-interactive-bushu pc)
                (if (eq? mode 'tutcode-predicting-bushu)
                  (tutcode-do-commit-prediction-for-bushu pc)
                  (tutcode-do-commit-prediction pc
                    (eq? mode 'tutcode-predicting-completion))))
              (tutcode-update-preedit pc))))))))

(tutcode-configure-widgets)

;;; TUT-Code IM����Ͽ���롣
(register-im
 'tutcode
 "ja"
 "EUC-JP"
 tutcode-im-name-label
 tutcode-im-short-desc
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

;;; ������ɽ���Ѵ����롣
;;; @param from �Ѵ��оݥ�����ɽ
;;; @param translate-alist �Ѵ�ɽ
;;; @return �Ѵ�����������ɽ
(define (tutcode-rule-translate from translate-alist)
  (map
    (lambda (elem)
      (cons
        (list
          (map
            (lambda (key)
              (let ((res (assoc key translate-alist)))
                (if res
                  (cadr res)
                  key)))
            (caar elem)))
        (cdr elem)))
    from))

;;; ������ɽ��Qwerty����Dvorak�Ѥ��Ѵ����롣
;;; @param qwerty Qwerty�Υ�����ɽ
;;; @return Dvorak���Ѵ�����������ɽ
(define (tutcode-rule-qwerty-to-dvorak qwerty)
  (tutcode-rule-translate qwerty tutcode-rule-qwerty-to-dvorak-alist))

;;; ������ɽ��Qwerty-jis����Qwerty-us�Ѥ��Ѵ����롣
;;; @param jis Qwerty-jis�Υ�����ɽ
;;; @return Qwerty-us���Ѵ�����������ɽ
(define (tutcode-rule-qwerty-jis-to-qwerty-us jis)
  (tutcode-rule-translate jis tutcode-rule-qwerty-jis-to-qwerty-us-alist))

;;; kigou-rule�򥭡��ܡ��ɥ쥤�����Ȥ˹�碌���Ѵ�����
;;; @param layout tutcode-candidate-window-table-layout
(define (tutcode-kigou-rule-translate layout)
  (let
    ((translate-stroke-help-alist
      (lambda (lis translate-alist)
        (map
          (lambda (elem)
            (cons
              (let ((res (assoc (car elem) translate-alist)))
                (if res
                  (cadr res)
                  (car elem)))
              (cdr elem)))
          lis))))
    (case layout
      ((qwerty-us)
        (set! tutcode-kigou-rule
          (tutcode-rule-qwerty-jis-to-qwerty-us
            (tutcode-kigou-rule-pre-translate
              tutcode-rule-qwerty-jis-to-qwerty-us-alist)))
        (set! tutcode-kigou-rule-stroke-help-top-page-alist
          (translate-stroke-help-alist 
            tutcode-kigou-rule-stroke-help-top-page-alist
            tutcode-rule-qwerty-jis-to-qwerty-us-alist)))
      ((dvorak)
        (set! tutcode-kigou-rule
          (tutcode-rule-qwerty-to-dvorak
            (tutcode-kigou-rule-pre-translate
              tutcode-rule-qwerty-to-dvorak-alist)))
        (set! tutcode-kigou-rule-stroke-help-top-page-alist
          (translate-stroke-help-alist 
            tutcode-kigou-rule-stroke-help-top-page-alist
            tutcode-rule-qwerty-to-dvorak-alist))))))

;;; Qwerty-jis����Qwerty-us�ؤ��Ѵ��ơ��֥롣
(define tutcode-rule-qwerty-jis-to-qwerty-us-alist
  '(
    ("^" "=")
    ("@" "[")
    ("[" "]")
    (":" "'")
    ("]" "`")
    ("\"" "@")
    ("'" "&")
    ("&" "^")
    ("(" "*")
    (")" "(")
    ("|" ")") ;tutcode-kigou-rule�ѡ�<Shift>0��qwerty-jis�Ǥ�|�����Ѥ��Ƥ�Τ�
    ("=" "_")
    ("~" "+")
    ("_" "|") ;XXX
    ("`" "{")
    ("{" "}")
    ("+" ":")
    ("*" "\"")
    ("}" "~")))

;;; Qwerty����Dvorak�ؤ��Ѵ��ơ��֥롣
(define tutcode-rule-qwerty-to-dvorak-alist
  '(
    ;("1" "1")
    ;("2" "2")
    ;("3" "3")
    ;("4" "4")
    ;("5" "5")
    ;("6" "6")
    ;("7" "7")
    ;("8" "8")
    ;("9" "9")
    ;("0" "0")
    ("-" "[")
    ("^" "]") ;106
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
    ("@" "/") ;106
    ("[" "=") ;106
    ;("a" "a")
    ("s" "o")
    ("d" "e")
    ("f" "u")
    ("g" "i")
    ("h" "d")
    ("j" "h")
    ("k" "t")
    ("l" "n")
    (";" "s")
    (":" "-") ;106
    ("]" "`")
    ("z" ";")
    ("x" "q")
    ("c" "j")
    ("v" "k")
    ("b" "x")
    ("n" "b")
    ;("m" "m")
    ("," "w")
    ("." "v")
    ("/" "z")
    ;(" " " ")
    ;; shift
    ;("!" "!")
    ("\"" "@") ;106
    ;("#" "#")
    ;("$" "$")
    ;("%" "%")
    ("&" "^") ;106
    ("'" "&") ;106
    ("(" "*") ;106
    (")" "(") ;106
    ("=" "{") ;106
    ("~" "}") ;106
    ("|" ")") ;tutcode-kigou-rule�ѡ�<Shift>0��qwerty-jis�Ǥ�|�����Ѥ��Ƥ�Τ�
    ("_" "|") ;XXX
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
    ("`" "?") ;106
    ("{" "+") ;106
    ;("A" "A")
    ("S" "O")
    ("D" "E")
    ("F" "U")
    ("G" "I")
    ("H" "D")
    ("J" "H")
    ("K" "T")
    ("L" "N")
    ("+" "S") ;106
    ("*" "_") ;106
    ("}" "~")
    ("Z" ":")
    ("X" "Q")
    ("C" "J")
    ("V" "K")
    ("B" "X")
    ("N" "B")
    ;("M" "M")
    ("<" "W")
    (">" "V")
    ("?" "Z")
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
  (let
    ((make-subrule
      (lambda (keyseq cmd)
        (and keyseq
             (> (string-length keyseq) 0))
          (let ((keys (reverse (string-to-list keyseq))))
            (list (list keys) cmd)))))
    (tutcode-rule-set-sequences!
      (filter
        pair?
        (list
          (make-subrule tutcode-mazegaki-start-sequence
            '(tutcode-mazegaki-start))
          (make-subrule tutcode-latin-conv-start-sequence
            '(tutcode-latin-conv-start))
          (make-subrule tutcode-bushu-start-sequence
            '(tutcode-bushu-start))
          (and
            tutcode-use-interactive-bushu-conversion?
            (make-subrule tutcode-interactive-bushu-start-sequence
              '(tutcode-interactive-bushu-start)))
          (make-subrule tutcode-postfix-bushu-start-sequence
            '(tutcode-postfix-bushu-start))
          (make-subrule tutcode-postfix-mazegaki-start-sequence
            '(tutcode-postfix-mazegaki-start))
          (make-subrule tutcode-postfix-mazegaki-1-start-sequence
            '(tutcode-postfix-mazegaki-1-start))
          (make-subrule tutcode-postfix-mazegaki-2-start-sequence
            '(tutcode-postfix-mazegaki-2-start))
          (make-subrule tutcode-postfix-mazegaki-3-start-sequence
            '(tutcode-postfix-mazegaki-3-start))
          (make-subrule tutcode-postfix-mazegaki-4-start-sequence
            '(tutcode-postfix-mazegaki-4-start))
          (make-subrule tutcode-postfix-mazegaki-5-start-sequence
            '(tutcode-postfix-mazegaki-5-start))
          (make-subrule tutcode-postfix-mazegaki-6-start-sequence
            '(tutcode-postfix-mazegaki-6-start))
          (make-subrule tutcode-postfix-mazegaki-7-start-sequence
            '(tutcode-postfix-mazegaki-7-start))
          (make-subrule tutcode-postfix-mazegaki-8-start-sequence
            '(tutcode-postfix-mazegaki-8-start))
          (make-subrule tutcode-postfix-mazegaki-9-start-sequence
            '(tutcode-postfix-mazegaki-9-start))
          (make-subrule tutcode-postfix-mazegaki-inflection-start-sequence
            '(tutcode-postfix-mazegaki-inflection-start))
          (make-subrule tutcode-postfix-mazegaki-inflection-1-start-sequence
            '(tutcode-postfix-mazegaki-inflection-1-start))
          (make-subrule tutcode-postfix-mazegaki-inflection-2-start-sequence
            '(tutcode-postfix-mazegaki-inflection-2-start))
          (make-subrule tutcode-postfix-mazegaki-inflection-3-start-sequence
            '(tutcode-postfix-mazegaki-inflection-3-start))
          (make-subrule tutcode-postfix-mazegaki-inflection-4-start-sequence
            '(tutcode-postfix-mazegaki-inflection-4-start))
          (make-subrule tutcode-postfix-mazegaki-inflection-5-start-sequence
            '(tutcode-postfix-mazegaki-inflection-5-start))
          (make-subrule tutcode-postfix-mazegaki-inflection-6-start-sequence
            '(tutcode-postfix-mazegaki-inflection-6-start))
          (make-subrule tutcode-postfix-mazegaki-inflection-7-start-sequence
            '(tutcode-postfix-mazegaki-inflection-7-start))
          (make-subrule tutcode-postfix-mazegaki-inflection-8-start-sequence
            '(tutcode-postfix-mazegaki-inflection-8-start))
          (make-subrule tutcode-postfix-mazegaki-inflection-9-start-sequence
            '(tutcode-postfix-mazegaki-inflection-9-start))
          (make-subrule tutcode-auto-help-redisplay-sequence
            '(tutcode-auto-help-redisplay)))))))

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
  (let* ((newseqs ()) ;�����ɲä��륭����������
         ;; ������ɽ��λ��ꥷ�����󥹤����Ϥ����ʸ�����ѹ����롣
         ;; seq ������������
         ;; kanji ���Ϥ����ʸ����car���Ҥ餬�ʥ⡼���ѡ�cadr���������ʥ⡼����
         (setseq1!
          (lambda (elem)
            (let* ((seq (caar elem))
                   (kanji (cadr elem))
                   (curseq (rk-lib-find-seq seq tutcode-rule))
                   (pair (and curseq (cadr curseq))))
              (if (and pair (pair? pair))
                (begin
                  (set-car! pair (car kanji))
                  (if (not (null? (cdr kanji)))
                    (if (< (length pair) 2)
                      (set-cdr! pair (list (cadr kanji)))
                      (set-car! (cdr pair) (cadr kanji)))))
                (begin
                  ;; ������ɽ��˻��ꤵ�줿�����������󥹤������̵��
                  (set! newseqs (append newseqs (list elem)))))))))
    (for-each setseq1! rules)
    ;; �����ɲå�������
    (if (not (null? newseqs))
      (set! tutcode-rule (append tutcode-rule newseqs)))))
