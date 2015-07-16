;; Emacs LIVE
;;
;; This is where everything starts. Do you remember this place?
;; It remembers you...

(setq live-ascii-art-logo ";;
;;                               ╥▓█▒
;;                             ╓╬███▓─
;;                  ╣█▌╥      ╓▓█╩╚█▓┐           ╥
;;                 ╥▓▌▓▓╥    ╦▓█╨ ╠██┐        ╦╬▓▓╨
;;                 ▓▓┘╚▓█─  ╬█▌   ╚█▓┐    ╓╥╬█▀╨
;;       ╥▄╕       ▓▌  ╠█▓▒▓█╩    ╠██┐ ╓╥▓▓▀╨        ╓▄▄▓▓▒─
;;       ╙▓█▒┐    ╬▓▒  └╫██▓      ╙█▌░▓█▀╨    ╓╥▄▄▓█▓▓▓╨╙└
;;        ╩██▓▄   ▓▓╨   ╙▀╨           └      ╙▀▀██▌│
;;         ╫▓▒╢▓▒ █▒           ╓▄▀▓▓▒            ╩▓▓╦
;;         ╫█▌ ╚▓▓▓░    ┌▒▒ ╥╬▓▓▀╙└                ╚█▓╦
;;    ╥    ╠█▓  └▀╨─  ╓╬▓╨╦▓█╩└                      ╫█▒─
;;   ╚▓█   ╠█▓       ╟▓▀   ╙                          ╙█▓╕
;;    ╙█▓░ ╫█▌                     ┌      ╫▓▓╥         ╙╣█╦╥╥
;; ╓▄   █▓╦╙╙                     ╖█▓▓    ╙╫██╥          ╨█▓▓▓╦
;; ╙▀▓▒╥└▀▒                       └▓██▒  ╓╥▄╫▓▒           ▓▓▄▓▌
;;    ╚▓▄┐                          ╩▓▀┴└▀▀╙└║▓▓           ╣█▌┘
;;   ╥▄▓▓┴                                  ╓▄█▌        ╓╥╥╓▓▌─
;;  ┌▀╩▒▄┬                                ╚╬▓╩╙    ╥▄▄▓███▀░╫▓┘
;;   ╬▓▓╨▄╥                                 ╓▄▄▄▓███████▓╨ ▒▓▌
;;   ╙│╦▓▌╨╟▓▓▓▓▓▓▒─                  ╓╓▄▓▓████████████╨  ╬▓▀
;;     ╨╨   ╔╬█╩╨└              ╓╥▄▓▓███▓▓██████████▓╨  ▄▓▒┘
;;         ╥▓▓              ▒▓███████▌╙    ╙▓█████▓╙ ╓▄▓▀╨
;;         ╙▓▓              └╙╨▀▓████▄    ╓▄████╨└ ╓╬▓▀
;;          └╢▓▓╗▄╥╥▄▄▄▓▓▓▒╗       ╙╨╫╬╣▓▓██▓╨╙╓╥╬▓▓▒╥╥
;;             ╙╙╚╩╩╨╙╙╙└ ╙▀▀▓▓▄╥┌          ╥▄▓▓╢╟▓▌║▓█╫▓▓▒▄▄┐   ▄▓▀▀▒╥
;;                            ╙╚╣▓▓▒▒▄╥╥▄╬▓╩╣▒▒▓▓██▌╫▓▒╚▓▒╙▓█▓▒▒▓▀╨  ╫▒
;;                           ╓╗▓▓▓█▒╨╙╨╫╫▒▓▓▓▀╨╙ ╩╫░╣▓ ╠▓░╥▓█▌  └    ╫▓╕
;;                       ╓▄▓▓▒╨╢▓▒╙█▓▓▓▀▀╨╙  ╓▄▄▓▓▓▓█▒┌▓▓░▓╫▓▓▄╥      ╙╫▒┐
;;             ╓┌     ╦╬╣██▒▓▓▒ ╫▓▒╠█▌╥╥▄▄▓▓▓▓▀╨╨░╓▓█▄╠█▒─█▓╫▒╫▌     ╥╥╣▓▒
;;          ╓▒▓╩╬▓╥╥╥╫█▓▄╙╫█╦║▓▒┌║█▒╠█▓╫║╫▄▄▄▓▓▓▓▓▓▓▓▓╨▀╫▓██▓▒╫▒┌▒╥  ╫▓▀└
;;          ╨╫▒  ╙╫▀╨└ ╙▓▓▄╙▓▒╙╫▌╥╠█▓▓▓▀▀▀▀╨╙╙╙░╓╓╥▄╬▓▒    ╙└ ╩▓▓▓▓▄▄▓▒
;;           ╙▓▒─     ▒▒╨║██▒▓▓▄▓█▌▀▓▒▄▄╬▓▓▓▓▓▓▓▓▓▓▀▀▓█           ╙╢▀╨
;;          ╥▓▓└      ╚╫▒  ╙▓▓█▀╙   ╫█▀╙╙╙╙└╓╓╓╥╥╥╥▄╥╬█▒
;;         ╓╣▓     ░╣▄┌╫█    └      ╚█▓▓▓▓▓▓▓▓▓▓▀▀▀▀╨╨║█░
;;          ╠╫▒▓▒  ╥╫▒╩╣╨           ╫█░               ▐█▒
;;             ╙╫▓▓▓╩         ╥╥    ╫█▒▒▒▓▓▓▓▓▓▓▓▓▓▓▓▓▓█▓┐
")

(message (concat "\n\n" live-ascii-art-logo "\n\n"))

(add-to-list 'command-switch-alist
             (cons "--live-safe-mode"
                   (lambda (switch)
                     nil)))

(setq live-safe-modep
      (if (member "--live-safe-mode" command-line-args)
          "debug-mode-on"
        nil))

(setq initial-scratch-message "
;; I'm sorry, Emacs Live failed to start correctly.
;; Hopefully the issue will be simple to resolve.
;;
;; First up, could you try running Emacs Live in safe mode:
;;
;;    emacs --live-safe-mode
;;
;; This will only load the default packs. If the error no longer occurs
;; then the problem is probably in a pack that you are loading yourself.
;; If the problem still exists, it may be a bug in Emacs Live itself.
;;
;; In either case, you should try starting Emacs in debug mode to get
;; more information regarding the error:
;;
;;    emacs --debug-init
;;
;; Please feel free to raise an issue on the Gihub tracker:
;;
;;    https://github.com/overtone/emacs-live/issues
;;
;; Alternatively, let us know in the mailing list:
;;
;;    http://groups.google.com/group/emacs-live
;;
;; Good luck, and thanks for using Emacs Live!
;;
;;                _.-^^---....,,--
;;            _--                  --_
;;           <          SONIC         >)
;;           |       BOOOOOOOOM!       |
;;            \._                   _./
;;               ```--. . , ; .--'''
;;                     | |   |
;;                  .-=||  | |=-.
;;                  `-=#$%&%$#=-'
;;                     | ;  :|
;;            _____.,-#%&$@%#&#~,._____
;;      May these instructions help you raise
;;                  Emacs Live
;;                from the ashes
")

(setq live-supported-emacsp t)

(when (version< emacs-version "24.3")
  (setq live-supported-emacsp nil)
  (setq initial-scratch-message (concat "
;;                _.-^^---....,,--
;;            _--                  --_
;;           <          SONIC         >)
;;           |       BOOOOOOOOM!       |
;;            \._                   _./
;;               ```--. . , ; .--'''
;;                     | |   |
;;                  .-=||  | |=-.
;;                  `-=#$%&%$#=-'
;;                     | ;  :|
;;            _____.,-#%&$@%#&#~,._____
;;
;; I'm sorry, Emacs Live is only supported on Emacs 24.3+.
;;
;; You are running: " emacs-version "
;;
;; Please upgrade your Emacs for full compatibility.
;;
;; Latest versions of Emacs can be found here:
;;
;; OS X GUI     - http://emacsformacosx.com/
;; OS X Console - via homebrew (http://mxcl.github.com/homebrew/)
;;                brew install emacs
;; Windows      - http://alpha.gnu.org/gnu/emacs/windows/
;; Linux        - Consult your package manager or compile from source

"))
  (let* ((old-file (concat (file-name-as-directory "~") ".emacs-old.el")))
    (if (file-exists-p old-file)
      (load-file old-file)
      (error (concat "Oops - your emacs isn't supported. Emacs Live only works on Emacs 24.3+ and you're running version: " emacs-version ". Please upgrade your Emacs and try again, or define ~/.emacs-old.el for a fallback")))))

(let ((emacs-live-directory (getenv "EMACS_LIVE_DIR")))
  (when emacs-live-directory
    (setq user-emacs-directory emacs-live-directory)))

(when live-supported-emacsp
;; Store live base dirs, but respect user's choice of `live-root-dir'
;; when provided.
(setq live-root-dir (if (boundp 'live-root-dir)
                          (file-name-as-directory live-root-dir)
                        (if (file-exists-p (expand-file-name "manifest.el" user-emacs-directory))
                            user-emacs-directory)
                        (file-name-directory (or
                                              load-file-name
                                              buffer-file-name))))

(setq
 live-tmp-dir      (file-name-as-directory (concat live-root-dir "tmp"))
 live-etc-dir      (file-name-as-directory (concat live-root-dir "etc"))
 live-pscratch-dir (file-name-as-directory (concat live-tmp-dir  "pscratch"))
 live-lib-dir      (file-name-as-directory (concat live-root-dir "lib"))
 live-packs-dir    (file-name-as-directory (concat live-root-dir "packs"))
 live-autosaves-dir(file-name-as-directory (concat live-tmp-dir  "autosaves"))
 live-backups-dir  (file-name-as-directory (concat live-tmp-dir  "backups"))
 live-custom-dir   (file-name-as-directory (concat live-etc-dir  "custom"))
 live-load-pack-dir nil
 live-disable-zone nil)

;; create tmp dirs if necessary
(make-directory live-etc-dir t)
(make-directory live-tmp-dir t)
(make-directory live-autosaves-dir t)
(make-directory live-backups-dir t)
(make-directory live-custom-dir t)
(make-directory live-pscratch-dir t)

;; Load manifest
(load-file (concat live-root-dir "manifest.el"))

;; load live-lib
(load-file (concat live-lib-dir "live-core.el"))

;;default packs
(let* ((pack-names '("foundation-pack"
                     "colour-pack"
                     "lang-pack"
                     "power-pack"
                     "git-pack"
                     "org-pack"
                     "clojure-pack"
                     "bindings-pack"))
       (live-dir (file-name-as-directory "stable"))
       (dev-dir  (file-name-as-directory "dev")))
  (setq live-packs (mapcar (lambda (p) (concat live-dir p)) pack-names) )
  (setq live-dev-pack-list (mapcar (lambda (p) (concat dev-dir p)) pack-names) ))

;; Helper fn for loading live packs

(defun live-version ()
  (interactive)
  (if (called-interactively-p 'interactive)
      (message "%s" (concat "This is Emacs Live " live-version))
    live-version))

;; Load `~/.emacs-live.el`. This allows you to override variables such
;; as live-packs (allowing you to specify pack loading order)
;; Does not load if running in safe mode
(let* ((pack-file (concat (file-name-as-directory "~") ".emacs-live.el")))
  (if (and (file-exists-p pack-file) (not live-safe-modep))
      (load-file pack-file)))

;; Load all packs - Power Extreme!
(mapc (lambda (pack-dir)
          (live-load-pack pack-dir))
        (live-pack-dirs))

(setq live-welcome-messages
      (list "
;; When a kid grows up, he has to be something. He can’t just stay the way he is.
;; But a tiger grows up and stays a tiger why is that? -- Calvin"
            "
;; As you can see, I have memorized this utterly useless piece of information long enough to pass a test question.
;; I now intend to forget it forever. -- Calvin"
            "
;; I like maxims that don't encourage behavior modification. -- Calvin"
            "
;; I think grown-ups just act like they know what they are doing. -- Calvin"))


(defun live-welcome-message ()
  (nth (random (length live-welcome-messages)) live-welcome-messages))

(when live-supported-emacsp
  (setq initial-scratch-message (concat live-ascii-art-logo ";; Emacs LIVE Version " live-version
                                                                (if live-safe-modep
                                                                    "
;;                                                     --*SAFE MODE*--"
                                                                  "
;;"
                                                                  ) "
;;           http://github.com/overtone/emacs-live
;;"                                                      (live-welcome-message) "

"))))

(if (not live-disable-zone)
    (add-hook 'term-setup-hook 'zone))

(if (not custom-file)
    (setq custom-file (concat live-custom-dir "custom-configuration.el")))
(when (file-exists-p custom-file)
  (load custom-file))

;; Bill's stuff
(message "\n\n Doing Bill's stuff \n\n")

(global-unset-key (kbd "C-z")) ;; get rid of "suspend frame"
(cua-mode 0) ;; kill CUA

(git-gutter:linum-setup) ;; git gutter linum compatibility
(global-linum-mode t)
(add-to-list 'package-archives
             '("melpa" . "http://melpa.org/packages/") t)

(global-set-key (kbd  "C-,") 'beginning-of-line-text)

(load-file "/home/bill/.emacs.d/lib/fzy-locate/fzy-locate.el")
(fzloc-load-dbs-from-path "/home/bill/repos/emacs-live/locatedbs/*.locatedb")
(setq fzloc-filter-regexps '("/target/" "/.git/"))

(global-set-key (kbd "C-x SPC") 'fzy-locate)
(global-set-key (kbd  "C-x p") 'ace-jump-mode-pop-mark)
(global-set-key (kbd  "C-x x") 'rgrep)

(defun refresh-emacs-locatedb ()
  (interactive)
  (message "Refreshing locatedb. This may take a bit...")
  (shell-command "/home/bill/bin/refresh-emacs-locatedb.sh")
  (message "Refresh completed."))

(global-set-key (kbd "C-c r") 'refresh-emacs-locatedb)

(setq frame-title-format
  '("" invocation-name ": "(:eval (if (buffer-file-name)
                (abbreviate-file-name (buffer-file-name))
                  "%b"))))

;; Finds the auto-highlight-symbol file and loads it
;; I have no idea why the next line is necessary, but 'require' wasn't working
(load-file (first (file-expand-wildcards "/home/bill/.emacs.d/elpa/auto-highlight-symbol-*/auto-highlight-symbol.el" )))
(add-to-list 'ahs-modes 'clojure-mode)
(setq ahs-default-range 'ahs-range-whole-buffer)
(global-auto-highlight-symbol-mode t)

(defun switch-to-most-recent-buffer ()
      (interactive)
      (switch-to-buffer (other-buffer (current-buffer) 1)))
(global-set-key (kbd  "C-M-<return>") 'switch-to-most-recent-buffer)
(global-set-key (kbd  "C-M-<backspace>") 'revert-buffer)
(global-set-key (kbd  "C-S-o") 'ace-jump-char-mode)

;; https://github.com/clojure-emacs/cider#basic-configuration
(setq cider-auto-select-error-buffer nil)

(set-face-attribute 'rainbow-delimiters-depth-1-face nil :foreground "#BB2222")
(set-face-attribute 'rainbow-delimiters-depth-2-face nil :foreground "#BB7700")
(set-face-attribute 'rainbow-delimiters-depth-3-face nil :foreground "#BBBB22")
(set-face-attribute 'rainbow-delimiters-depth-4-face nil :foreground "#11BB11")
(set-face-attribute 'rainbow-delimiters-depth-5-face nil :foreground "#33BBBB")
(set-face-attribute 'rainbow-delimiters-depth-6-face nil :foreground "#5555AA")
(set-face-attribute 'rainbow-delimiters-depth-7-face nil :foreground "#AA55AA")
(set-face-attribute 'rainbow-delimiters-depth-8-face nil :foreground "#BBBBBB")
(set-face-attribute 'rainbow-delimiters-depth-9-face nil :foreground "#66FF66")

(defun sudo-edit (&optional arg)
  "Edit currently visited file as root. With a prefix ARG prompt
for a file to visit. Will also prompt for a file to visit if
current buffer is not visiting a file."
  (interactive "P")
  (if (or arg (not buffer-file-name))
      (find-file (concat "/sudo:root@localhost:"
                         (ido-read-file-name "Find file(as root): ")))
    (find-alternate-file (concat "/sudo:root@localhost:" buffer-file-name))))

(defun insert-spyd ()
  (interactive)
  (insert "#spy/d")
  (live-delete-whitespace-except-one))

(global-set-key (kbd "C-c s d") 'insert-spyd)
(global-set-key (kbd "C-c !") 'cider-load-buffer)


;; END Bill's stuff

(message "\n\n Pack loading completed. Your Emacs is Live...\n\n")
(put 'erase-buffer 'disabled nil)
(put 'downcase-region 'disabled nil)
