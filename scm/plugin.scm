;;;
;;; $Id:$
;;;
;;; plugin.scm: Plugin for uim.
;;;
;;; Copyright (c) 2005-2006 uim Project http://uim.freedesktop.org/
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

(require "util.scm")

(define uim-plugin-lib-load-path
  (if (setugid?)
      (list (string-append (sys-pkglibdir) "/plugin"))
      (let ((home-dir (getenv "HOME"))
	    (ld-library-path (getenv "LD_LIBRARY_PATH")))
	(filter string?
		(append (list (getenv "LIBUIM_PLUGIN_LIB_DIR")
			      (if home-dir
				  (string-append home-dir ".uim.d/plugin")
				  '())
			      (string-append (sys-pkglibdir) "/plugin"))
			;; XXX
			(if ld-library-path
			    (string-split ld-library-path ":")
			    '()))))))

(define uim-plugin-scm-load-path
  (if (setugid?)
      (list (sys-pkgdatadir))
      (let ((home-dir (getenv "HOME")))
	(filter string?
		(list (getenv "LIBUIM_SCM_FILES")
		      (if home-dir
			  (string-append home-dir "/.uim.d/plugin")
			  '())
		      (sys-pkgdatadir))))))

(define plugin-alist ())
(define plugin-func-alist ())

(define-record 'plugin-entry
  '((name      "")
    ;;(desc      "")
    ;;(author    "")
    ;;(version   #f)
    (library   #f)
    (init-proc #f)
    (quit-proc #f)))

(define plugin-list-append
  (lambda (plugin-name library init quit)
   (let ((entry (plugin-entry-new plugin-name library init quit)))
     (set! plugin-alist
	   (append plugin-alist (list entry))))))

(define plugin-list-delete
  (lambda (plugin-name)
    (set! plugin-alist
	  (alist-delete plugin-name plugin-alist string=?))))

(define plugin-list-query
  (lambda (plugin-name)
    (assoc plugin-name plugin-alist)))

(define plugin-list-query-library
  (lambda (plugin-name)
    (let ((entry (plugin-list-query plugin-name)))
      (and entry
	   (plugin-entry-library entry)))))

(define plugin-list-query-instance-init
  (lambda (plugin-name)
    (let ((entry (plugin-list-query plugin-name)))
      (and entry
	   (plugin-entry-init-proc entry)))))

(define plugin-list-query-instance-quit
  (lambda (plugin-name)
    (let ((entry (plugin-list-query plugin-name)))
      (and entry
	   (plugin-entry-quit-proc entry)))))


;; The name 'module' is adopted from a post from Hiroyuki. If you
;; feel bad about the meaning of 'module', post your opinion to
;; uim@fdo.

(define installed-im-module-list ())
(define currently-loading-module-name #f)

;;
;; TODO: write test for load-plugin
;; returns whether initialization is succeeded
(define require-module
  (lambda (module-name)
    (set! currently-loading-module-name module-name)
    (let ((succeeded (or (load-plugin module-name)
			 (try-require (string-append module-name ".scm")))))
      (set! currently-loading-module-name #f)
      succeeded)))

;; TODO: write test
(define load-module-conf
  (lambda ()
    (let* ((home-dir (getenv "HOME"))
	   (user-module-dir (if home-dir
				(string-append home-dir "/.uim.d/plugin/")
				#f))
	   (conf-file "installed-modules.scm")
	   (user-conf-file (if user-module-dir
			       (string-append user-module-dir conf-file)
			       #f)))
      (try-load conf-file)
      (if (or
	   (setugid?)
	   (not user-conf-file))
	  #f
	  (if (not (getenv "LIBUIM_VANILLA"))
	      (let ((orig-module-list installed-im-module-list)
		    (orig-enabled-list enabled-im-list))
		(if (try-load user-conf-file)
		    (begin
		      (set! installed-im-module-list
			    (append orig-module-list installed-im-module-list))
		      (set! enabled-im-list
			    (append orig-enabled-list enabled-im-list))))))))))


;; TODO: write test
(define load-enabled-modules
  (lambda ()
    (let* ((home-dir (getenv "HOME"))
	   (user-module-dir (if home-dir
				(string-append home-dir "/.uim.d/plugin/")
				#f))
	   (file "loader.scm")
	   (user-file (if user-module-dir
			  (string-append user-module-dir file)
			  #f)))
      (and (try-load file)
	   (or (and (not (setugid?))
		    user-file
		    (try-load user-file))
	       #t)))))
