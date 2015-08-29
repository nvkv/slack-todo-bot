#lang racket

(require db
         "slack-trigger.rkt"
         "todo.rkt")

(provide init-database!
         add-todo
         complete-todo
         get-all-todos)

(define db-file "./todo.db")
(define db (sqlite3-connect #:database db-file #:mode 'create))

(define (init-database!)   
  (unless (table-exists? db "todo")
    (query-exec db
                (string-append
                 "CREATE TABLE todo "
                 "(id INTEGER PRIMARY KEY AUTOINCREMENT, author TEXT, body TEXT, completed BOOL)"))))

(define (add-todo trigger)
  (let ([author (slack-trigger-user-name trigger)]
        [text (slack-trigger-text trigger)])    
     (query db "insert into todo (author, body, completed) values ($1, $2, 'false')" author text)))

(define (complete-todo trigger)
  (let ([author (slack-trigger-user-name trigger)]
        [text (slack-trigger-text trigger)])
    (query db "update todo set completed='true' where id=$1" text)))
    
(define (get-all-todos)
  (query db "select * from todo"))
                
    
                