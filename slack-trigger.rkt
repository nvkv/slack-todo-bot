#lang racket

(require web-server/http/request-structs         
         net/uri-codec)

(provide
 (struct-out slack-trigger)
 slack-trigger-from)

(struct slack-trigger
  (token
   team-id
   team-domain
   channel-id
   channel-name
   timestamp
   user-id
   user-name
   command
   text))
   

(define (slack-trigger-from request)
  (define body-list (string-split (bytes->string/utf-8 (request-post-data/raw request)) "&"))  
  (define body-hash
    (make-hash (map (lambda (pair) (string-split pair "=")) body-list)))  
  (slack-trigger
   (car (hash-ref body-hash "token" '("")))
   (car (hash-ref body-hash "team_id" '("")))
   (car (hash-ref body-hash "team_domain" '("")))
   (car (hash-ref body-hash "channel_id" '("")))
   (car (hash-ref body-hash "channel_name" '("")))
   (car (hash-ref body-hash "timestamp" '("")))
   (car (hash-ref body-hash "user_id" '("")))
   (car (hash-ref body-hash "user_name" '(null)))
   (car (hash-ref body-hash "command" '("")))
   (form-urlencoded-decode
    (string-trim (car (hash-ref body-hash "text" '(null)))))))