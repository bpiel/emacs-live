(live-add-pack-lib "clojure-mode")

(eval-after-load 'find-file-in-project
  '(add-to-list 'ffip-patterns "*.clj"))

(require 'clojure-mode)

(add-hook 'clojure-mode-hook
          (lambda ()
            (setq buffer-save-without-query t)))

;;command to align let statements
;;To use: M-x align-cljlet
(live-add-pack-lib "align-cljlet")
(require 'align-cljlet)

;;Treat hyphens as a word character when transposing words
(defvar clojure-mode-with-hyphens-as-word-sep-syntax-table
  (let ((st (make-syntax-table clojure-mode-syntax-table)))
    (modify-syntax-entry ?- "w" st)
    st))

(defun live-transpose-words-with-hyphens (arg)
  "Treat hyphens as a word character when transposing words"
  (interactive "*p")
  (with-syntax-table clojure-mode-with-hyphens-as-word-sep-syntax-table
    (transpose-words arg)))

(define-key clojure-mode-map (kbd "M-t") 'live-transpose-words-with-hyphens)

(setq auto-mode-alist (append '(("\\.cljs$" . clojure-mode))
                              auto-mode-alist))

(dolist (x '(scheme emacs-lisp lisp clojure))
  (add-hook (intern (concat (symbol-name x) "-mode-hook")) 'enable-paredit-mode)
  (add-hook (intern (concat (symbol-name x) "-mode-hook")) 'rainbow-delimiters-mode))

(defun live-warn-when-cider-not-connected ()
      (interactive)
      (message "nREPL server not connected. Run M-x cider or M-x cider-jack-in to connect."))

(define-key clojure-mode-map (kbd "C-M-x")   'live-warn-when-cider-not-connected)
(define-key clojure-mode-map (kbd "C-x C-e") 'live-warn-when-cider-not-connected)
(define-key clojure-mode-map (kbd "C-c C-e") 'live-warn-when-cider-not-connected)
(define-key clojure-mode-map (kbd "C-c C-l") 'live-warn-when-cider-not-connected)
(define-key clojure-mode-map (kbd "C-c C-r") 'live-warn-when-cider-not-connected)
