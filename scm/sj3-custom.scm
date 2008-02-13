;;; sj3-custom.scm: Customization variables for sj3.scm
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

(require "i18n.scm")


(define sj3-im-name-label (N_ "SJ3"))
(define sj3-im-short-desc (N_ "A multi-segment kana-kanji conversion engine"))

(define-custom-group 'sj3
                     sj3-im-name-label
                     sj3-im-short-desc)

(define-custom-group 'sj3server
		     (N_ "SJ3 server")
		     (N_ "long description will be here."))

(define-custom-group 'sj3-advanced
		     (N_ "SJ3 (advanced)")
		     (N_ "long description will be here."))

;;
;; segment separator
;;

(define-custom 'sj3-show-segment-separator? #f
  '(sj3 segment-sep)
  '(boolean)
  (N_ "Show segment separator")
  (N_ "long description will be here."))

(define-custom 'sj3-segment-separator "|"
  '(sj3 segment-sep)
  '(string ".*")
  (N_ "Segment separator")
  (N_ "long description will be here."))

(custom-add-hook 'sj3-segment-separator
		 'custom-activity-hooks
		 (lambda ()
		   sj3-show-segment-separator?))

;;
;; candidate window
;;

(define-custom 'sj3-use-candidate-window? #t
  '(sj3 candwin)
  '(boolean)
  (N_ "Use candidate window")
  (N_ "long description will be here."))

(define-custom 'sj3-candidate-op-count 1
  '(sj3 candwin)
  '(integer 0 99)
  (N_ "Conversion key press count to show candidate window")
  (N_ "long description will be here."))

(define-custom 'sj3-nr-candidate-max 10
  '(sj3 candwin)
  '(integer 1 20)
  (N_ "Number of candidates in candidate window at a time")
  (N_ "long description will be here."))

(define-custom 'sj3-select-candidate-by-numeral-key? #f
  '(sj3 candwin)
  '(boolean)
  (N_ "Select candidate by numeral keys")
  (N_ "long description will be here."))

;; activity dependency
(custom-add-hook 'sj3-candidate-op-count
		 'custom-activity-hooks
		 (lambda ()
		   sj3-use-candidate-window?))

(custom-add-hook 'sj3-nr-candidate-max
		 'custom-activity-hooks
		 (lambda ()
		   sj3-use-candidate-window?))

(custom-add-hook 'sj3-select-candidate-by-numeral-key?
		 'custom-activity-hooks
		 (lambda ()
		   sj3-use-candidate-window?))

;;
;; toolbar
;;

;; Can't be unified with action definitions in sj3.scm until uim
;; 0.4.6.
(define sj3-input-mode-indication-alist
  (list
   (list 'action_sj3_direct
	 'ja_direct
	 "-"
	 (N_ "Direct input")
	 (N_ "Direct input mode"))
   (list 'action_sj3_hiragana
	 'ja_hiragana
	 "��"
	 (N_ "Hiragana")
	 (N_ "Hiragana input mode"))
   (list 'action_sj3_katakana
	 'ja_katakana
	 "��"
	 (N_ "Katakana")
	 (N_ "Katakana input mode"))
   (list 'action_sj3_halfkana
	 'ja_halfkana
	 "��"
	 (N_ "Halfwidth Katakana")
	 (N_ "Halfwidth Katakana input mode"))
   (list 'action_sj3_halfwidth_alnum
	 'ja_halfwidth_alnum
	 "a"
	 (N_ "Halfwidth Alphanumeric")
	 (N_ "Halfwidth Alphanumeric input mode"))

   (list 'action_sj3_fullwidth_alnum
	 'ja_fullwidth_alnum
	 "��"
	 (N_ "Fullwidth Alphanumeric")
	 (N_ "Fullwidth Alphanumeric input mode"))))

