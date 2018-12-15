#!/usr/bin/env -S guile -s
!#

(use-modules 
  (srfi srfi-1) 
  (srfi srfi-8) 
  (json) 
  (web request) 
  (web response) 
  (web uri) 
  (ice-9 optargs) 
  (ice-9 regex))

(load "helpers.scm")
(load "session.scm")

(define (build-moodle-request-params function token . args)
  (append `(
    ("moodlewsrestformat" . "json")
    ("wstoken" . ,token)
    ("wsfunction" . ,function)
    ) args))
    



(define (build-moodle-request session funcname ...)
  (let [
        (params (build-moodle-request-params funcname (session-token session) ...))
        (uri (session-uri session))
        ]
    (build-request (uri-add-params uri params))))


;(define (core-enrol-get-users-courses session userid)
;  (build-moodle-request session "core_enrol_get_users_courses"))

(define (scm->moodlefuncname scm-func-name)
  (regexp-substitute/global #f "-" scm-func-name 'pre "_" 'post))

(define-syntax defmoodlefunc
  (syntax-rules ()
     ((defmoodlefunc name)
      (define (name session)
        (build-moodle-request session (scm->moodlefuncname (symbol->string 'name)))))

     ((defmoodlefunc name arg)
      (define (name session arg)
       (build-moodle-request session 
                             (scm->moodlefuncname (symbol->string 'name)) 
                             `(,(symbol->string 'arg) . ,arg))))
      ))


;(define-macro (defmoodle ...)
;    (map defmoodlefunc '(...)))

;(defmoodle
;  (core-enrol-get-users-courses userid)
;  (core-course-get-contents courseid)
;  (core-webservice-get-site-info))

(defmoodlefunc core-enrol-get-users-courses userid)

(define learn (create-session "http://learn.canterbury.ac.nz"))

(define session 
  (authenticate learn "liam" "password"))


(display (core-enrol-get-users-courses session 23))

; (display (build-moodle-request 
