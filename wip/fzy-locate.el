;;; fzy-locate.el --- Fuzzy file find using "mlocate"

;; Copyright (C) 2015 Bill Piel

;; This file is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation; either version 2, or (at your option)
;; any later version.

;; This file is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with GNU Emacs; see the file COPYING.  If not, write to
;; the Free Software Foundation, Inc., 59 Temple Place - Suite 330,
;; Boston, MA 02111-1307, USA.

(defun str->chrlist (s)
  (butlast (rest  (split-string s ""))))

(defun is-sep? (c)
  (eq 0 (string-match-p "^[\\/.-]$" c)))

(defun is-cap? (c)
  (eq 0 (let ((case-fold-search nil))
          (string-match-p "^[A-Z]$" c))))

(defun str->heatmap (f)
  (cl-loop for c in (str->chrlist f )
               with r = '()
               with b = 3
               do (progn
                    (setq r (append r
                                    (list (+  (cond ((is-cap? c) 10)
                                                    ((is-sep? c) 1)
                                                    (t -1))
                                              b)
                                          )))
                    (setq b (cond ((is-sep? c) 3)
                                  ((is-cap? c) 0)
                                  (t (min -1 (- b 1))))))
               finally return (apply 'vector r)))

(defun b-flx-process-cache (str cache)
  "Get calculated heatmap from cache, add it if necessary."
  (let ((res (when cache
               (gethash str cache))))
    (or res
        (progn
          (setq res (flx-get-hash-for-string
                     str
                     (or (and cache (gethash 'heatmap-func cache))
                         'str->heatmap)))
          (when cache
            (puthash str res cache))
          res))))

(defun b-flx-score (str query &optional cache)
  "return best score matching QUERY against STR"
  (let ((query (replace-regexp-in-string "\s+" "" query)))
    (let ((result (or (unless (or (zerop (length query))
                                  (zerop (length str)))
                        (let* ((info-hash (b-flx-process-cache str cache))
                               (heatmap (gethash 'heatmap info-hash))
                               (matches (flx-get-matches info-hash query))
                               (best-score nil))
                          (mapc (lambda (match-positions)
                                  (let ((score 0)
                                        (contiguous-count 0)
                                        last-match)
                                    (cl-loop for index in match-positions
                                             do (progn
                                                  (if (and last-match
                                                           (= (1+ last-match) index))
                                                      (cl-incf contiguous-count)
                                                    (setq contiguous-count 0))

                                                  (if (> contiguous-count 0)
                                                      (cl-incf score (+ 1 (* 2 (min contiguous-count 4))))
                                                    (cl-incf score (aref heatmap index)))

                                                  (if (< score -1)
                                                      (cl-return score))

                                                  (setq last-match index)))
                                    (if (or (null best-score)
                                            (> score (car best-score)))
                                        (setq best-score (cons score match-positions)))))
                                matches)
                          best-score)) (list 0))))
      result)))

(eval-when-compile (require 'cl))

(if (featurep 'xemacs)
    (require 'overlay))

;;
;; User configurable variables
;;

(defgroup fzy-locate nil
 "Globally find a file using locate."
  :tag "Fzy-Locate"
  :link '(url-link :tag "Home Page"
                   "http://www.emacswiki.org/cgi-bin/wiki/Fzy-Locate")
  :link '(emacs-commentary-link
          :tag "Commentary in fzy-locate.el" "fzy-locate.el")
  :prefix "fzloc-"
 :group 'convenience)

(defcustom fzloc-regexp-search nil
 "*Whether to use regular expression pattern matching."
 :type 'boolean
 :group 'fzy-locate)

(defcustom fzloc-databases nil
  "*List of database files separated with colon to be used by the
locate command. If nil then the system default database is used."
  :type 'string
  :group 'fzy-locate)

(setq fzloc-filter-regexps '("/target/"))

(defcustom fzloc-filter-regexps nil
 "*List of regular expressions to filter out unwanted files from the
output."
 :type '(repeat regexp)
 :group 'fzy-locate)

(defcustom fzloc-transform-regexps nil
 "*List of (REGEXP . REPLACEMENT) pairs to transform matching file
path names. It's useful when the matching path names are very long and
they have a component which can safely be replaced with a shorter
indicator string.

For example this rule:

    (push '(\"^/very/long/path/to/projectx/\" . \"<projx>/\")
      fzloc-transform-regexps)

will display file names under \"projectx\" like this:

    <projx>/sources/main.c
    <projx>/sources/test.c

"
 :type '(repeat (cons regexp regexp))
 :group 'fzy-locate)

(defcustom fzloc-minimum-input-length 5
  "*The minimum number of characters needed to start file searching."
  :type 'integer
  :group 'fzy-locate)

(defcustom fzloc-search-delay 0.5
  "*Idle time after last input event, before starting the search."
  :type 'number
  :group 'fzy-locate)

;(setq fzloc-matching-filename-limit 100)


(defcustom fzloc-matching-filename-limit 500
  "*If there are more matching file names than the given limit the
search is terminated automatically. This is useful if a too broad
search input is given and there are hundreds or thousands of matches.

If you don't want to limit the number of matches then set it to nil
instead of a very high number."
  :type '(choice integer (const nil))
  :group 'fzy-locate)

(defcustom fzloc-adaptive-selection nil
 "*If enabled the last file chosen for the same input is preselected
automatically instead of the first one in the list. If no exact input
match is found then the most recent input pattern which matches the
beginning of the current input is used.

Doesn't do anything if the user moves the selection manually, before a
file is selected automatically.

This option makes it possible to use a short input string to locate a
previously visited file again quickly."
 :type 'boolean
 :group 'fzy-locate)

(defcustom fzloc-history-length 100
  "*Number of previous file selections saved if
`fzloc-adaptive-selection' is enabled."
  :type 'integer
  :group 'fzy-locate)

(defcustom fzloc-history-file "~/.fzy-locate_history"
  "*Name of the history file where previous file selections saved if
`fzloc-adaptive-selection' is enabled."
  :type 'file
  :group 'fzy-locate)


(defface fzloc-selection-face
  ;; check if inherit attribute is supported
  (if (assq :inherit custom-face-attributes)
      '((t (:inherit highlight :underline nil)))

    '((((class color) (background light))
       (:background "darkseagreen2"))
      (((class color) (background dark))
       (:background "darkolivegreen"))
      (t (:inverse-video t))))
  "Face for highlighting the currently selected file name.")


(defvar fzloc-map
  (let ((map (copy-keymap minibuffer-local-map)))
    (define-key map (kbd "C-n") 'fzloc-next-line)
    (define-key map (kbd "C-p") 'fzloc-previous-line)
    (define-key map (kbd "<prior>") 'fzloc-previous-page)
    (define-key map (kbd "<next>") 'fzloc-next-page)
    ;; I wanted to choose C-t as a homage to iswitchb, but
    ;; transpose-chars can be useful during pattern editing
    (define-key map (kbd "C-r") 'fzloc-toggle-regexp-search)
    (define-key map (kbd "<RET>") 'fzloc-exit-minibuffer)
    (define-key map (kbd "C-l") 'fzloc-insert-last-search)
    map)
  "Keymap for fzy-locate.")

;;
;; End of user configurable variables
;;

(defconst fzloc-buffer "*fzy-locate*"
  "Buffer used for finding files.")

(defconst fzloc-process nil
  "The current search process.")

(defvar fzloc-previous-input ""
  "The previous input substring used for searching.")

(defvar fzloc-overlay nil
  "Overlay used to highlight the current selection.")

(defvar fzloc-history nil
  "List of the previous file selections if
`fzloc-adaptive-selection' is enabled.")

(defvar fzloc-adaptive-selection-target nil
  "The search output filter looks for this file name in the output if
`fzloc-adaptive-selection' is enabled.")

(defun identity-filter (process string)
  (with-current-buffer fzloc-buffer
      (save-excursion
        (goto-char (point-max))
        (insert string)
        (insert "\n===== end ====="))))

(defun dumb-filter (process string)
  (with-current-buffer fzloc-buffer
      (save-excursion
        (goto-char (point-max))

        (insert "\n===== end ====="))))



(setq fzloc-output "")

(setq fzloc-score-cache (make-hash-table :test 'equal))
(setq fzloc-result-cache (make-hash-table :test 'equal))

(defun mem-score (n)
        (let ((cached-score (gethash '(n fzloc-previous-input) fzloc-score-cache)))
          (if (eql cached-score nil)
              (puthash '(n fzloc-previous-input)
                       (first (b-flx-score n fzloc-previous-input))
                       fzloc-score-cache)
            cached-score)))

(defun pred1 (x) (string-match "/target/" x))

(defun fzloc-output-filter (process string)
  "Avoid moving of point if the buffer is empty."

  ;;(print (concat "g-o-filter [" fzloc-previous-input "]  " (int-to-string (length fzloc-output))))

  (setq fzloc-output (concat fzloc-output string))

  (with-current-buffer fzloc-buffer
    (save-excursion
      (erase-buffer)

      (if (< 300 (list-length (split-string fzloc-output)))
          (progn (fzloc-kill-process)
                 (fzloc-set-state "killed")
                 (insert "too many results!" ))

        (let* ((split-list (split-string fzloc-output))
               (filter-list (remove-if #'pred1 split-list))
               (sort-list (sort filter-list
                                (lambda (a b) (>= (mem-score a)
                                                  (mem-score b)))))
               (dummy (setq original-max-lisp-eval-depth max-lisp-eval-depth))
               (dummy (setq max-lisp-eval-depth 5000)) ;; keep join-string from hitting max-list-eval-depth
               (final-str (join-string sort-list "\n"))
               (dummy (setq max-lisp-eval-depth original-max-lisp-eval-depth)))

          (insert final-str)
                                        ;          (insert fzloc-output)
          (insert "\n==end=="))))

    (if (= (overlay-start fzloc-overlay) ; no selection yet
           (overlay-end fzloc-overlay))
        (unless (= (point-at-eol) (point-max)) ; incomplete line
          (fzloc-mark-current-line)))))


(defun fzloc-mark-current-line ()
  "Mark current line with a distinctive color."
  (move-overlay fzloc-overlay (point-at-bol) (point-at-eol)))


(defun fzloc-previous-line ()
  "Move selection to the previous line."
  (interactive)
  (fzloc-move-selection 'next-line -1))


(defun fzloc-next-line ()
  "Move selection to the next line."
  (interactive)
  (fzloc-move-selection 'next-line 1))


(defun fzloc-previous-page ()
  "Move selection back with a pageful."
  (interactive)
  (fzloc-move-selection 'scroll-down nil))


(defun fzloc-next-page ()
  "Move selection forward with a pageful."
  (interactive)
  (fzloc-move-selection 'scroll-up nil))


(defun fzloc-move-selection (movefunc movearg)
  "Move the selection marker to a new position determined by
MOVEFUNC and MOVEARG."
  (unless (= (buffer-size (get-buffer fzloc-buffer)) 0)
    (save-selected-window
      (select-window (get-buffer-window fzloc-buffer))

      (condition-case nil
          (funcall movefunc movearg)
        (beginning-of-buffer (goto-char (point-min)))
        (end-of-buffer (goto-char (point-max))))

      ;; if line end is point-max then it's either an incomplete line or
      ;; the end of the output, so move up a line
      (if (= (point-at-eol) (point-max))
          (next-line -1))

      ;; if the user moved the selection then adaptive selection
      ;; shouldn't touch it
      (setq fzloc-adaptive-selection-target nil)

      (fzloc-mark-current-line))))


(defun fzloc-process-sentinel (process event)
  "Prevent printing of process status messages into the output buffer."
  (unless (eq 'run (process-status process))
    (fzloc-set-state "finished")))


(defun fzloc-check-input ()
  "Check input string and start/stop search if necessary."
  (if (sit-for fzloc-search-delay)
      (unless (equal (minibuffer-contents) fzloc-previous-input)
        (fzloc-restart-search))))


(defun fzloc-restart-search ()
  "Stop the current search if any and start a new one if needed."

  (let ((input (minibuffer-contents)))
    (setq fzloc-previous-input input)
    (setq fzloc-output "")

    (fzloc-kill-process)
    (with-current-buffer fzloc-buffer
      (erase-buffer))
    (fzloc-set-state "idle")

    (unless (or (equal input "")
                (< (length input) fzloc-minimum-input-length))
      (let ((cmd (append

                  (when fzloc-databases
                    (list (concat "--database="
                                  fzloc-databases)))

                  (if fzloc-regexp-search
                      (list "-r"))

                  (list (fzloc-wild-generate input)))))

        (setq fzloc-process
              (apply 'start-process "fzloc-process" nil
                     "mlocate"
                     cmd)))

      (fzloc-set-state "searching")
      (move-overlay fzloc-overlay (point-min) (point-min))

      (if fzloc-adaptive-selection
          (let ((item (assoc input fzloc-history)))
            ;; if no exact match found then try prefix match
            (unless item
              (let ((input-length (length input)))
                (setq item
                      (some (lambda (test-item)
                              (let ((str (car test-item)))
                                (when (and (> (length str) input-length)
                                           (string= (substring str 0
                                                               input-length)
                                                    input))
                                  test-item)))

                            fzloc-history))))

            (setq fzloc-adaptive-selection-target (cdr ))))

      (set-process-filter fzloc-process 'fzloc-output-filter)
                                        ;      (set-process-filter fzloc-process 'identity-filter)
                                        ;      (set-process-filter fzloc-process 'dumb-filter)
      (set-process-sentinel fzloc-process 'fzloc-process-sentinel))))

(defun fzloc-wild-generate (string)
  (concat "*"
          (replace-regexp-in-string "\s+" "*" string)
          "*"))

(defun fzloc-kill-process ()
  "Kill find process."
  (when fzloc-process
    ;; detach associated functions
    (set-process-filter fzloc-process nil)
    (set-process-sentinel fzloc-process nil)
    (delete-process fzloc-process)
    (setq fzloc-process nil)))


(defun fzloc-set-state (state)
  "Set STATE in mode line."
  (with-current-buffer fzloc-buffer
    (setq mode-line-process (concat "/"  (if fzloc-regexp-search
                                             "regexp"
                                           "glob")
                                    ":" state))
    (force-mode-line-update)))

(defun fzloc-toggle-regexp-search ()
  "Toggle state of regular expression pattern matching."
  (interactive)
  (setq fzloc-regexp-search (not fzloc-regexp-search))
  (fzloc-restart-search))

(defun fzloc-exit-minibuffer ()
  "Store the current pattern and file name in `fzloc-history' if
`fzloc-adaptive-selection' is enabled and exit the minibuffer."
  (interactive)
  (if fzloc-adaptive-selection
      (let ((input (minibuffer-contents))
            (selected (fzloc-get-selected-file t)))
        (unless (or (equal input "")
                    (equal selected ""))
          (let ((item (assoc input fzloc-history)))
            (if item
                (setq fzloc-history (delete item fzloc-history)))
            (push (cons input selected) fzloc-history)

            (if (> (length fzloc-history) fzloc-history-length)
                (nbutlast fzloc-history))))))

  (exit-minibuffer)
  )

(defun fzloc-copy-file-name-and-exit ()
  "Copy selected file name and abort the search."
  (interactive)
  (kill-new (fzloc-get-selected-file))
  (exit-minibuffer))


(when fzloc-adaptive-selection
  (load-file fzloc-history-file)
  (add-hook 'kill-emacs-hook 'fzloc-save-history))

(defun fzloc-save-history ()
  "Save history of used pattern-file name pairs used by
`fzloc-adaptive-selection'."
  (interactive)
  (with-temp-buffer
    (insert
     ";; -*- mode: emacs-lisp -*-\n"
     ";; History entries used for fzy-locate adaptive selection.\n")
    (prin1 `(setq fzloc-history ',fzloc-history) (current-buffer))
    (insert ?\n)
    (write-region (point-min) (point-max) fzloc-history-file nil
                  (unless (interactive-p) 'quiet))))


(defun fzloc-get-selected-file (&optional rendered)
  "Return the currently selected file path.

If RENDERED is non-nil then the visible path name is returned instead
of the real path name of the file."
  (with-current-buffer fzloc-buffer
    (or (and (not rendered)
             (get-text-property (overlay-start fzloc-overlay)
                                'fzloc-orig-filename))
        (buffer-substring-no-properties (overlay-start fzloc-overlay)
                                        (overlay-end fzloc-overlay)))))

(defun fzloc-insert-last-search ()
  (interactive)
  (save-excursion
    (insert fzloc-most-recent-input))
      (end-of-line))

(defun fzloc-do ()
  "The guts of fzy-locate.
It expects that `fzloc-buffer' is selected already."

;;    (print "==== fzloc-do =======")
  (erase-buffer)
  (setq mode-name "Fzy-Locate")

  (if fzloc-overlay
      ;; make sure the overlay belongs to the fzy-locate buffer if
      ;; it's newly created
      (move-overlay fzloc-overlay (point-min) (point-min)
                    (get-buffer fzloc-buffer))

    (setq fzloc-overlay (make-overlay (point-min) (point-min)))
    (overlay-put fzloc-overlay 'face 'fzloc-selection-face))

  (fzloc-set-state "idle")
  (setq fzloc-previous-input "")
  (add-hook 'post-command-hook 'fzloc-check-input)

  (with-current-buffer fzloc-buffer
    (setq cursor-type nil))

  (unwind-protect
      (let ((minibuffer-local-map fzloc-map))
        (read-string "locate: "))

    (setq fzloc-most-recent-input fzloc-previous-input)

    (remove-hook 'post-command-hook 'fzloc-check-input)
    (fzloc-kill-process)

    (with-current-buffer fzloc-buffer
      (setq cursor-type t))))

(defun fzy-locate ()
  "Start global find file."
  (interactive)
;;  (print "==== fzy-locate =======")

  (let ((winconfig (current-window-configuration)))
    (pop-to-buffer fzloc-buffer)
    (unwind-protect
        (fzloc-do)
      (set-window-configuration winconfig)))

  (unless (or (= (buffer-size (get-buffer fzloc-buffer)) 0)
              (eq this-command 'fzloc-copy-file-name-and-exit))
    (find-file (fzloc-get-selected-file))))

;; this feature is experimental, that's why the variables are here

;; customize the popup frame according to your own taste and set (setq
;; gnuserv-frame (selected-frame)) to prevent gnuserv's own frame from
;; appearing

(setq fzloc-popup-frame (make-frame '((name . "Select file")
                                         (height . 30)
                                         (top . 200)
                                         (visibility . nil))))


;;
;; Invoke this function outside of emacs with
;;
;; 	gnuclient -eval '(fzloc-get-file-and-insert)'
;;
;; You can bind it to a global hotkey using xbindkeys. Note that the
;; function below uses xte to send the path to the active window.
;;

(defun fzloc-get-file-and-insert ()
  "Select a file with fzy-locate and send the path to the currently
selected application."
  (interactive)
  (let ((frame (selected-frame)))
    (unwind-protect
        (progn
          (make-frame-visible fzloc-popup-frame)
          (select-frame fzloc-popup-frame)
          (switch-to-buffer fzloc-buffer)
          (fzloc-do))

      (make-frame-invisible fzloc-popup-frame)))

  (let ((file (fzloc-get-selected-file)))
    (unless (equal file "")
      ;; it's needed for some reason
      (sit-for 1)
      (call-process "xte" nil nil nil (concat "str " file)))))


;;; XEmacs compatibility

(unless (fboundp 'minibuffer-contents)
  (defun minibuffer-contents ()
    "Return the user input in a minbuffer as a string.
The current buffer must be a minibuffer."
    (field-string (point-max))))

(provide 'fzy-locate)
;;; fzy-locate.el ends here
