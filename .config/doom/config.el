;;; $DOOMDIR / config.el -* - lexical - binding: t; -* -

;; Place your private configuration here! Remember, you do not need to run 'doom
    ;; sync' after modifying this file!


    ;; Some functionality uses this to identify you, e.g.GPG configuration, email
    ;; clients, file templates and snippets.
(setq user - full - name "S-Kill"
      user - mail - address "frontendmonster@gmail.com")

    ;; Doom exposes five(optional) variables for controlling fonts in Doom.Here
    ;; are the three important ones:
;;
;; + `doom-font'
;; + `doom - variable - pitch - font'
    ;; + `doom-big-font' -- used for `doom - big - font - mode'; use this for
    ;; presentations or streaming.
;;
;; They all accept either a font - spec, font string("Input Mono-12"), or xlfd
    ;; font string.You generally only need these two:
;; (setq doom - font(font - spec : family "monospace" : size 12 : weight 'semi-light)
;; doom - variable - pitch - font(font - spec : family "sans" : size 13))

;; There are two ways to load a theme.Both assume the theme is installed and
    ;; available.You can either set`doom-theme' or manually load a theme with the
;; `load - theme' function. This is the default:
(setq doom - theme 'doom-one)

;; If you use`org' and don't want your org files in the default location below,
;; change `org - directory'. It must be set before org loads!
(setq org - directory "~/org/")

    ;; This determines the style of line numbers in effect.If set to`nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display - line - numbers - type t)
    (global - unset - key(kbd "C-b"))
    (global - unset - key(kbd "C-d"))
    ;; Match the word under cursor(i.e.make it an edit region).Consecutive presses will
    ;; incrementally add the next unmatched match.
;; (define - key evil - normal - state - map(kbd "C-b") 'evil-multiedit-match-and-next)
    ;;;; Match selected region.
;; (define - key evil - visual - state - map(kbd "C-b") 'evil-multiedit-match-and-next)
    ;;;; Insert marker at poinb
    ;; (define - key evil - insert - state - map(kbd "C-b") 'evil-multiedit-toggle-marker-here)

    ;;;; Same as M - d but in reverse.
;; (define - key evil - normal - state - map(kbd "C-B") 'evil-multiedit-match-and-prev)
    ;; (define - key evil - visual - state - map(kbd "C-B") 'evil-multiedit-match-and-prev)

    ;; Here are some additional functions / macros that could help you configure Doom:
;;
;; - `load!' for loading external *.el files relative to this one
;; - `use - package!' for configuring packages
    ;; - `after!' for running code after a package has loaded
;; - `add - load - path!' for adding directories to the `load-path', relative to
    ;; this file.Emacs searches the`load-path' when you load packages with
;;   `require' or `use-package'.
;; - `map!' for binding new keys
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c c k').
;; This will open documentation for it, including demos of how they are used.
;;
;; You can also try 'gd' (or 'C-c c d') to jump to their definition and see how
;; they are implemented.
(setq
 doom-font (font-spec :family "Input Mono" :size 12)
 projectile-project-search-path '("~/dev" "~/fullstacks" "~/smartsept")
 org-priority-faces '((65 :foreground "#F00000")
                      (66 :foreground "#A00000")
                      (67 :foreground "600000"))
 org-todo-keywords '((sequence "TODO(t)" "INPROGRESS(i)" "|" "DONE(d)"))
 org-todo-keyword-faces
 '(("TODO" :weight normal :underline t)
   ("DONE" :foreground "#00AA77" :weight normal :underline t)
   )
 )

(defun open-github-repo (repo)
  (browse-url (concat "https://github.com/" repo))
  )

(after! org
  (org-add-link-type "gh" #'open-github-repo)
  )
