#lang racket

(require json)

(provide (struct-out todo)
         todo-from-row)

(struct todo (id author text completed))

(define (todo-from-row row)
  (let ([id (vector-ref row 0)]
        [author (vector-ref row 1)]
        [text (vector-ref row 2)]
        [completed (vector-ref row 3)])
    (todo id author text completed)))