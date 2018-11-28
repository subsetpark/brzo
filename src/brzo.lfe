(defmodule brzo
  (doc "Regexing with derivatives.")
  (export (nullable? 1) (derive 2) (matches? 2)
          (cat 2) (union 2) (char 1) (star 1)))

(defun char (c) (tuple 'char c))
(defun star (c) (tuple 'star c))

(defun cat (a b) (tuple 'cat a b))
(defun union (a b) (tuple 'union a b))

(defun nullable?
  "Test if the language contains the empty string."
  (['empty] 'false)
  (['epsilon] 'true)
  ([(tuple 'char _)] 'false)
  ([(tuple 'star _)] 'true)
  ([(tuple 'union a b)] (or (nullable? a) (nullable? b)))
  ([(tuple 'cat a b)] (and (nullable? a) (nullable? b))))

(defun derive
  "Get the derivative of a language *l* with respect to a character *c*."
  (['empty _] 'empty)
  (['epsilon _] 'empty)
  ([(tuple 'char c) c] 'epsilon)
  ([(tuple 'char _) _] 'empty)
  ([(tuple 'union a b) c]
    (union (derive a c) (derive b c)))
  ([(= (tuple 'star l) star-l) c]
    (cat (derive l c) star-l))
  ([(tuple 'cat a b) c]
    (let ([first (cat (derive a c) b)])
      (cond ((nullable? a) (union first (derive b c)))
            ('true first)))))

(defun matches?
  "Test a string for membership in language *l*."
  (["" l] (nullable? l))
  ([(cons c rest) l] (matches? rest (derive l c))))
