;;; modus-ewal-theme.el --- Modus theme that uses pywal colors powered by ewal  -*- lexical-binding: t; -*-

;; Copyright (C) 2026

;; Author:  Oliwier Czerwiński <oliwier.czerwi@proton.me>
;; Keywords: faces theme
;; Version: 20260308
;; URL: https://github.com/deadendpl/modus-ewal-theme
;; Package-Requires: ((emacs "25.1") (modus-themes "5.2.0") (ewal))

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <https://www.gnu.org/licenses/>.

;;; Commentary:

;; A theme built with modus that uses pywal colors and tries to look
;; good out of the box.
;; It should look fine with both dark and light color schemes.

;;; Code:

(require 'ewal)
(require 'modus-themes)

(defgroup modus-ewal-theme nil
  "User options for modus-ewal-theme."
  :group 'faces)

(defvar modus-ewal-theme-base-palette
  (mapcar (lambda (element)
            (list (car element) (cdr element)))
          (let* ((colors (ewal-load-colors))
                 (colors (assq-delete-all 'comment colors))
                 (colors (assq-delete-all 'cursor colors))
                 (colors (assq-delete-all 'white colors))
                 (colors (assq-delete-all 'black colors)))
            (setcar (assoc 'background colors) 'bg-main)
            (setcar (assoc 'foreground colors) 'fg-main)
            colors))
  "The base pywal palette edited to work with modus.")

(defvar modus-ewal-theme-modus-palette
  (modus-themes-generate-palette modus-ewal-theme-base-palette)
  "Palette generated based on `modus-ewal-theme-base-palette'.")

(defvar modus-ewal-theme-custom-faces
  '(
    ;; region by default is wonky
    `(region ((,c :background
                  ,(modus-themes-generate-color-blend
                    bg-main
                    (if (modus-themes-color-dark-p bg-main)
                        "#ffffff"
                      "#000000")
                    0.9))))
    ;; in meow, it looked off
    `(secondary-selection
      ((,c :background
           ,(modus-themes-generate-color-blend
             bg-main
             (if (modus-themes-color-dark-p bg-main)
                 "#ffffff"
               "#000000")
             (if (modus-themes-color-dark-p bg-main)
                 0.85
               0.7))))))
  "Custom faces configuration.
Look at `modus-themes-faces' for an example.")

(defcustom modus-ewal-theme-load-after-regeneration-p t
  "Whether to load the theme after regenerating it."
  :group 'modus-ewal-theme
  :type 'boolean)

(defun modus-ewal-theme-reload-base-palette ()
  "Regenerate the base palette."
  (setq modus-ewal-theme-base-palette
        (mapcar (lambda (element)
                  (list (car element) (cdr element)))
                (let* ((colors (ewal-load-colors))
                       (colors (assq-delete-all 'comment colors))
                       (colors (assq-delete-all 'cursor colors))
                       (colors (assq-delete-all 'white colors))
                       (colors (assq-delete-all 'black colors)))
                  (setcar (assoc 'background colors) 'bg-main)
                  (setcar (assoc 'foreground colors) 'fg-main)
                  colors))))

(defun modus-ewal-theme-reload-modus-palette ()
  "Regenerate the base palette."
  (setq modus-ewal-theme-modus-palette
        (modus-themes-generate-palette modus-ewal-theme-base-palette)))

(defun modus-ewal-theme-generate-theme ()
  "Generate the theme."
  (modus-themes-theme
   'modus-ewal
   'modus-themes
   "A pywal theme."
   (if (modus-themes-color-dark-p
        (car (alist-get 'bg-main modus-ewal-theme-base-palette)))
       'dark
     'light)
   'modus-ewal-theme-modus-palette
   nil
   nil
   'modus-ewal-theme-custom-faces))

(defun modus-ewal-theme-regenerate-theme ()
  "Regenerate the theme.
If `modus-ewal-theme-load-theme-after-regeneration-p' is non-nil, reload
the theme as well."
  (modus-ewal-theme-reload-base-palette)
  (modus-ewal-theme-reload-modus-palette)
  (modus-ewal-theme-generate-theme)
  (when modus-ewal-theme-load-after-regeneration-p
    (load-theme 'modus-ewal t)))

;;;###autoload
(modus-ewal-theme-generate-theme)

(provide 'modus-ewal-theme)
;;; modus-ewal-theme.el ends here
