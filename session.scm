; Defines structure of the session

(define* (create-session uri #:key (endpoint "/webservice/rest/server.php"))
  `(
        ("uri" . ,(string-append uri endpoint))
        ))

(define (session-uri sess) (assoc-ref sess "uri"))

(define* (authenticate session username password #:key (uri-path "login/token.php"))
  ;; TODO: Actually perform authentication step
  (set! session 
    (assoc-set! session "token" "TODO:fromabove"))
  session)

(define (authenticated? sess)
  (if (equal? (assoc-ref sess "token") #f) #f #t))

(define (session-token sess) (assoc-ref sess "token"))
