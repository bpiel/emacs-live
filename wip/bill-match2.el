(defun str->chrlist (s)
  (butlast (rest  (split-string s ""))))

(str->chrlist "\\abc\\test.php")

(setq f "\\rjm\\SomeDir\\omeIrJm.php")

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

(str->heatmap f)


(defun is-cap? (c)
  (eq 0 (let ((case-fold-search nil))
           (string-match-p "^[A-Z]$" c))))

(defun is-sep? (c)
  (eq 0 (string-match-p "^[\\/.-]$" c)))

(is-cap? "A")

(is-cap? "d")

(is-sep? "-")

(string-match "^[A-Z]$" "d")

(str->heatmap f)

(print  (str->heatmap "thisIs-Atest-of-/the...americanBr.o.a.d.cast"))


(defun b-flx-score (str query &optional cache)
  "return best score matching QUERY against STR"
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
;    (if (> (car result) 20) (print (concat str " " query " " (int-to-string (car result)))))
    result))



(b-flx-score "Bobby" "Bob")
(b-flx-score "Bobby" "")
(or nil 0)

(flx-get-heatmap-str "Hello!")
(str->heatmap "Hello!")

(makunbound 'dummycache)

(defvar dummycache nil)

(print  (flx-process-cache "aaab" dummycache))


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
