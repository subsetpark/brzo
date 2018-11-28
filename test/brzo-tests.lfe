(defmodule brzo-tests
  (behaviour ltest-unit)
  (export all)
  (import
    (from brzo
      (matches? 2)
      (cat 2)
      (char 1))
    (from ltest
      (check-failed-assert 2)
      (check-wrong-assert-exception 2))))

(include-lib "./deps/ltest/include/ltest-macros.lfe")

(defun happy_test ()
    (is (matches? "ok" (cat (char #\o) (char #\k)))))

(defun sad_test ()
    (is-not (matches? "ok" (cat (char #\o) (char #\p)))))
