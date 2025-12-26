;; --- 1. THE REDIRECTION ---
(setq custom-file (expand-file-name "custom.el" user-emacs-directory))
(when (file-exists-p custom-file)
  (load custom-file))

;; --- 2. THE CLEANUP ---
(setq make-backup-files nil)
(setq auto-save-default nil)
(setq auto-save-list-file-prefix nil)

;; --- 3. KEYBOARD & SYMBOLS ---
;; Keep Options free for German symbols ({ } [ ] @ |)
(setq ns-alternate-modifier 'none)
(setq ns-right-alternate-modifier 'none)

;; Keep Command keys as 'Super' for Mac shortcuts
(setq ns-command-modifier 'super)
(setq ns-right-command-modifier 'super)

;; --- 3a. SEPARATED CLIPBOARD ---
(setq select-enable-clipboard nil)

(defun mac-copy ()
  (interactive)
  (if (region-active-p)
      (shell-command-on-region (region-beginning) (region-end) "pbcopy")
    (message "No region selected")))

(defun mac-paste ()
  (interactive)
  (insert (shell-command-to-string "pbpaste")))

;; Mac-style shortcuts (using Command)
(global-set-key (kbd "s-c") 'mac-copy)
(global-set-key (kbd "s-v") 'mac-paste)
(global-set-key (kbd "s-s") 'save-buffer)
(global-set-key (kbd "s-z") 'undo)

;; --- 4. PACKAGE INITIALIZATION ---
(require 'package)
(setq package-archives '(("melpa" . "https://melpa.org/packages/")
                         ("gnu" . "https://elpa.gnu.org/packages/")))
(package-initialize)

(unless (package-installed-p 'evil)
  (package-refresh-contents)
  (package-install 'evil))
;; for renaming
(setq dired-dwim-target t)

;; --- 5. EVIL MODE (Vim) ---
(require 'evil)
(evil-mode 1)
(setq evil-select-enable-clipboard nil)

;; --- 6. UI & THEME ---
(set-face-attribute 'default nil :height 200)
(when (display-graphic-p)
  (tool-bar-mode -1)
  (scroll-bar-mode -1)
  (menu-bar-mode -1))

(load-theme 'gruber-darker t)
(global-display-line-numbers-mode t)
(setq display-line-numbers-type 'relative)
