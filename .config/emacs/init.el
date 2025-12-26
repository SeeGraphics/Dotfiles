;; Redirect to custom file
(setq custom-file (expand-file-name "custom.el" user-emacs-directory))
(when (file-exists-p custom-file)
  (load custom-file))

;; Cleanup files
(setq make-backup-files nil)
(setq auto-save-default nil)
(setq auto-save-list-file-prefix nil)

;; German symbols & Mac Modifiers
(setq ns-alternate-modifier 'none)
(setq ns-right-alternate-modifier 'none)
(setq ns-command-modifier 'super)
(setq ns-right-command-modifier 'super)

;; Clipboard Isolation
(setq select-enable-clipboard nil)

(defun mac-copy ()
  (interactive)
  (if (region-active-p)
      (shell-command-on-region (region-beginning) (region-end) "pbcopy")
    (message "No region selected")))

(defun mac-paste ()
  (interactive)
  (insert (shell-command-to-string "pbpaste")))

;; Global Keys
(global-set-key (kbd "s-c") 'mac-copy)
(global-set-key (kbd "s-v") 'mac-paste)
(global-set-key (kbd "s-s") 'save-buffer)
(global-set-key (kbd "s-z") 'undo)

;; Cmd + m to bring up the "Compile:" prompt at the bottom
(global-set-key (kbd "s-m") 'project-compile)

;; Cmd + f to bring up the "Find file:" prompt (like :e)
(global-set-key (kbd "s-f") 'find-file)

;; Cmd + d to open the Dired file explorer
(global-set-key (kbd "s-d") 'dired)

;; To make it even faster:
;; This tells Emacs to just use the last compile command 
;; without asking if you press a specific key (like Cmd + Shift + M)
(defun quick-compile ()
  "Compiles without asking for a command."
  (interactive)
  (compile compile-command))

(global-set-key (kbd "s-M") 'quick-compile) ;; Cmd + Shift + M

;; Package Initialization
(require 'package)
(setq package-archives '(("melpa" . "https://melpa.org/packages/")
                         ("gnu" . "https://elpa.gnu.org/packages/")))
(package-initialize)

;; VTERM CONFIG 
(with-eval-after-load 'vterm
  (define-key vterm-mode-map (kbd "s-v") 'vterm-yank))

;; Evil Mode
(unless (package-installed-p 'evil)
  (package-refresh-contents)
  (package-install 'evil))
(require 'evil)
(evil-mode 1)
(setq evil-select-enable-clipboard nil)

;; UI & Theme
;; Set Iosevka as the default font
(set-face-attribute 'default nil 
                    :font "Iosevka" 
                    :height 180    ;; Adjusted height for Iosevka's slim profile
                    :weight 'normal)

;; Optional: Ensure fixed-pitch (monospaced) looks the same
(set-face-attribute 'fixed-pitch nil :font "Iosevka" :height 180)
(when (display-graphic-p)
  (tool-bar-mode -1)
  (scroll-bar-mode -1)
  (menu-bar-mode -1))

(load-theme 'gruber-darker t)
(global-display-line-numbers-mode t)
(setq display-line-numbers-type 'relative)

;; Formatting
(unless (package-installed-p 'clang-format)
  (package-install 'clang-format))
(require 'clang-format)
(add-hook 'c++-mode-hook (lambda () (add-hook 'before-save-hook 'clang-format-buffer nil t)))
(add-hook 'c-mode-hook (lambda () (add-hook 'before-save-hook 'clang-format-buffer nil t)))

(setq dired-dwim-target t)