(define sj3-kana-input-method-indication-alist
  (list
   (list 'action_sj3_roma
	 'ja_romaji
	 "��"
	 (N_ "Romaji")
	 (N_ "Romaji input mode"))
   (list 'action_sj3_kana
	 'ja_kana
	 "��"
	 (N_ "Kana")
	 (N_ "Kana input mode"))
   (list 'action_sj3_azik
	 'ja_azik
	 "��"
	 (N_ "AZIK")
	 (N_ "AZIK extended romaji input mode"))))

;;; Buttons

(define-custom 'sj3-widgets '(widget_sj3_input_mode
				widget_sj3_kana_input_method)
  '(sj3 toolbar)
  (list 'ordered-list
	(list 'widget_sj3_input_mode
	      (N_ "Input mode")
	      (N_ "Input mode"))
	(list 'widget_sj3_kana_input_method
	      (N_ "Kana input method")
	      (N_ "Kana input method")))
  (N_ "Enabled toolbar buttons")
  (N_ "long description will be here."))

;; dynamic reconfiguration
;; sj3-configure-widgets is not defined at this point. So wrapping
;; into lambda.
(custom-add-hook 'sj3-widgets
		 'custom-set-hooks
		 (lambda ()
		   (sj3-configure-widgets)))


;;; Input mode

(define-custom 'default-widget_sj3_input_mode 'action_sj3_direct
  '(sj3 toolbar)
  (cons 'choice
	(map indication-alist-entry-extract-choice
	     sj3-input-mode-indication-alist))
  (N_ "Default input mode")
  (N_ "long description will be here."))

(define-custom 'sj3-input-mode-actions
               (map car sj3-input-mode-indication-alist)
  '(sj3 toolbar)
  (cons 'ordered-list
	(map indication-alist-entry-extract-choice
	     sj3-input-mode-indication-alist))
  (N_ "Input mode menu items")
  (N_ "long description will be here."))

;; value dependency
(if custom-full-featured?
    (custom-add-hook 'sj3-input-mode-actions
		     'custom-set-hooks
		     (lambda ()
		       (custom-choice-range-reflect-olist-val
			'default-widget_sj3_input_mode
			'sj3-input-mode-actions
			sj3-input-mode-indication-alist))))

