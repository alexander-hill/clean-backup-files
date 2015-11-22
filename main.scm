#!/bin/sh
exec "${GUILE-guile}" -s "$0" "$@"
!#

(define emacs-backup-pattern (make-regexp "^(#.*#|.*~)$"))

(define (filter-dir dir)
  (let ((dir-stream (opendir dir)))
    (let filter-files ((dir-entry (readdir dir-stream)))
      (if (not (eof-object? dir-entry))
	  (begin
	    (if (and (file-is-directory? dir-entry)
		     (not (or (equal? "." dir-entry)
			      (equal? ".." dir-entry)
			      (equal? ".git" dir-entry))))
		(filter-dir (string-append/shared dir "/" dir-entry))
		(begin
		  (if (regexp-exec emacs-backup-pattern dir-entry)
		      (delete-file dir-entry))
		  (filter-files (readdir dir-stream)))))))
    (closedir dir-stream)))

(filter-dir (getcwd))
