;;; spellcheck-custom.scm: Customization variables for spellcheck.scm:
;;;
;;; Copyright (c) 2003-2005 uim Project http://uim.freedesktop.org/
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

(require "i18n.scm")


;; spellcheck IM is not available yet

(define spell-im-label-name (N_ "Spellcheck"))
(define spell-im-short-desc (N_ "Spellcheck"))

(define-custom-group 'spellcheck
                     (ugettext spell-im-label-name)
                     (ugettext spell-im-short-desc))

(define-custom 'spell-use-candidate-window? #t
  '(spellcheck)
  '(boolean)
  (_ "Use candidate window")
  (_ "long description will be here."))

(define-custom 'spell-candidate-op-count 1
  '(spellcheck)
  '(integer 0 99)
  (_ "Conversion key press count to show candidate window")
  (_ "long description will be here."))

(define-custom 'spell-preedit-immediate-commit? #f
  '(spellcheck)
  '(boolean)
  (_ "spell-preedit-immediate-commit?")
  (_ "long description will be here."))

(define-custom 'spell-always-show-window? #t
  '(spellcheck)
  '(boolean)
  (_ "Always showing candidate window")
  (_ "long description will be here."))

(define-custom 'spell-on-key '("<Control>j" "<Control>J" generic-on-key)
               '(spellcheck)
	       '(key)
	       (_ "[Spellcheck] on")
	       (_ "long description will be here"))
