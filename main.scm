#!/bin/sh
# -*- mode: scheme; -*-
exec "${GUILE-guile}" -s "$0" "$@"
!#

(define emacs-backup-pattern (make-regexp "^(#.*#|.*~)$"))

(define (filter-dir dir)
  (let ((dir-stream (opendir dir)))
    (let filter-files ((dir-entry (readdir dir-stream)))
      (if (not (eof-object? dir-entry))
	  (let ((entry-full-path (string-append dir "/" dir-entry)))
	    (if (and (file-is-directory? entry-full-path)
		     (not (or (equal? "." dir-entry)
			      (equal? ".." dir-entry)
			      (equal? ".git" dir-entry))))
		(filter-dir entry-full-path)
		(if (regexp-exec emacs-backup-pattern dir-entry)
		    (delete-file entry-full-path)))
	    (filter-files (readdir dir-stream)))))
    (closedir dir-stream)))

(filter-dir (getcwd))
