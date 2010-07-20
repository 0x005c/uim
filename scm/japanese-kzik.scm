;;;
;;; Copyright (c) 2003-2008 uim Project http://code.google.com/p/uim/
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

(define ja-kzik-rule-basic
  '(

    (((":"). ())("��" "��" "��"))
    (((";"). ())("��" "��" "��"))
    ((("b" "d"). ())(("��" "��" "�͎�") ("��" "��" "��")))
    ((("b" "g" "a"). ())(("��" "��" "�ˎ�") ("��" "��" "��")))
    ((("b" "g" "d"). ())(("��" "��" "�ˎ�") ("��" "��" "��") ("��" "��" "��")))
    ((("b" "g" "e"). ())(("��" "��" "�ˎ�") ("��" "��" "��")))
    ((("b" "g" "h"). ())(("��" "��" "�ˎ�") ("��" "��" "��") ("��" "��" "��")))
    ((("b" "g" "j"). ())(("��" "��" "�ˎ�") ("��" "��" "��") ("��" "��" "��")))
    ((("b" "g" "l"). ())(("��" "��" "�ˎ�") ("��" "��" "��") ("��" "��" "��")))
    ((("b" "g" "n"). ())(("��" "��" "�ˎ�") ("��" "��" "��") ("��" "��" "��")))
    ((("b" "g" "o"). ())(("��" "��" "�ˎ�") ("��" "��" "��")))
    ((("b" "g" "p"). ())(("��" "��" "�ˎ�") ("��" "��" "��") ("��" "��" "��")))
    ((("b" "g" "q"). ())(("��" "��" "�ˎ�") ("��" "��" "��") ("��" "��" "��")))
    ((("b" "g" "u"). ())(("��" "��" "�ˎ�") ("��" "��" "��")))
    ((("b" "g" "w"). ())(("��" "��" "�ˎ�") ("��" "��" "��") ("��" "��" "��")))
    ((("b" "g" "z"). ())(("��" "��" "�ˎ�") ("��" "��" "��") ("��" "��" "��")))
    ((("b" "h"). ())(("��" "��" "�̎�") ("��" "��" "��")))
    ((("b" "j"). ())(("��" "��" "�̎�") ("��" "��" "��")))
    ((("b" "k"). ())(("��" "��" "�ˎ�") ("��" "��" "��")))
    ((("b" "l"). ())(("��" "��" "�Ύ�") ("��" "��" "��")))
    ((("b" "n"). ())(("��" "��" "�ʎ�") ("��" "��" "��")))
    ((("b" "p"). ())(("��" "��" "�Ύ�") ("��" "��" "��")))
    ((("b" "q"). ())(("��" "��" "�ʎ�") ("��" "��" "��")))
    ((("b" "t"). ())(("��" "��" "�ˎ�") ("��" "��" "��")))
    ((("b" "w"). ())(("��" "��" "�͎�") ("��" "��" "��")))
    ((("b" "y" "d"). ())(("��" "��" "�ˎ�") ("��" "��" "��") ("��" "��" "��")))
    ((("b" "y" "h"). ())(("��" "��" "�ˎ�") ("��" "��" "��") ("��" "��" "��")))
    ((("b" "y" "j"). ())(("��" "��" "�ˎ�") ("��" "��" "��") ("��" "��" "��")))
    ((("b" "y" "l"). ())(("��" "��" "�ˎ�") ("��" "��" "��") ("��" "��" "��")))
    ((("b" "y" "n"). ())(("��" "��" "�ˎ�") ("��" "��" "��") ("��" "��" "��")))
    ((("b" "y" "p"). ())(("��" "��" "�ˎ�") ("��" "��" "��") ("��" "��" "��")))
    ((("b" "y" "q"). ())(("��" "��" "�ˎ�") ("��" "��" "��") ("��" "��" "��")))
    ((("b" "y" "w"). ())(("��" "��" "�ˎ�") ("��" "��" "��") ("��" "��" "��")))
    ((("b" "y" "z"). ())(("��" "��" "�ˎ�") ("��" "��" "��") ("��" "��" "��")))
    ((("b" "z"). ())(("��" "��" "�ʎ�") ("��" "��" "��")))
    ((("c" "a"). ())(("��" "��" "��") ("��" "��" "��")))
    ((("c" "d"). ())(("��" "��" "��") ("��" "��" "��") ("��" "��" "��")))
    ((("c" "e"). ())(("��" "��" "��") ("��" "��" "��")))
    ((("c" "h"). ())(("��" "��" "��") ("��" "��" "��") ("��" "��" "��")))
    ((("c" "j"). ())(("��" "��" "��") ("��" "��" "��") ("��" "��" "��")))
    ((("c" "l"). ())(("��" "��" "��") ("��" "��" "��") ("��" "��" "��")))
    ((("c" "n"). ())(("��" "��" "��") ("��" "��" "��") ("��" "��" "��")))
    ((("c" "o"). ())(("��" "��" "��") ("��" "��" "��")))
    ((("c" "p"). ())(("��" "��" "��") ("��" "��" "��") ("��" "��" "��")))
    ((("c" "q"). ())(("��" "��" "��") ("��" "��" "��") ("��" "��" "��")))
    ((("c" "u"). ())(("��" "��" "��") ("��" "��" "��")))
    ((("c" "w"). ())(("��" "��" "��") ("��" "��" "��") ("��" "��" "��")))
    ((("c" "y" "a"). ())(("��" "��" "��") ("��" "��" "��")))
    ((("c" "y" "e"). ())(("��" "��" "��") ("��" "��" "��")))
    ((("c" "y" "i"). ())(("��" "��" "��") ("��" "��" "��")))
    ((("c" "y" "o"). ())(("��" "��" "��") ("��" "��" "��")))
    ((("c" "y" "u"). ())(("��" "��" "��") ("��" "��" "��")))
    ((("c" "z"). ())(("��" "��" "��") ("��" "��" "��") ("��" "��" "��")))
    ((("d" "c" "i"). ())(("��" "��" "�Î�") ("��" "��" "��")))
    ((("d" "c" "u"). ())(("��" "��" "�Ď�") ("��" "��" "��")))
    ((("d" "d"). ())(("��" "��" "�Î�") ("��" "��" "��")))
    ((("d" "f"). ())("��" "��" "�Î�"))
    ((("d" "h"). ())(("��" "��" "��") ("��" "��" "��")))
    ((("d" "j"). ())(("��" "��" "��") ("��" "��" "��")))
    ((("d" "k"). ())(("��" "��" "����") ("��" "��" "��")))
    ((("d" "l"). ())(("��" "��" "�Ď�") ("��" "��" "��")))
    ((("d" "m"). ())(("��" "��" "�Î�") ("��" "��" "��")))
    ((("d" "n"). ())(("��" "��" "����") ("��" "��" "��")))
    ((("d" "p"). ())(("��" "��" "�Ď�") ("��" "��" "��")))
    ((("d" "q"). ())(("��" "��" "����") ("��" "��" "��")))
    ((("d" "s"). ())(("��" "��" "�Î�") ("��" "��" "��")))
    ((("d" "t"). ())(("��" "��" "����") ("��" "��" "��")))
    ((("d" "w"). ())(("��" "��" "�Î�") ("��" "��" "��")))
    ((("d" "z"). ())(("��" "��" "����") ("��" "��" "��")))
    ((("f" "d"). ())(("��" "��" "��") ("��" "��" "��") ("��" "��" "��")))
    ((("f" "h"). ())(("��" "��" "��") ("��" "��" "��")))
    ((("f" "j"). ())(("��" "��" "��") ("��" "��" "��")))
    ((("f" "k"). ())(("��" "��" "��") ("��" "��" "��") ("��" "��" "��")))
    ((("f" "l"). ())(("��" "��" "��") ("��" "��" "��") ("��" "��" "��")))
    ((("f" "n"). ())(("��" "��" "��") ("��" "��" "��") ("��" "��" "��")))
    ((("f" "p"). ())(("��" "��" "��") ("��" "��" "��") ("��" "��" "��")))
    ((("f" "q"). ())(("��" "��" "��") ("��" "��" "��") ("��" "��" "��")))
    ((("f" "w"). ())(("��" "��" "��") ("��" "��" "��") ("��" "��" "��")))
    ((("f" "z"). ())(("��" "��" "��") ("��" "��" "��") ("��" "��" "��")))
    ((("g" "d"). ())(("��" "��" "����") ("��" "��" "��")))
    ((("g" "g" "a"). ())(("��" "��" "����") ("��" "��" "��")))
    ((("g" "g" "u"). ())(("��" "��" "����") ("��" "��" "��")))
    ((("g" "g" "e"). ())(("��" "��" "����") ("��" "��" "��")))
    ((("g" "g" "o"). ())(("��" "��" "����") ("��" "��" "��")))
    ((("g" "g" "z"). ())(("��" "��" "����") ("��" "��" "��") ("��" "��" "��")))
    ((("g" "g" "n"). ())(("��" "��" "����") ("��" "��" "��") ("��" "��" "��")))
    ((("g" "g" "j"). ())(("��" "��" "����") ("��" "��" "��") ("��" "��" "��")))
    ((("g" "g" "d"). ())(("��" "��" "����") ("��" "��" "��") ("��" "��" "��")))
    ((("g" "g" "l"). ())(("��" "��" "����") ("��" "��" "��") ("��" "��" "��")))
    ((("g" "g" "q"). ())(("��" "��" "����") ("��" "��" "��") ("��" "��" "��")))
    ((("g" "g" "h"). ())(("��" "��" "����") ("��" "��" "��") ("��" "��" "��")))
    ((("g" "g" "w"). ())(("��" "��" "����") ("��" "��" "��") ("��" "��" "��")))
    ((("g" "g" "p"). ())(("��" "��" "����") ("��" "��" "��") ("��" "��" "��")))
    ((("g" "h"). ())(("��" "��" "����") ("��" "��" "��")))
    ((("g" "j"). ())(("��" "��" "����") ("��" "��" "��")))
    ((("g" "k"). ())(("��" "��" "����") ("��" "��" "��")))
    ((("g" "l"). ())(("��" "��" "����") ("��" "��" "��")))
    ((("g" "n"). ())(("��" "��" "����") ("��" "��" "��")))
    ((("g" "p"). ())(("��" "��" "����") ("��" "��" "��")))
    ((("g" "q"). ())(("��" "��" "����") ("��" "��" "��")))
    ((("g" "r"). ())(("��" "��" "����") ("��" "��" "��")))
    ((("g" "t"). ())(("��" "��" "����") ("��" "��" "��")))
    ((("g" "w"). ())(("��" "��" "����") ("��" "��" "��")))
    ((("g" "w" "a"). ())(("��" "��" "����") ("��" "��" "��")))
    ((("g" "w" "e"). ())(("��" "��" "����") ("��" "��" "��")))
    ((("g" "w" "i"). ())(("��" "��" "����") ("��" "��" "��")))
    ((("g" "w" "o"). ())(("��" "��" "����") ("��" "��" "��")))
    ((("g" "w" "u"). ())(("��" "��" "����") ("��" "��" "��")))
    ((("g" "y" "d"). ())(("��" "��" "����") ("��" "��" "��") ("��" "��" "��")))
    ((("g" "y" "h"). ())(("��" "��" "����") ("��" "��" "��") ("��" "��" "��")))
    ((("g" "y" "j"). ())(("��" "��" "����") ("��" "��" "��") ("��" "��" "��")))
    ((("g" "y" "l"). ())(("��" "��" "����") ("��" "��" "��") ("��" "��" "��")))
    ((("g" "y" "n"). ())(("��" "��" "����") ("��" "��" "��") ("��" "��" "��")))
    ((("g" "y" "p"). ())(("��" "��" "����") ("��" "��" "��") ("��" "��" "��")))
    ((("g" "y" "q"). ())(("��" "��" "����") ("��" "��" "��") ("��" "��" "��")))
    ((("g" "y" "w"). ())(("��" "��" "����") ("��" "��" "��") ("��" "��" "��")))
    ((("g" "y" "z"). ())(("��" "��" "����") ("��" "��" "��") ("��" "��" "��")))
    ((("g" "z"). ())(("��" "��" "����") ("��" "��" "��")))
    ((("h" "d"). ())(("��" "��" "��") ("��" "��" "��")))
    ((("h" "g" "a"). ())(("��" "��" "��") ("��" "��" "��")))
    ((("h" "g" "d"). ())(("��" "��" "��") ("��" "��" "��") ("��" "��" "��")))
    ((("h" "g" "e"). ())(("��" "��" "��") ("��" "��" "��")))
    ((("h" "g" "h"). ())(("��" "��" "��") ("��" "��" "��") ("��" "��" "��")))
    ((("h" "g" "j"). ())(("��" "��" "��") ("��" "��" "��") ("��" "��" "��")))
    ((("h" "g" "l"). ())(("��" "��" "��") ("��" "��" "��") ("��" "��" "��")))
    ((("h" "g" "n"). ())(("��" "��" "��") ("��" "��" "��") ("��" "��" "��")))
    ((("h" "g" "o"). ())(("��" "��" "��") ("��" "��" "��")))
    ((("h" "g" "p"). ())(("��" "��" "��") ("��" "��" "��") ("��" "��" "��")))
    ((("h" "g" "q"). ())(("��" "��" "��") ("��" "��" "��") ("��" "��" "��")))
    ((("h" "g" "u"). ())(("��" "��" "��") ("��" "��" "��")))
    ((("h" "g" "w"). ())(("��" "��" "��") ("��" "��" "��") ("��" "��" "��")))
    ((("h" "g" "z"). ())(("��" "��" "��") ("��" "��" "��") ("��" "��" "��")))
    ((("h" "h"). ())(("��" "��" "��") ("��" "��" "��")))
    ((("h" "j"). ())(("��" "��" "��") ("��" "��" "��")))
    ((("h" "k"). ())(("��" "��" "��") ("��" "��" "��")))
    ((("h" "l"). ())(("��" "��" "��") ("��" "��" "��")))
    ((("h" "n"). ())(("��" "��" "��") ("��" "��" "��")))
    ((("h" "p"). ())(("��" "��" "��") ("��" "��" "��")))
    ((("h" "q"). ())(("��" "��" "��") ("��" "��" "��")))
    ((("h" "t"). ())(("��" "��" "��") ("��" "��" "��")))
    ((("h" "w"). ())(("��" "��" "��") ("��" "��" "��")))
    ((("h" "y" "d"). ())(("��" "��" "��") ("��" "��" "��") ("��" "��" "��")))
    ((("h" "y" "h"). ())(("��" "��" "��") ("��" "��" "��") ("��" "��" "��")))
    ((("h" "y" "j"). ())(("��" "��" "��") ("��" "��" "��") ("��" "��" "��")))
    ((("h" "y" "l"). ())(("��" "��" "��") ("��" "��" "��") ("��" "��" "��")))
    ((("h" "y" "n"). ())(("��" "��" "��") ("��" "��" "��") ("��" "��" "��")))
    ((("h" "y" "p"). ())(("��" "��" "��") ("��" "��" "��") ("��" "��" "��")))
    ((("h" "y" "q"). ())(("��" "��" "��") ("��" "��" "��") ("��" "��" "��")))
    ((("h" "y" "w"). ())(("��" "��" "��") ("��" "��" "��") ("��" "��" "��")))
    ((("h" "y" "z"). ())(("��" "��" "��") ("��" "��" "��") ("��" "��" "��")))
    ((("h" "z"). ())(("��" "��" "��") ("��" "��" "��")))
    ((("j" "d"). ())(("��" "��" "����") ("��" "��" "��") ("��" "��" "��")))
    ((("j" "f"). ())(("��" "��" "����") ("��" "��" "��")))
    ((("j" "h"). ())(("��" "��" "����") ("��" "��" "��") ("��" "��" "��")))
    ((("j" "j"). ())(("��" "��" "����") ("��" "��" "��") ("��" "��" "��")))
    ((("j" "k"). ())(("��" "��" "����") ("��" "��" "��")))
    ((("j" "l"). ())(("��" "��" "����") ("��" "��" "��") ("��" "��" "��")))
    ((("j" "n"). ())(("��" "��" "����") ("��" "��" "��") ("��" "��" "��")))
    ((("j" "p"). ())(("��" "��" "����") ("��" "��" "��") ("��" "��" "��")))
    ((("j" "q"). ())(("��" "��" "����") ("��" "��" "��") ("��" "��" "��")))
    ((("j" "w"). ())(("��" "��" "����") ("��" "��" "��") ("��" "��" "��")))
    ((("j" "y" "a"). ())(("��" "��" "����") ("��" "��" "��")))
    ((("j" "y" "e"). ())(("��" "��" "����") ("��" "��" "��")))
    ((("j" "y" "i"). ())(("��" "��" "����") ("��" "��" "��")))
    ((("j" "y" "o"). ())(("��" "��" "����") ("��" "��" "��")))
    ((("j" "y" "u"). ())(("��" "��" "����") ("��" "��" "��")))
    ((("j" "z"). ())(("��" "��" "����") ("��" "��" "��") ("��" "��" "��")))
    ((("k" "d"). ())(("��" "��" "��") ("��" "��" "��")))
    ((("k" "f"). ())("��" "��" "��"))
    ((("k" "g" "a"). ())(("��" "��" "��") ("��" "��" "��")))
    ((("k" "g" "d"). ())(("��" "��" "��") ("��" "��" "��") ("��" "��" "��")))
    ((("k" "g" "e"). ())(("��" "��" "��") ("��" "��" "��")))
    ((("k" "g" "h"). ())(("��" "��" "��") ("��" "��" "��") ("��" "��" "��")))
    ((("k" "g" "j"). ())(("��" "��" "��") ("��" "��" "��") ("��" "��" "��")))
    ((("k" "g" "l"). ())(("��" "��" "��") ("��" "��" "��") ("��" "��" "��")))
    ((("k" "g" "n"). ())(("��" "��" "��") ("��" "��" "��") ("��" "��" "��")))
    ((("k" "g" "o"). ())(("��" "��" "��") ("��" "��" "��")))
    ((("k" "g" "p"). ())(("��" "��" "��") ("��" "��" "��") ("��" "��" "��")))
    ((("k" "g" "q"). ())(("��" "��" "��") ("��" "��" "��") ("��" "��" "��")))
    ((("k" "g" "u"). ())(("��" "��" "��") ("��" "��" "��")))
    ((("k" "g" "w"). ())(("��" "��" "��") ("��" "��" "��") ("��" "��" "��")))
    ((("k" "g" "z"). ())(("��" "��" "��") ("��" "��" "��") ("��" "��" "��")))
    ((("k" "h"). ())(("��" "��" "��") ("��" "��" "��")))
    ((("k" "j"). ())(("��" "��" "��") ("��" "��" "��")))
    ((("k" "k"). ())(("��" "��" "��") ("��" "��" "��")))
    ((("k" "l"). ())(("��" "��" "��") ("��" "��" "��")))
    ((("k" "m"). ())(("��" "��" "��") ("��" "��" "��")))
    ((("k" "n"). ())(("��" "��" "��") ("��" "��" "��")))
    ((("k" "p"). ())(("��" "��" "��") ("��" "��" "��")))
    ((("k" "q"). ())(("��" "��" "��") ("��" "��" "��")))
    ((("k" "r"). ())(("��" "��" "��") ("��" "��" "��")))
    ((("k" "t"). ())(("��" "��" "��") ("��" "��" "��")))
    ((("k" "w"). ())(("��" "��" "��") ("��" "��" "��")))
    ((("k" "y" "d"). ())(("��" "��" "��") ("��" "��" "��") ("��" "��" "��")))
    ((("k" "y" "h"). ())(("��" "��" "��") ("��" "��" "��") ("��" "��" "��")))
    ((("k" "y" "j"). ())(("��" "��" "��") ("��" "��" "��") ("��" "��" "��")))
    ((("k" "y" "l"). ())(("��" "��" "��") ("��" "��" "��") ("��" "��" "��")))
    ((("k" "y" "n"). ())(("��" "��" "��") ("��" "��" "��") ("��" "��" "��")))
    ((("k" "y" "p"). ())(("��" "��" "��") ("��" "��" "��") ("��" "��" "��")))
    ((("k" "y" "q"). ())(("��" "��" "��") ("��" "��" "��") ("��" "��" "��")))
    ((("k" "y" "w"). ())(("��" "��" "��") ("��" "��" "��") ("��" "��" "��")))
    ((("k" "y" "z"). ())(("��" "��" "��") ("��" "��" "��") ("��" "��" "��")))
    ((("k" "z"). ())(("��" "��" "��") ("��" "��" "��")))
    ((("l" "a"). ())("��" "��" "��"))
    ((("l" "e"). ())("��" "��" "��"))
    ((("l" "i"). ())("��" "��" "��"))
    ((("l" "o"). ())("��" "��" "��"))
    ((("l" "u"). ())("��" "��" "��"))
    ((("l" "y" "a"). ())("��" "��" "��"))
    ((("l" "y" "e"). ())(("��" "��" "��") ("��" "��" "��")))
    ((("l" "y" "i"). ())(("��" "��" "��") ("��" "��" "��")))
    ((("l" "y" "o"). ())("��" "��" "��"))
    ((("l" "y" "u"). ())("��" "��" "��"))
    ((("m" "d"). ())(("��" "��" "��") ("��" "��" "��")))
    ((("m" "g" "a"). ())(("��" "��" "��") ("��" "��" "��")))
    ((("m" "g" "d"). ())(("��" "��" "��") ("��" "��" "��") ("��" "��" "��")))
    ((("m" "g" "e"). ())(("��" "��" "��") ("��" "��" "��")))
    ((("m" "g" "h"). ())(("��" "��" "��") ("��" "��" "��") ("��" "��" "��")))
    ((("m" "g" "j"). ())(("��" "��" "��") ("��" "��" "��") ("��" "��" "��")))
    ((("m" "g" "l"). ())(("��" "��" "��") ("��" "��" "��") ("��" "��" "��")))
    ((("m" "g" "n"). ())(("��" "��" "��") ("��" "��" "��") ("��" "��" "��")))
    ((("m" "g" "o"). ())(("��" "��" "��") ("��" "��" "��")))
    ((("m" "g" "p"). ())(("��" "��" "��") ("��" "��" "��") ("��" "��" "��")))
    ((("m" "g" "q"). ())(("��" "��" "��") ("��" "��" "��") ("��" "��" "��")))
    ((("m" "g" "u"). ())(("��" "��" "��") ("��" "��" "��")))
    ((("m" "g" "w"). ())(("��" "��" "��") ("��" "��" "��") ("��" "��" "��")))
    ((("m" "g" "z"). ())(("��" "��" "��") ("��" "��" "��") ("��" "��" "��")))
    ((("m" "f"). ())("��" "��" "��"))
    ((("m" "h"). ())(("��" "��" "��") ("��" "��" "��")))
    ((("m" "j"). ())(("��" "��" "��") ("��" "��" "��")))
    ((("m" "k"). ())(("��" "��" "��") ("��" "��" "��")))
    ((("m" "l"). ())(("��" "��" "��") ("��" "��" "��")))
    ((("m" "n"). ())(("��" "��" "��") ("��" "��" "��")))
    ((("m" "p"). ())(("��" "��" "��") ("��" "��" "��")))
    ((("m" "q"). ())(("��" "��" "��") ("��" "��" "��")))
    ((("m" "s"). ())(("��" "��" "��") ("��" "��" "��")))
    ((("m" "t"). ())(("��" "��" "��") ("��" "��" "��")))
    ((("m" "w"). ())(("��" "��" "��") ("��" "��" "��")))
    ((("m" "y" "d"). ())(("��" "��" "��") ("��" "��" "��") ("��" "��" "��")))
    ((("m" "y" "h"). ())(("��" "��" "��") ("��" "��" "��") ("��" "��" "��")))
    ((("m" "y" "j"). ())(("��" "��" "��") ("��" "��" "��") ("��" "��" "��")))
    ((("m" "y" "l"). ())(("��" "��" "��") ("��" "��" "��") ("��" "��" "��")))
    ((("m" "y" "n"). ())(("��" "��" "��") ("��" "��" "��") ("��" "��" "��")))
    ((("m" "y" "p"). ())(("��" "��" "��") ("��" "��" "��") ("��" "��" "��")))
    ((("m" "y" "q"). ())(("��" "��" "��") ("��" "��" "��") ("��" "��" "��")))
    ((("m" "y" "w"). ())(("��" "��" "��") ("��" "��" "��") ("��" "��" "��")))
    ((("m" "y" "z"). ())(("��" "��" "��") ("��" "��" "��") ("��" "��" "��")))
    ((("m" "z"). ())(("��" "��" "��") ("��" "��" "��")))
    ((("n"). ())("��" "��" "��"))
    ((("n" "b"). ())(("��" "��" "��") ("��" "��" "�ʎ�")))
    ((("n" "d"). ())(("��" "��" "��") ("��" "��" "��")))
    ((("n" "f"). ())("��" "��" "��"))
    ((("n" "g" "a"). ())(("��" "��" "��") ("��" "��" "��")))
    ((("n" "g" "d"). ())(("��" "��" "��") ("��" "��" "��") ("��" "��" "��")))
    ((("n" "g" "e"). ())(("��" "��" "��") ("��" "��" "��")))
    ((("n" "g" "h"). ())(("��" "��" "��") ("��" "��" "��") ("��" "��" "��")))
    ((("n" "g" "j"). ())(("��" "��" "��") ("��" "��" "��") ("��" "��" "��")))
    ((("n" "g" "l"). ())(("��" "��" "��") ("��" "��" "��") ("��" "��" "��")))
    ((("n" "g" "n"). ())(("��" "��" "��") ("��" "��" "��") ("��" "��" "��")))
    ((("n" "g" "o"). ())(("��" "��" "��") ("��" "��" "��")))
    ((("n" "g" "p"). ())(("��" "��" "��") ("��" "��" "��") ("��" "��" "��")))
    ((("n" "g" "q"). ())(("��" "��" "��") ("��" "��" "��") ("��" "��" "��")))
    ((("n" "g" "u"). ())(("��" "��" "��") ("��" "��" "��")))
    ((("n" "g" "w"). ())(("��" "��" "��") ("��" "��" "��") ("��" "��" "��")))
    ((("n" "g" "z"). ())(("��" "��" "��") ("��" "��" "��") ("��" "��" "��")))
    ((("n" "h"). ())(("��" "��" "��") ("��" "��" "��")))
    ((("n" "j"). ())(("��" "��" "��") ("��" "��" "��")))
    ((("n" "k"). ())(("��" "��" "��") ("��" "��" "��")))
    ((("n" "l"). ())(("��" "��" "��") ("��" "��" "��")))
    ((("n" "p"). ())(("��" "��" "��") ("��" "��" "��")))
    ((("n" "q"). ())(("��" "��" "��") ("��" "��" "��")))
    ((("n" "r"). ())(("��" "��" "��") ("��" "��" "��")))
    ((("n" "t"). ())(("��" "��" "��") ("��" "��" "��")))
    ((("n" "w"). ())(("��" "��" "��") ("��" "��" "��")))
    ((("n" "y" "d"). ())(("��" "��" "��") ("��" "��" "��") ("��" "��" "��")))
    ((("n" "y" "h"). ())(("��" "��" "��") ("��" "��" "��") ("��" "��" "��")))
    ((("n" "y" "j"). ())(("��" "��" "��") ("��" "��" "��") ("��" "��" "��")))
    ((("n" "y" "l"). ())(("��" "��" "��") ("��" "��" "��") ("��" "��" "��")))
    ((("n" "y" "n"). ())(("��" "��" "��") ("��" "��" "��") ("��" "��" "��")))
    ((("n" "y" "p"). ())(("��" "��" "��") ("��" "��" "��") ("��" "��" "��")))
    ((("n" "y" "q"). ())(("��" "��" "��") ("��" "��" "��") ("��" "��" "��")))
    ((("n" "y" "w"). ())(("��" "��" "��") ("��" "��" "��") ("��" "��" "��")))
    ((("n" "y" "z"). ())(("��" "��" "��") ("��" "��" "��") ("��" "��" "��")))
    ((("n" "z"). ())(("��" "��" "��") ("��" "��" "��")))
    ((("p" "d"). ())(("��" "��" "�͎�") ("��" "��" "��")))
    ((("p" "g" "a"). ())(("��" "��" "�ˎ�") ("��" "��" "��")))
    ((("p" "g" "d"). ())(("��" "��" "�ˎ�") ("��" "��" "��") ("��" "��" "��")))
    ((("p" "g" "e"). ())(("��" "��" "�ˎ�") ("��" "��" "��")))
    ((("p" "g" "h"). ())(("��" "��" "�ˎ�") ("��" "��" "��") ("��" "��" "��")))
    ((("p" "g" "j"). ())(("��" "��" "�ˎ�") ("��" "��" "��") ("��" "��" "��")))
    ((("p" "g" "l"). ())(("��" "��" "�ˎ�") ("��" "��" "��") ("��" "��" "��")))
    ((("p" "g" "n"). ())(("��" "��" "�ˎ�") ("��" "��" "��") ("��" "��" "��")))
    ((("p" "g" "o"). ())(("��" "��" "�ˎ�") ("��" "��" "��")))
    ((("p" "g" "p"). ())(("��" "��" "�ˎ�") ("��" "��" "��") ("��" "��" "��")))
    ((("p" "g" "q"). ())(("��" "��" "�ˎ�") ("��" "��" "��") ("��" "��" "��")))
    ((("p" "g" "u"). ())(("��" "��" "�ˎ�") ("��" "��" "��")))
    ((("p" "g" "w"). ())(("��" "��" "�ˎ�") ("��" "��" "��") ("��" "��" "��")))
    ((("p" "g" "z"). ())(("��" "��" "�ˎ�") ("��" "��" "��") ("��" "��" "��")))
    ((("p" "h"). ())(("��" "��" "�̎�") ("��" "��" "��")))
    ((("p" "j"). ())(("��" "��" "�̎�") ("��" "��" "��")))
    ((("p" "k"). ())(("��" "��" "�ˎ�") ("��" "��" "��")))
    ((("p" "l"). ())(("��" "��" "�Ύ�") ("��" "��" "��")))
    ((("p" "n"). ())(("��" "��" "�ʎ�") ("��" "��" "��")))
    ((("p" "p"). ())(("��" "��" "�Ύ�") ("��" "��" "��")))
    ((("p" "q"). ())(("��" "��" "�ʎ�") ("��" "��" "��")))
    ((("p" "w"). ())(("��" "��" "�͎�") ("��" "��" "��")))
    ((("p" "y" "d"). ())(("��" "��" "�ˎ�") ("��" "��" "��") ("��" "��" "��")))
    ((("p" "y" "h"). ())(("��" "��" "�ˎ�") ("��" "��" "��") ("��" "��" "��")))
    ((("p" "y" "j"). ())(("��" "��" "�ˎ�") ("��" "��" "��") ("��" "��" "��")))
    ((("p" "y" "l"). ())(("��" "��" "�ˎ�") ("��" "��" "��") ("��" "��" "��")))
    ((("p" "y" "n"). ())(("��" "��" "�ˎ�") ("��" "��" "��") ("��" "��" "��")))
    ((("p" "y" "p"). ())(("��" "��" "�ˎ�") ("��" "��" "��") ("��" "��" "��")))
    ((("p" "y" "q"). ())(("��" "��" "�ˎ�") ("��" "��" "��") ("��" "��" "��")))
    ((("p" "y" "w"). ())(("��" "��" "�ˎ�") ("��" "��" "��") ("��" "��" "��")))
    ((("p" "y" "z"). ())(("��" "��" "�ˎ�") ("��" "��" "��") ("��" "��" "��")))
    ((("p" "z"). ())(("��" "��" "�ʎ�") ("��" "��" "��")))
    ((("q"). ())("��" "��" "��"))
    ((("r" "d"). ())(("��" "��" "��") ("��" "��" "��")))
    ((("r" "g" "a"). ())(("��" "��" "��") ("��" "��" "��")))
    ((("r" "g" "d"). ())(("��" "��" "��") ("��" "��" "��") ("��" "��" "��")))
    ((("r" "g" "e"). ())(("��" "��" "��") ("��" "��" "��")))
    ((("r" "g" "h"). ())(("��" "��" "��") ("��" "��" "��") ("��" "��" "��")))
    ((("r" "g" "j"). ())(("��" "��" "��") ("��" "��" "��") ("��" "��" "��")))
    ((("r" "g" "l"). ())(("��" "��" "��") ("��" "��" "��") ("��" "��" "��")))
    ((("r" "g" "n"). ())(("��" "��" "��") ("��" "��" "��") ("��" "��" "��")))
    ((("r" "g" "o"). ())(("��" "��" "��") ("��" "��" "��")))
    ((("r" "g" "p"). ())(("��" "��" "��") ("��" "��" "��") ("��" "��" "��")))
    ((("r" "g" "q"). ())(("��" "��" "��") ("��" "��" "��") ("��" "��" "��")))
    ((("r" "g" "u"). ())(("��" "��" "��") ("��" "��" "��")))
    ((("r" "g" "w"). ())(("��" "��" "��") ("��" "��" "��") ("��" "��" "��")))
    ((("r" "g" "z"). ())(("��" "��" "��") ("��" "��" "��") ("��" "��" "��")))
    ((("r" "h"). ())(("��" "��" "��") ("��" "��" "��")))
    ((("r" "j"). ())(("��" "��" "��") ("��" "��" "��")))
    ((("r" "k"). ())(("��" "��" "��") ("��" "��" "��")))
    ((("r" "l"). ())(("��" "��" "��") ("��" "��" "��")))
    ((("r" "n"). ())(("��" "��" "��") ("��" "��" "��")))
    ((("r" "p"). ())(("��" "��" "��") ("��" "��" "��")))
    ((("r" "q"). ())(("��" "��" "��") ("��" "��" "��")))
    ((("r" "r"). ())(("��" "��" "��") ("��" "��" "��")))
    ((("r" "w"). ())(("��" "��" "��") ("��" "��" "��")))
    ((("r" "y" "d"). ())(("��" "��" "��") ("��" "��" "��") ("��" "��" "��")))
    ((("r" "y" "h"). ())(("��" "��" "��") ("��" "��" "��") ("��" "��" "��")))
    ((("r" "y" "j"). ())(("��" "��" "��") ("��" "��" "��") ("��" "��" "��")))
    ((("r" "y" "l"). ())(("��" "��" "��") ("��" "��" "��") ("��" "��" "��")))
    ((("r" "y" "n"). ())(("��" "��" "��") ("��" "��" "��") ("��" "��" "��")))
    ((("r" "y" "p"). ())(("��" "��" "��") ("��" "��" "��") ("��" "��" "��")))
    ((("r" "y" "q"). ())(("��" "��" "��") ("��" "��" "��") ("��" "��" "��")))
    ((("r" "y" "w"). ())(("��" "��" "��") ("��" "��" "��") ("��" "��" "��")))
    ((("r" "y" "z"). ())(("��" "��" "��") ("��" "��" "��") ("��" "��" "��")))
    ((("r" "z"). ())(("��" "��" "��") ("��" "��" "��")))
    ((("s" "d"). ())(("��" "��" "��") ("��" "��" "��")))
    ((("s" "f"). ())(("��" "��" "��") ("��" "��" "��")))
    ((("s" "h"). ())(("��" "��" "��") ("��" "��" "��")))
    ((("s" "j"). ())(("��" "��" "��") ("��" "��" "��")))
    ((("s" "k"). ())(("��" "��" "��") ("��" "��" "��")))
    ((("s" "l"). ())(("��" "��" "��") ("��" "��" "��")))
    ((("s" "n"). ())(("��" "��" "��") ("��" "��" "��")))
    ((("s" "p"). ())(("��" "��" "��") ("��" "��" "��")))
    ((("s" "q"). ())(("��" "��" "��") ("��" "��" "��")))
    ((("s" "r"). ())(("��" "��" "��") ("��" "��" "��")))
    ((("s" "s"). ())(("��" "��" "��") ("��" "��" "��")))
    ((("s" "t"). ())(("��" "��" "��") ("��" "��" "��")))
    ((("s" "w"). ())(("��" "��" "��") ("��" "��" "��")))
    ((("s" "y" "d"). ())(("��" "��" "��") ("��" "��" "��") ("��" "��" "��")))
    ((("s" "y" "h"). ())(("��" "��" "��") ("��" "��" "��") ("��" "��" "��")))
    ((("s" "y" "j"). ())(("��" "��" "��") ("��" "��" "��") ("��" "��" "��")))
    ((("s" "y" "l"). ())(("��" "��" "��") ("��" "��" "��") ("��" "��" "��")))
    ((("s" "y" "n"). ())(("��" "��" "��") ("��" "��" "��") ("��" "��" "��")))
    ((("s" "y" "p"). ())(("��" "��" "��") ("��" "��" "��") ("��" "��" "��")))
    ((("s" "y" "q"). ())(("��" "��" "��") ("��" "��" "��") ("��" "��" "��")))
    ((("s" "y" "w"). ())(("��" "��" "��") ("��" "��" "��") ("��" "��" "��")))
    ((("s" "y" "z"). ())(("��" "��" "��") ("��" "��" "��") ("��" "��" "��")))
    ((("s" "z"). ())(("��" "��" "��") ("��" "��" "��")))
    ((("t" "b"). ())(("��" "��" "��") ("��" "��" "�ˎ�")))
    ((("t" "c" "h"). ())("��" "��" "��"))
    ((("t" "d"). ())(("��" "��" "��") ("��" "��" "��")))
    ((("t" "g" "i"). ())(("��" "��" "��") ("��" "��" "��")))
    ((("t" "g" "u"). ())(("��" "��" "��") ("��" "��" "��")))
    ((("t" "h"). ())(("��" "��" "��") ("��" "��" "��")))
    ((("t" "j"). ())(("��" "��" "��") ("��" "��" "��")))
    ((("t" "k"). ())(("��" "��" "��") ("��" "��" "��")))
    ((("t" "l"). ())(("��" "��" "��") ("��" "��" "��")))
    ((("t" "m"). ())(("��" "��" "��") ("��" "��" "��")))
    ((("t" "n"). ())(("��" "��" "��") ("��" "��" "��")))
    ((("t" "p"). ())(("��" "��" "��") ("��" "��" "��")))
    ((("t" "q"). ())(("��" "��" "��") ("��" "��" "��")))
    ((("t" "r"). ())(("��" "��" "��") ("��" "��" "��")))
    ((("t" "s" "a"). ())(("��" "��" "��") ("��" "��" "��")))
    ((("t" "s" "e"). ())(("��" "��" "��") ("��" "��" "��")))
    ((("t" "s" "i"). ())(("��" "��" "��") ("��" "��" "��")))
    ((("t" "s" "o"). ())(("��" "��" "��") ("��" "��" "��")))
    ((("t" "w"). ())(("��" "��" "��") ("��" "��" "��")))
    ((("t" "y" "d"). ())(("��" "��" "��") ("��" "��" "��") ("��" "��" "��")))
    ((("t" "y" "h"). ())(("��" "��" "��") ("��" "��" "��") ("��" "��" "��")))
    ((("t" "y" "j"). ())(("��" "��" "��") ("��" "��" "��") ("��" "��" "��")))
    ((("t" "y" "l"). ())(("��" "��" "��") ("��" "��" "��") ("��" "��" "��")))
    ((("t" "y" "n"). ())(("��" "��" "��") ("��" "��" "��") ("��" "��" "��")))
    ((("t" "y" "p"). ())(("��" "��" "��") ("��" "��" "��") ("��" "��" "��")))
    ((("t" "y" "q"). ())(("��" "��" "��") ("��" "��" "��") ("��" "��" "��")))
    ((("t" "y" "w"). ())(("��" "��" "��") ("��" "��" "��") ("��" "��" "��")))
    ((("t" "y" "z"). ())(("��" "��" "��") ("��" "��" "��") ("��" "��" "��")))
    ((("t" "z"). ())(("��" "��" "��") ("��" "��" "��")))
    ((("w" "d"). ())(("��" "��" "��") ("��" "��" "��") ("��" "��" "��")))
    ((("w" "k"). ())(("��" "��" "��") ("��" "��" "��") ("��" "��" "��")))
    ((("w" "l"). ())(("��" "��" "��") ("��" "��" "��") ("��" "��" "��")))
    ((("w" "n"). ())(("��" "��" "��") ("��" "��" "��")))
    ((("w" "p"). ())(("��" "��" "��") ("��" "��" "��") ("��" "��" "��")))
    ((("w" "q"). ())(("��" "��" "��") ("��" "��" "��")))
    ((("w" "r"). ())(("��" "��" "��") ("��" "��" "��")))
    ((("w" "s" "o"). ())(("��" "��" "��") ("��" "��" "��")))
    ((("w" "t"). ())(("��" "��" "��") ("��" "��" "��")))
    ((("w" "u"). ())("��" "��" "��"))
    ((("w" "z"). ())(("��" "��" "��") ("��" "��" "��")))
    ((("x" "a"). ())(("��" "��" "��") ("��" "��" "��")))
    ((("x" "d"). ())(("��" "��" "��") ("��" "��" "��") ("��" "��" "��")))
    ((("x" "e"). ())(("��" "��" "��") ("��" "��" "��")))
    ((("x" "h"). ())(("��" "��" "��") ("��" "��" "��") ("��" "��" "��")))
    ((("x" "j"). ())(("��" "��" "��") ("��" "��" "��") ("��" "��" "��")))
    ((("x" "l"). ())(("��" "��" "��") ("��" "��" "��") ("��" "��" "��")))
    ((("x" "n"). ())(("��" "��" "��") ("��" "��" "��") ("��" "��" "��")))
    ((("x" "o"). ())(("��" "��" "��") ("��" "��" "��")))
    ((("x" "p"). ())(("��" "��" "��") ("��" "��" "��") ("��" "��" "��")))
    ((("x" "q"). ())(("��" "��" "��") ("��" "��" "��") ("��" "��" "��")))
    ((("x" "u"). ())(("��" "��" "��") ("��" "��" "��")))
    ((("x" "x" "a"). ())("��" "��" "��"))
    ((("x" "x" "i"). ())("��" "��" "��"))
    ((("x" "x" "u"). ())("��" "��" "��"))
    ((("x" "x" "e"). ())("��" "��" "��"))
    ((("x" "x" "o"). ())("��" "��" "��"))
    ((("x" "x" "w" "a"). ())("��" "��" "��"))
    ((("x" "x" "w" "i"). ())("��" "��" "��"))
    ((("x" "x" "w" "e"). ())("��" "��" "��"))
    ((("x" "x" "h"). ())("��" "��" ""))
    ((("x" "x" "j"). ())("��" "��" ""))
    ((("x" "x" "k"). ())("��" "��" ""))
    ((("x" "x" "l"). ())("��" "��" ""))
    ((("x" "-"). ())("-" "-" ""))
    ((("x" ";"). ())(";" ";" ""))
    ((("x" ":"). ())(":" ":" ""))
    ((("x" "_"). ())("��" "��" ""))
    ((("x" ","). ())("," "," ""))
    ((("x" "."). ())("." "." ""))
    ((("x" "["). ())("[" "[" ""))
    ((("x" "]"). ())("]" "]" ""))
    ((("x" "~"). ())("~" "~" ""))
    ((("x" "w"). ())(("��" "��" "��") ("��" "��" "��") ("��" "��" "��")))
    ((("x" "z"). ())(("��" "��" "��") ("��" "��" "��") ("��" "��" "��")))
    ((("y" "e"). ())(("��" "��" "��") ("��" "��" "��")))
    ((("y" "f"). ())("��" "��" "��"))
    ((("y" "h"). ())(("��" "��" "��") ("��" "��" "��")))
    ((("y" "i"). ())("��" "��" "��"))
    ((("y" "j"). ())(("��" "��" "��") ("��" "��" "��")))
    ((("y" "l"). ())(("��" "��" "��") ("��" "��" "��")))
    ((("y" "n"). ())(("��" "��" "��") ("��" "��" "��")))
    ((("y" "p"). ())(("��" "��" "��") ("��" "��" "��")))
    ((("y" "q"). ())(("��" "��" "��") ("��" "��" "��")))
    ((("y" "r"). ())(("��" "��" "��") ("��" "��" "��")))
    ((("y" "w"). ())(("��" "��" "��") ("��" "��" "��") ("��" "��" "��")))
    ((("y" "z"). ())(("��" "��" "��") ("��" "��" "��")))
    ((("z" "c"). ())("��" "��" "����"))
    ((("z" "d"). ())(("��" "��" "����") ("��" "��" "��")))
    ((("z" "f"). ())("��" "��" "����"))
    ((("z" "g" "a"). ())(("��" "��" "����") ("��" "��" "��")))
    ((("z" "g" "d"). ())(("��" "��" "����") ("��" "��" "��") ("��" "��" "��")))
    ((("z" "g" "e"). ())(("��" "��" "����") ("��" "��" "��")))
    ((("z" "g" "h"). ())(("��" "��" "����") ("��" "��" "��") ("��" "��" "��")))
    ((("z" "g" "j"). ())(("��" "��" "����") ("��" "��" "��") ("��" "��" "��")))
    ((("z" "g" "l"). ())(("��" "��" "����") ("��" "��" "��") ("��" "��" "��")))
    ((("z" "g" "n"). ())(("��" "��" "����") ("��" "��" "��") ("��" "��" "��")))
    ((("z" "g" "o"). ())(("��" "��" "����") ("��" "��" "��")))
    ((("z" "g" "p"). ())(("��" "��" "����") ("��" "��" "��") ("��" "��" "��")))
    ((("z" "g" "q"). ())(("��" "��" "����") ("��" "��" "��") ("��" "��" "��")))
    ((("z" "g" "u"). ())(("��" "��" "����") ("��" "��" "��")))
    ((("z" "g" "w"). ())(("��" "��" "����") ("��" "��" "��") ("��" "��" "��")))
    ((("z" "g" "z"). ())(("��" "��" "����") ("��" "��" "��") ("��" "��" "��")))
    ((("z" "h"). ())(("��" "��" "����") ("��" "��" "��")))
    ((("z" "j"). ())(("��" "��" "����") ("��" "��" "��")))
    ((("z" "k"). ())(("��" "��" "����") ("��" "��" "��")))
    ((("z" "l"). ())(("��" "��" "����") ("��" "��" "��")))
    ((("z" "n"). ())(("��" "��" "����") ("��" "��" "��")))
    ((("z" "p"). ())(("��" "��" "����") ("��" "��" "��")))
    ((("z" "q"). ())(("��" "��" "����") ("��" "��" "��")))
    ((("z" "r"). ())(("��" "��" "����") ("��" "��" "��")))
    ((("z" "v"). ())(("��" "��" "����") ("��" "��" "��")))
    ((("z" "w"). ())(("��" "��" "����") ("��" "��" "��")))
    ((("z" "x"). ())(("��" "��" "����") ("��" "��" "��")))
    ((("z" "y" "d"). ())(("��" "��" "����") ("��" "��" "��") ("��" "��" "��")))
    ((("z" "y" "h"). ())(("��" "��" "����") ("��" "��" "��") ("��" "��" "��")))
    ((("z" "y" "j"). ())(("��" "��" "����") ("��" "��" "��") ("��" "��" "��")))
    ((("z" "y" "l"). ())(("��" "��" "����") ("��" "��" "��") ("��" "��" "��")))
    ((("z" "y" "n"). ())(("��" "��" "����") ("��" "��" "��") ("��" "��" "��")))
    ((("z" "y" "p"). ())(("��" "��" "����") ("��" "��" "��") ("��" "��" "��")))
    ((("z" "y" "q"). ())(("��" "��" "����") ("��" "��" "��") ("��" "��" "��")))
    ((("z" "y" "w"). ())(("��" "��" "����") ("��" "��" "��") ("��" "��" "��")))
    ((("z" "y" "z"). ())(("��" "��" "����") ("��" "��" "��") ("��" "��" "��")))
    ((("z" "z"). ())(("��" "��" "����") ("��" "��" "��")))
    ((("s" "g"). ())("��" "��" ""))
    ((("s" "x"). ())("��" "��" ""))
    ((("s" "c"). ())("��" "��" ""))
    ((("s" "v"). ())("��" "��" ""))
    ((("s" "b"). ())("ʬ" "ʬ" ""))
    ((("s" "m"). ())("��" "��" ""))
    ((("d" "r"). ())("��" "��" ""))
    ((("d" "g"). ())("��" "��" ""))
    ((("d" "x"). ())("��" "��" ""))
    ((("d" "v"). ())("��" "��" ""))
    ((("d" "b"). ())("��" "��" ""))
    ((("f" "r"). ())("��" "��" ""))
    ((("f" "t"). ())("��" "��" ""))
    ((("f" "s"). ())("��" "��" ""))
    ((("f" "g"). ())("��" "��" ""))
    ((("f" "x"). ())("��" "��" ""))
    ((("f" "c"). ())("��" "��" ""))
    ((("f" "v"). ())("��" "��" ""))
    ((("f" "b"). ())("��" "��" ""))
    ((("g" "s"). ())("��" "��" ""))
    ((("g" "f"). ())("��" "��" ""))
    ((("g" "x"). ())("��" "��" ""))
    ((("g" "c"). ())("��" "��" ""))
    ((("g" "v"). ())("��" "��" ""))
    ((("g" "b"). ())("��" "��" ""))
    ((("h" "r"). ())("��" "��" ""))
    ((("h" "s"). ())("��" "��" ""))
    ((("h" "f"). ())("ˡ" "ˡ" ""))
    ((("h" "x"). ())("��" "��" ""))
    ((("h" "c"). ())("��" "��" ""))
    ((("h" "v"). ())("��" "��" ""))
    ((("h" "b"). ())("��" "��" ""))
    ((("j" "r"). ())("��" "��" ""))
    ((("j" "t"). ())("��" "��" ""))
    ((("j" "s"). ())("��" "��" ""))
    ((("j" "g"). ())("ʹ" "ʹ" ""))
    ((("j" "x"). ())("��" "��" ""))
    ((("j" "c"). ())("��" "��" ""))
    ((("j" "v"). ())("��" "��" ""))
    ((("j" "b"). ())("��" "��" ""))
    ((("k" "s"). ())("��" "��" ""))
    ((("k" "x"). ())("��" "��" ""))
    ((("k" "c"). ())("��" "��" ""))
    ((("k" "v"). ())("��" "��" ""))
    ((("k" "b"). ())("��" "��" ""))
    ((("r" "t"). ())("��" "��" ""))
    ((("t" "f"). ())("��" "��" ""))
    ((("v" "f"). ())("��" "��" ""))
    ((("v" "z"). ())("��" "��" ""))
))

