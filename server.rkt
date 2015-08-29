#lang racket

;;; Slack todo bot

(require (planet dmac/spin))

(require db         
         json
         net/url)

(require "config.rkt"
         "db.rkt"
         "slack-trigger.rkt"
         "todo.rkt")

(post "/add"
      (lambda (req)        
        (match (add-todo (slack-trigger-from req))
          [(simple-result _) "Ok, я записал"]
          [_ "Что-то пошло не так :("])))

(post "/complete"
      (lambda (req)       
        (match (complete-todo (slack-trigger-from req))
          [(simple-result _) "Окей, как скажешь"]
          [_ "Что-то пошло не так :("])))

(define (rich-slack-message todos)
  (define (todo->hash todo)
    (make-hash (list (cons 'title (todo-author todo))
                     (cons 'value (todo-text todo)))))
  (make-hash (list (cons 'attachments
                         (list
                          (make-hash
                           (list (cons 'pretext "Вы зачем-то хотели сделать это, жалкие людишки:")
                                 (cons 'color "#D00000")
                                 (cons 'fields
                                       (map (lambda (todo) (todo->hash todo))
                                            todos)))))))))
(get "/broadcast"
     (lambda (req)       
       (let ([todos (get-uncompleted-todos)])
         (define json-port (open-output-string))
         (define hook (write-json (rich-slack-message todos) json-port))                  
         (http-sendrecv/url (string->url hook-url)
                            #:method "POST"
                            #:headers (list "Content-Type: application/json")
                            #:data (get-output-string json-port)))
       "ok"))

(init-database!)
(writeln "Starting bot...")
(run #:listen-ip #f)