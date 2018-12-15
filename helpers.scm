(use-modules (srfi srfi-1))

(define (to-string o)
  (cond
         ((number? o) (number->string o))
         ((string? o) o)
         (else "" (warn 'cast (string-append "Could not cast type " o " to string")))
         ))

(define (queryize p other)
  (let [
        (k (to-string (car p)))
        (v (to-string (cdr p)))
        ]
  (string-append 
    other
    (if (eq? other "") "" "&") 
    k "=" v
    )))


(define (format-query alist)
    (fold queryize "" alist))


(define (uri-add-params uristring params)
  (let [
       (uri (string->uri uristring))
       ]
    (build-uri (uri-scheme uri)
               #:host (uri-host uri)
               #:userinfo (uri-userinfo uri)
               #:host (uri-host uri)
               #:port (uri-port uri)
               #:path (uri-path uri)
               #:query (format-query params)
               #:fragment (uri-fragment uri))))