(define ja-rk-rule-basic-kzik-changeset
  '(
    ((("!"). ())("!" "!" "!"))
    ((("\""). ())("\"" "\"" "\""))
    ((("#"). ())("#" "#" "#"))
    ((("$"). ())("$" "$" "$"))
    ((("%"). ())("%" "%" "%"))
    ((("&"). ())("&" "&" "&"))
    ((("'"). ())("'" "'" "'"))
    ((("("). ())("(" "(" "("))
    (((")"). ())(")" ")" ")"))
    ((("="). ())("=" "=" "="))
    ((("^"). ())("^" "^" "^"))
    ((("\\"). ())("\\" "\\" "\\"))
    ((("|"). ())("|" "|" "|"))
    ((("`"). ())("`" "`" "`"))
    ((("@"). ())("@" "@" "@"))
    ((("{"). ())("{" "{" "{"))
    ((("+"). ())("+" "+" "+"))
    (((";"). ())(";" ";" ";"))
    ((("*"). ())("*" "*" "*"))
    (((":"). ())(":" ":" ":"))
    ((("}"). ())("}" "}" "}"))
    ((("<"). ())("<" "<" "<"))
    (((">"). ())(">" ">" ">"))
    ((("?"). ())("?" "?" "?"))
    ((("/"). ())("/" "/" "/"))
    ((("_"). ())("_" "_" "_"))))

(define (ja-rk-kzik-apply-changeset rule-basic)
  (map (lambda (l)
         (let ((c (assoc (car l) ja-rk-rule-basic-kzik-changeset)))
           (if c
               c
               l)))
       rule-basic))

(define ja-kzik-rule (append ja-kzik-rule-basic (ja-rk-kzik-apply-changeset ja-rk-rule-basic)))