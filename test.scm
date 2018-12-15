; Test file trying to make a macro that
; creates a string from a symbol

(use-modules (ice-9 regex))

(define (funcname->api fname)
  (regexp-substitute/global #f "-" fname
                            'pre "_" 'post))

(define-syntax defperson
  (syntax-rules ()
    ((defperson name)
     (define (name) (funcname->api (symbol->string 'name))))))


(defperson bob-person)

(display (bob-person))
