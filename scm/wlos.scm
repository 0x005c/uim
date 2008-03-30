;;; wlos.scm: Wacky Lightweight Object System
;;;
;;; Copyright (c) 2007 uim Project http://code.google.com/p/uim/
;;;
;;; All rights reserved.
;;;
;;; Redistribution and use in source and binary forms, with or without
;;; modification, are permitted provided that the following conditions
;;; are met:
;;;
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
;;; PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR
;;; PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
;;; LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
;;; NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
;;; SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

;; Wacky Lightweight Object System (WLOS, pronounced as wa-loss like
;; CLOS as kloss, or in Japanese, ワロス) is designed to provide less
;; resource consumptive and efficient object oriented programming
;; environment.  -- YamaKen 2007-08-19
;;
;; Characteristics of WLOS:
;;
;; - Single dispatch
;;
;;   Method selection is only based on the receiver object.
;;
;; - Class-based
;;
;;   All instances of a class share identical type information
;;   including method table. But 'object-derive' allows making
;;   singleton object and per-object method redefinition. All methods
;;   listed in define-class are polymorphic.
;;
;; - Single inheritance
;;
;;   Only one superclass can be inherited. Though WLOS does not have
;;   multiple inheritance -like feature such as interfaces or mix-ins,
;;   "call by name" methods can be used to achieve such flexibility.
;;
;; - Fixed method set
;;
;;   Though method redefinition on the fly can be performed, no new
;;   method can dynamically be added to a class once define-class has
;;   been finished.
;;
;; - Inheritance by copy
;;
;;   Even if a superclass method is redefined, the change does not
;;   affect decendant classes. The method table is only copied at
;;   inheritance time.
;;
;; - Call by index
;;
;;   Normal method call on WLOS is performed by retrieving the method
;;   by integer index to the method table, as like as vptr-based
;;   method call on C++. So an inheritance is required to make a method
;;   polymorphic.
;;
;; - Call by name
;;
;;   In addition to the index-based method call described above, call
;;   by name (method name symbol, accurately) is also supported for
;;   flexible object oriented programming. 'call-method' and
;;   'call-supermethod' are provided for explicit method call, and
;;   'make-call-by-name-method-dispatcher' is for defining a method
;;   dispatcher with implicit name-based call. Inheritance-less
;;   polymorphism (i.e. duck typing) can be performed by them. Define
;;   field-accessors as method if you want to access them without type
;;   assumption.
;;
;; - No type check
;;
;;   An object instance cannot be distinguished from its real data
;;   type such as vector or list. And both method dispatcher and
;;   method itself do not check whether the receiver object is
;;   suitable for the method. Ensuring method & receiver combination
;;   proper is user responsibility.
;;
;; - No information hiding
;;
;;   All field accessors and methods are public. If you want to hide
;;   some of them, make them inaccesible or rename to a private name.
;;
;;     ;; inhibit object copy and modification of 'var' field
;;     (define my-object-copy #f)
;;     (define my-object-set-var! #f)
;;
;;     ;; make equal? method dispatcher for my-object private
;;     (define %my-object-equal? my-object-equal?)
;;     (define my-object-equal? #f)
;;
;; - Alternative list-based object (not implemented yet)
;;
;;   In addition to the normal vector-based object, list-based object
;;   will also be able to be used to save memory consumption. The
;;   list-based object will allow sharing some fields between multiple
;;   objects. This feature is the main reason why WLOS is named as
;;   'wacky'.


(require-extension (srfi 1 23))
;;(require-extension (srfi 43))  ;; vector-copy, vector-index, vector-append

(require "util.scm")  ;; safe-car, symbol-append
(require "ng/light-record.scm")
;;(require "./util")
;;(require "./light-record")


(define %HYPHEN-SYM (string->symbol "-"))

(define vector-copy
  (if (symbol-bound? 'vector-copy)
      vector-copy
      (lambda (v)
	(list->vector (vector->list v)))))

(define vector-index
  (if (symbol-bound? 'vector-index)
      vector-index
      (lambda (pred v)
	(list-index pred (vector->list v)))))

(define vector-append
  (if (symbol-bound? 'vector-append)
      vector-append
      (lambda vectors
	(list->vector (append-map vector->list vectors)))))

;;
;; class
;;

(define-vector-record class
  '((ancestors    ())       ;; (super grand-super ... object)
    (field-specs  (class))  ;; record-spec for instance
    (method-names #())))    ;; hold as vector to make call-by-name efficient

(define class-superclass
  (lambda (klass)
    (or (safe-car (class-ancestors klass))
	(error "no superclass"))))

(define class-is-a?
  (lambda (klass another)
    (or (eq? klass another)
	(not (not (memq another (class-ancestors klass)))))))

(define %class-method-index
  (lambda (klass method-name)
    (vector-index (lambda (x)
		    (eq? x method-name))
		  (class-method-names klass))))

(define %class-method-field-index
  (lambda (klass method-name)
    (+ (vector-length class)
       (%class-method-index klass method-name))))

(define class-find-method
  (lambda (klass method-name)
    (vector-ref klass (%class-method-field-index klass method-name))))

(define %class-set-method!
  (lambda (klass method-name proc)
    (vector-set! klass (%class-method-field-index klass method-name) proc)))

(define-macro class-set-method!
  (lambda (klass method-name proc)
    `(%class-set-method! ,klass ',method-name ,proc)))

(define %make-class
  (lambda (super fld-specs+ method-names+)
    (let ((ancestors (if (eq? super class)  ;; bootstrap
			 '()
			 (cons super (class-ancestors super))))
	  (fld-specs (append (class-field-specs super) fld-specs+))
	  (method-names (vector-append (class-method-names super)
				       (list->vector method-names+)))
	  (klass (vector-append super (make-vector (length method-names+)
						   %undefined-method))))
      (set-car! fld-specs `(class ,klass))
      (class-set-ancestors!    klass ancestors)
      (class-set-field-specs!  klass fld-specs)
      (class-set-method-names! klass method-names)
      klass)))

(define-macro %define-methods
  (lambda (klass-name method-names)
    (cons 'begin
	  (map (lambda (method-name)
		 `(define ,(make-method-dispatcher-name klass-name method-name)
	            (make-method-dispatcher ,klass-name ',method-name)))
	       method-names))))

(define-macro define-class
  (lambda (name super fld-specs+ method-names+)
    (let ((klass (apply %make-class
			(eval `(list ,super ,fld-specs+ ,method-names+)
			      (interaction-environment)))))
      `(begin
	 ;; define class object
	 (define ,name ',klass)
	 ;; define instance structure as record
	 ;; FIXME: hardcoded define-vector-record
	 (define-vector-record ,name (class-field-specs ',klass))
	 ;; redefine record object constructor as accepting class-less args
	 (define ,(make-record-constructor-name name)
	   (let ((orig-constructor ,(make-record-constructor-name name)))
	     (lambda args
	       (apply orig-constructor (cons ',klass args)))))
	 ;; define method dispatchers
	 ;; overwrites <class>-copy defined by define-*-record
	 (%define-methods ,name ,(vector->list (class-method-names klass)))))))


;;
;; method call
;;

(define %dispatch-method
  (lambda (index self.args)
    (apply (vector-ref (object-class (car self.args)) index)
	   self.args)))

(define make-method-dispatcher-name
  (lambda (class-name method-name)
    (symbol-append class-name %HYPHEN-SYM method-name)))

;; To suppress redundant closure allocation, dispatchers for same
;; method index share identical procedure regardless of its class. And
;; hardcoded-index version of dispatchers are predefined for efficiency.
(define make-method-dispatcher
  (let ((pool `((0 . ,(lambda self.args (%dispatch-method 0 self.args)))
		(1 . ,(lambda self.args (%dispatch-method 1 self.args)))
		(2 . ,(lambda self.args (%dispatch-method 2 self.args)))
		(3 . ,(lambda self.args (%dispatch-method 3 self.args)))
		(4 . ,(lambda self.args (%dispatch-method 4 self.args)))
		(5 . ,(lambda self.args (%dispatch-method 5 self.args)))
		(6 . ,(lambda self.args (%dispatch-method 6 self.args)))
		(7 . ,(lambda self.args (%dispatch-method 7 self.args)))
		(8 . ,(lambda self.args (%dispatch-method 8 self.args)))
		(9 . ,(lambda self.args (%dispatch-method 9 self.args))))))
    (lambda (klass method-name)
      (let ((index (%class-method-field-index klass method-name)))
	(cond
	 ((assv index pool) => cdr)
	 (else
	  (let ((dispatcher (lambda self.args
			      (%dispatch-method index self.args))))
	    (set! pool (alist-cons index dispatcher pool))
	    dispatcher)))))))

;; call by name
;; To explicitly indicate that this call is name-based, method name is
;; not automatically quoted by a macro.
(define call-method
  (lambda (method-name . self.args)
    (apply (class-find-method (object-class (car self.args)) method-name)
	   self.args)))

;; call by name
(define call-supermethod
  (lambda (method-name . self.args)
    (apply (class-find-method (object-superclass (car self.args)) method-name)
	   self.args)))

;; Used instead of interfaces or mix-ins
;; FIXME: define proper dispatcher-redefinition way for users
(define make-call-by-name-method-dispatcher
  (lambda (method-name)
    (lambda self.args
      (apply (class-find-method (object-class (car self.args)) method-name)
	     self.args))))

;; Method call cascading on popular OO language such as
;;
;;   obj.method1(arg ...).method2(arg ...).method3 
;;
;; can be write on WLOS as folows.
;;
;;   (method-fold obj `(,method1 ,arg ...) `(,method2 ,arg ...) method3 ...)
(define method-fold
  (lambda (obj . method-forms)
    (fold (lambda (method.args res)
	    (cond
	     ((procedure? method.args)
	      (method.args res))
	     ((symbol? method.args)
	      (call-method method.args res))
	     (else
	      (let ((method (car method.args))
		    (args (cdr method.args)))
		(cond
		 ((procedure? method)
		  (apply method (cons res args)))
		 ((symbol? method)
		  (apply call-method (cons* method res args)))
		 (else
		  (error "invalid method form")))))))
	  obj method-forms)))

(define %undefined-method
  (lambda (self . args)
    (error "undefined method")))


;;
;; object
;;

;; bootstrap
(define class (make-class))
(set! make-class #f)
(set! class-copy #f)

;; root of all classes
(define-class object class
  ;; field specs
  '()
  ;; method names
  '(equal?
    copy))  ;; intentionally overwrites copy procedure defined by define-record

(class-set-method! object equal? equal?)
(class-set-method! object copy   vector-copy)

(define object-superclass
  (lambda (self)
    (class-superclass (object-class self))))

(define object-is-a?
  (lambda (self klass)
    (class-is-a? (object-class self) klass)))

;; Makes singleton object which allows per-object method redefinition.
;;
;; (define singleton (object-derive obj))
;; (class-set-method! (object-class singleton) 'method-name method)
(define object-derive
  (lambda (self)
    (let ((derived (object-copy self))
	  (singleton-class (vector-copy (object-class self))))
      (object-set-class! derived singleton-class)
      derived)))


;;
;; Examples
;;

(define-class comparable object
  '()
  '(<
    <=
    >
    >=))

(define-class comparable-number-str comparable
  '(value)
  '())

(define make-comparable-number-str-compare
  (lambda (compare)
    (lambda (self other)
      (compare (string->number (comparable-number-str-value self))
	       (string->number (comparable-number-str-value other))))))

(class-set-method! comparable-number-str equal?
		   (make-comparable-number-str-compare =))

(class-set-method! comparable-number-str <
		   (make-comparable-number-str-compare <))

(class-set-method! comparable-number-str <=
		   (make-comparable-number-str-compare <=))

(class-set-method! comparable-number-str >
		   (make-comparable-number-str-compare >))

(class-set-method! comparable-number-str >=
		   (make-comparable-number-str-compare >=))

(define ok
  (lambda ()
    (display "OK")
    (newline)
    #t))

(define foo (make-comparable-number-str "31"))
(define bar (make-comparable-number-str "153"))

;; call by index
(and (comparable-<  foo bar)
     (comparable-<= foo bar)
     (comparable->  bar foo)
     (comparable->= bar foo)
     (not (comparable-equal? foo bar))
     (comparable-equal? foo (object-copy foo))
     (ok))

;; call by name
(and (call-method '<  foo bar)
     (call-method '<= foo bar)
     (call-method '>  bar foo)
     (call-method '>= bar foo)
     (not (call-method 'equal? foo bar))
     (call-method 'equal? foo (object-copy foo))
     (ok))

(require-extension (srfi 95))
(define comparables
  (map make-comparable-number-str
       '("3" "-5" "13" "-1" "0" "43")))
(define sorted (sort comparables comparable-<))
(and (equal? '("-5" "-1" "0" "3" "13" "43")
	     (map comparable-number-str-value sorted))
     (ok))