;; activity dependency
(custom-add-hook 'default-widget_sj3_input_mode
		 'custom-activity-hooks
		 (lambda ()
		   (memq 'widget_sj3_input_mode sj3-widgets)))

(custom-add-hook 'sj3-input-mode-actions
		 'custom-activity-hooks
		 (lambda ()
		   (memq 'widget_sj3_input_mode sj3-widgets)))

;; dynamic reconfiguration
(custom-add-hook 'default-widget_sj3_input_mode
		 'custom-set-hooks
		 (lambda ()
		   (sj3-configure-widgets)))

(custom-add-hook 'sj3-input-mode-actions
		 'custom-set-hooks
		 (lambda ()
		   (sj3-configure-widgets)))

;;; Kana input method

(define-custom 'default-widget_sj3_kana_input_method 'action_sj3_roma
  '(sj3 toolbar)
  (cons 'choice
	(map indication-alist-entry-extract-choice
	     sj3-kana-input-method-indication-alist))
  (N_ "Default kana input method")
  (N_ "long description will be here."))

(define-custom 'sj3-kana-input-method-actions
               (map car sj3-kana-input-method-indication-alist)
  '(sj3 toolbar)
  (cons 'ordered-list
	(map indication-alist-entry-extract-choice
	     sj3-kana-input-method-indication-alist))
  (N_ "Kana input method menu items")
  (N_ "long description will be here."))

;; value dependency
(if custom-full-featured?
    (custom-add-hook 'sj3-kana-input-method-actions
		     'custom-set-hooks
		     (lambda ()
		       (custom-choice-range-reflect-olist-val
			'default-widget_sj3_kana_input_method
			'sj3-kana-input-method-actions
			sj3-kana-input-method-indication-alist))))

;; activity dependency
(custom-add-hook 'default-widget_sj3_kana_input_method
		 'custom-activity-hooks
		 (lambda ()
		   (memq 'widget_sj3_kana_input_method sj3-widgets)))

(custom-add-hook 'sj3-kana-input-method-actions
		 'custom-activity-hooks
		 (lambda ()
		   (memq 'widget_sj3_kana_input_method sj3-widgets)))

;; dynamic reconfiguration
(custom-add-hook 'default-widget_sj3_kana_input_method
		 'custom-set-hooks
		 (lambda ()
		   (sj3-configure-widgets)))

(custom-add-hook 'sj3-kana-input-method-actions
		 'custom-set-hooks
		 (lambda ()
		   (sj3-configure-widgets)))


;;
;; sj3-server-name
;;

; TODO: support sj3server on other host
(define sj3-server-name "")
;(define sj3-server-name "localhost")
;(define sj3-server-name "127.0.0.1")

;; warning: must be defined before custom-preserved-sj3-server-name
(define-custom 'custom-activate-sj3-server-name? #f
  '(sj3-advanced sj3server)
  '(boolean)
  (N_ "Specify SJ3 server")
  (N_ "long description will be here."))

(define-custom 'custom-preserved-sj3-server-name ""
  '(sj3-advanced sj3server)
  '(string ".*")
  (N_ "SJ3 server name")
  (N_ "long description will be here."))

;; activity dependency
(custom-add-hook 'custom-preserved-sj3-server-name
		 'custom-activity-hooks
		 (lambda ()
		   custom-activate-sj3-server-name?))

(define custom-hook-get-sj3-server-name
  (lambda ()
    (set! custom-activate-sj3-server-name? sj3-server-name)
    (set! custom-preserved-sj3-server-name (or sj3-server-name
						 custom-preserved-sj3-server-name
						 ""))))

;; decode #f from sj3-server-name
(custom-add-hook 'custom-activate-sj3-server-name?
		 'custom-get-hooks
		 custom-hook-get-sj3-server-name)
(custom-add-hook 'sj3-server-name
		 'custom-get-hooks
		 custom-hook-get-sj3-server-name)

(define custom-hook-set-sj3-server-name
  (lambda ()
    (set! sj3-server-name
	  (and custom-activate-sj3-server-name?
	       custom-preserved-sj3-server-name))))

;; encode #f into sj3-server-name
(custom-add-hook 'custom-activate-sj3-server-name?
		 'custom-set-hooks
		 custom-hook-set-sj3-server-name)
(custom-add-hook 'custom-preserved-sj3-server-name
		 'custom-set-hooks
		 custom-hook-set-sj3-server-name)

(define custom-hook-literalize-preserved-sj3-server-name
  (lambda ()
    (string-append
     "(define custom-preserved-sj3-server-name "
     (custom-value-as-literal 'custom-preserved-sj3-server-name)
     ")\n"
     "(define sj3-server-name "
     (if sj3-server-name
	 (string-append "\"" sj3-server-name "\"")
	 "#f")
     ")")))

(custom-add-hook 'custom-preserved-sj3-server-name
		 'custom-literalize-hooks
		 custom-hook-literalize-preserved-sj3-server-name)

(define-custom 'sj3-user (getenv "USER")
  '(sj3-advanced sj3server)
  '(string ".*")
  (N_ "SJ3 user name")
  (N_ "long description will be here."))

(define-custom 'sj3-use-with-vi? #f
  '(sj3-advanced special-op)
  '(boolean)
  (N_ "Enable vi-cooperative mode")
  (N_ "long description will be here."))

(define-custom 'sj3-use-mode-transition-keys-in-off-mode? #f
  '(sj3-advanced mode-transition)
  '(boolean)
  (N_ "Enable input mode transition keys in direct (off state) input mode")
  (N_ "long description will be here."))
