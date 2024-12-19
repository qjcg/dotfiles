;; -*- lexical-binding: t; -*-

;; (defcustom jg-dir-nix
;;   "~/src/github.com/qjcg/nix"
;;   "Directory containing Nix configuration.")

(defun jg-interactive-greet (name)
  "Print a friendly greeting"
  (interactive "sName? ")
  (message "Hello, %s!" name))

(defun jg-greet (name)
  "Return a friendly greeting string."
  (format "Hello, %s!" name))

(ert-deftest jg-test-greet ()
  "Test the jg-greet function."
  (should (equal (jg-greet "foo") "Hello, foo!")))

(defun jg-uprev (str)
  "Uppercase and reverse word passed as input."
  (reverse (upcase str)))

(ert-deftest jg-test-uprev ()
  "Test the jg-uprev function."
  (should (equal (jg-uprev "") ""))
  (should (equal (jg-uprev "foo") "OOF")))

(defun jg-greet-dns (hostname)
  "Return a friendly greeting string response to a DNS query."
  (format "HELLO %s" (dns-query hostname)))

(ert-deftest jg-test-greet-dns ()
  "Test the jg-uprev function.

TODO: Use a test-double for dns-query.
"
  (should (equal (jg-greet-dns "example.com") "HELLO 93.184.215.14")))


;; A buttercup test suite.
;; To run interactively, use: M-x buttercup-run-at-point
;; To run via CLI, use: TODO
(describe "John's library test suite"
	  (before-each
	   (spy-on 'dns-query :and-return-value "127.0.0.1"))

	  (it "uppercases and reverses strings"
	      (expect (jg-uprev "Hello, World!") :to-equal "!DLROW ,OLLEH"))

	  (it "greets a user by name"
	      (expect (jg-greet "John") :to-equal "Hello, John!"))

	  (it "greets DNS"
	      (expect (jg-greet-dns "example.com") :to-equal "HELLO 127.0.0.1")))

(provide 'utils)
