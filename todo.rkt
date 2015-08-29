#lang racket

(provide (struct-out todo))

(struct todo (id author text))