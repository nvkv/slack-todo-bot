#lang racket

(require db
         "slack-trigger.rkt"
         "todo.rkt")

(provide init-database!
         add-todo
         complete-todo
         get-all-todos
         get-uncompleted-todos)

(define db-file "./todo.db")
(define db (sqlite3-connect #:database db-file #:mode 'create))

(define (init-database!)   
  (unless (table-exists? db "todo")
    (query-exec db
                (string-append
                 "CREATE TABLE todo "
                 "(id INTEGER PRIMARY KEY AUTOINCREMENT, author TEXT NOT NULL, body TEXT NOT NULL, completed BOOL)"))))

(define (add-todo trigger)
  (with-handlers ([exn:fail? (lambda (exc) null)])
    (let ([author (slack-trigger-user-name trigger)]
          [text (slack-trigger-text trigger)])
      (query db "insert into todo (author, body, completed) values ($1, $2, 'false')" author text))))

(define (complete-todo trigger)
  (with-handlers ([exn:fail? (lambda (exn) null)])
    (let ([author (slack-trigger-user-name trigger)]
          [text (slack-trigger-text trigger)])
      (query db "update todo set completed='true' where id=$1" text))))

(define (get-all-todos)
  (map
   (lambda (row) (todo-from-row row))
   (query-rows db "select * from todo")))

(define (get-uncompleted-todos)
  (map
   (lambda (row) (todo-from-row row))
   (query-rows db "select * from todo where completed='false'")))
