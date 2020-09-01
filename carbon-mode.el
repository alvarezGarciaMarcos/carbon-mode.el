;;; carbon-mode.el --- description -*- lexical-binding: t; -*-
;;
;; Copyright (C) 2020 John Doe
;;
;; Author: Marcos Álvarez García <http://github/alvarezgarciamarcos>
;; Maintainer: Marcos Álvarez García <marcosalvarez1997@gmail.com>
;; Created: August 26, 2020
;; Modified: August 26, 2020
;; Version: 0.0.1
;; Keywords:
;; Homepage: https://github.com/alvarezgarciamarcos/carbon-mode
;; Package-Requires: ((emacs 27.1) (cl-lib "0.5"))
;;
;; This file is not part of GNU Emacs.
;;
;;; Commentary:
;;
;;  description
;;  This is a package that let's you get an image of your source code to prettify a little bit the output of it
;;
;;; Code:
;;;
(setq org-babel-default-header-args:carbon '((:results . "none")))
(require 'request)
(defun loadImage (code language filename backgroundColor)
  "Get a pretty image of your code with Carbon."
  (setq name filename)
  (search-forward "#+END_SRC")
  (insert "\n")
  (make-directory "images" :parents)
  (request
    "https://carbonara.now.sh/api/cook"
    :data (json-encode
           `((code . ,code) (backgroundColor . ,backgroundColor) (exportSize . 1x) (language . ,language) ))
    :headers '((Content-Type . application/json))
    :parser 'buffer-string
    :success (cl-function
              (lambda (&key data &allow-other-keys )
                (with-temp-file (format "./images/%s.png" name)
                  (insert data))
                (insert (format "[[./images/%s.png]]" name ))
                ))))



(define-derived-mode carbon-mode org-mode "carbon"
  "Prettify your code and display it in a beautiful image with Carbon"
  )

(defun org-babel-execute:carbon (body params)
  nil
  (let ((language (assoc-default :language params))
        (resolution (assoc-default :resolution params))
        (filename (assoc-default :filename params))
        (backgroundColor (assoc-default :background params)))
    (loadImage body language filename backgroundColor)))

(provide 'carbon-mode)
;;; carbon-mode.el ends here
