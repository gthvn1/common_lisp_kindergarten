;; We need a db to store CD. We can use a list as a global variables
;; By conventions asteriks are used for globals
(defvar *db* nil)

;; A single record
(defun make-cd (title artist rating ripped)
  "Create a CD"
  (list :title title
	:artist artist
	:rating rating
	:ripped ripped))

(defun add-cd (cd)
  "Add the CD to our global database"
  (push cd *db*))

;; Format is not so hard but special
;; Directives start with ~
;; ~{ and ~} are directives for looping
;; ~a is an aesthetic directive
;;  => consume one argument and print it for human
;; ~10t is tabulation
;; ~% emit a new line
(defun dump-db ()
  "Dump our global database"
  (dolist (cd *db*)
    (format t "~{~a:~10t~a~%~}~%" cd)))

(defun prompt-read (prompt)
  "ask for prompt"
  (format *query-io* "~a: " prompt)
  (force-output *query-io*)
  (read-line *query-io*))

(defun prompt-for-cd ()
  "ask for CD information and return the CD"
  (make-cd
   (prompt-read "Title")
   (prompt-read "Artist")
   ;; Rating is a number... parse-integer returns nil in case of failure
   ;; so use or to return 0 instead of nil. Quick & Dirty but ok.
   (or (parse-integer (prompt-read "Rating") :junk-allowed t) 0)
   (y-or-n-p "Ripped [y/n]")))

(defun add-cds ()
  "Add a bunch of CDs"
  (loop
    (add-cd (prompt-for-cd))
    (if (not (y-or-n-p "Add another one? "))
	(return))))
