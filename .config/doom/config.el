;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

(setq user-full-name "Alireza Safaeirad"
      user-mail-address "frontendmonster@gmail.com")

;; Remove empty line noises
;; Doom exposes five (optional) variables for controlling fonts in Doom:
;;
;; - `doom-font' -- the primary font to use
;; - `doom-variable-pitch-font' -- a non-monospace font (where applicable)
;; - `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;; - `doom-unicode-font' -- for unicode glyphs
;; - `doom-serif-font' -- for the `fixed-pitch-serif' face
;;
;; See 'C-h v doom-font' for documentation and more examples of what they
;; accept. For example:
(setq doom-font (font-spec :family "Cascadia Code" :size 14)
      doom-variable-pitch-font (font-spec :family "Roboto" :size 14)
      doom-big-font (font-spec :family "Input Mono" :size 20))

(custom-set-faces!
 '(font-lock-comment-face :slant italic)
 '(font-lock-keyword-face :slant italic))


(setq-default indicate-empty-lines nil)

;; If you or Emacs can't find your font, use 'M-x describe-font' to look them
;; up, `M-x eval-region' to execute elisp code, and 'M-x doom/reload-font' to
;; refresh your font settings. If Emacs still can't find your font, it likely
;; wasn't installed correctly. Font issues are rarely Doom issues!

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(setq doom-theme 'doom-gruvbox-light)

(setq display-line-numbers-type 'relative)

(after! org
  (setq org-directory "~/docs/orgs"
        org-hide-emphasis-markers t))


(setq deft-directory "~/docs/notes")
(setq fancy-splash-image "~/desktop/deer-light.png")
(custom-set-faces!
  '(doom-dashboard-footer      :inherit font-lock-comment-face)
  '(doom-dashboard-footer-icon :inherit all-the-icons-yellow)
  '(doom-dashboard-loaded      :inherit font-lock-comment-face)
  '(doom-dashboard-menu-desc   :inherit font-lock-comment-face)
  '(doom-dashboard-menu-title  :inherit font-lock-comment-face)
  '(header-line                :inherit :height 200)
  )

(setq-default header-line-format " ")

(remove-hook '+doom-dashboard-functions #'doom-dashboard-widget-shortmenu)
;(remove-hook '+doom-dashboard-functions #'doom-dashboard-widget-footer)
(remove-hook '+doom-dashboard-functions #'doom-dashboard-widget-loaded)
(set-window-margins (selected-window) 0 0)

;; Remove the modline indicator
(advice-add #'doom-modeline-segment--modals :override #'ignore)

;; Focus new window after splitting
(setq evil-split-window-below t
      evil-vsplit-window-right t)

;; Wakatime
(use-package! wakatime-mode
  :ensure t
  :if (executable-find "wakatime-cli")
  :init
  (setq wakatime-cli-path (executable-find "wakatime-cli"))
  :config
  (global-wakatime-mode))

;; Lint on save
(defun sk/eslint-fix-file ()
  (interactive)
  (message "eslint --fixing the file" (buffer-file-name))
  (shell-command (concat "eslint --fix " (buffer-file-name))))

(defun sk/eslint-fix-file-and-revert ()
  (interactive)
  (sk/eslint-fix-file)
  (revert-buffer t t))

(add-hook 'js2-mode-hook
          (lambda ()
            (add-hook 'after-save-hook #'sk/eslint-fix-file-and-revert)))

;; Vterm
;; (after! vterm
;;   (set-popup-rule! "*doom:vterm-popup:main" :size 0.25 :vslot -4 :select t :quit nil :ttl 0 :side 'right))

;; Lsp
(setq gc-cons-threshold 100000000)

