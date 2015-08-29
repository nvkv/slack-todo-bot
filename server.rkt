#lang racket

;;; Slack todo bot

(require (planet dmac/spin))
(require "db.rkt" "slack-trigger.rkt")

(post "/remind"
      (lambda (req)
        (writeln (slack-trigger-text (slack-trigger-from req)))
        (add-todo (slack-trigger-from req))
        "Hello!"))

(post "/complete"
     (lambda (req)       
       (complete-todo (slack-trigger-from req))
       (println (get-all-todos))
       "Ok"))

(init-database!)
(run)