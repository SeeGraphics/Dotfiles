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
(global-set-key (kbd "C-c i") (lambda () (interactive) (find-file user-init-file)))
(global-set-key (kbd "C-c p") (lambda () (interactive) (dired "~/Documents/Programmieren")))

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

;; GLSL
(require 'glsl-mode)
(add-to-list 'auto-mode-alist '("\\.vs\\'" . glsl-mode))
(add-to-list 'auto-mode-alist '("\\.fs\\'" . glsl-mode))

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
;; Disable line wrapping (stop code from wrapping when font is large)
(setq-default truncate-lines t)

;; Also disable it for split windows specifically
(setq truncate-partial-width-windows t)

;; Prefer Unix line endings and UTF-8 to avoid showing ^M from CRLF files.
(set-language-environment "UTF-8")
(prefer-coding-system 'utf-8-unix)
(setq-default buffer-file-coding-system 'utf-8-unix)

(defun matteo/convert-crlf-to-lf ()
  "Remove CR characters and mark the buffer as Unix line endings."
  (interactive)
  (save-excursion
    (goto-char (point-min))
    (while (search-forward "\r" nil t)
      (replace-match "" nil t)))
  (set-buffer-file-coding-system 'utf-8-unix))

(defun matteo/auto-fix-line-endings ()
  "Auto-convert CRLF/CR to LF for local text buffers."
  (when (and buffer-file-name
             (not (file-remote-p buffer-file-name))
             (derived-mode-p 'prog-mode 'text-mode 'conf-mode))
    (save-excursion
      (goto-char (point-min))
      (when (search-forward "\r" nil t)
        (matteo/convert-crlf-to-lf)))))

(add-hook 'find-file-hook #'matteo/auto-fix-line-endings)
(add-hook 'before-save-hook #'matteo/auto-fix-line-endings)
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

;; Indentation Dots (leading spaces)
(setq-default indent-tabs-mode nil)

(defface matteo/indent-dots-face
  '((t (:foreground "gray50")))
  "Face used for indentation dots.")

(defconst matteo/indent-dots-char (decode-char 'ucs #x00B7))

(defun matteo/indent-dots--clear (start end)
  "Remove indentation dot properties between START and END."
  (with-silent-modifications
    (let ((pos start))
      (while (< pos end)
        (let ((next (next-single-property-change pos 'matteo/indent-dots nil end)))
          (when (get-text-property pos 'matteo/indent-dots)
            (remove-text-properties
             pos next '(matteo/indent-dots nil display nil face nil)))
          (setq pos next))))))

(defun matteo/indent-dots--apply (start end)
  "Apply indentation dots between START and END."
  (matteo/indent-dots--clear start end)
  (with-silent-modifications
    (save-excursion
      (goto-char start)
      (beginning-of-line)
      (while (< (point) end)
        (when (looking-at "[ \t]+")
          (let ((beg (match-beginning 0))
                (iend (match-end 0)))
            (goto-char beg)
            (while (< (point) iend)
              (let ((ch (char-after)))
                (cond
                 ((eq ch ?\s)
                  (add-text-properties
                   (point) (1+ (point))
                   `(matteo/indent-dots t
                     display ,(string matteo/indent-dots-char)
                     face matteo/indent-dots-face)))
                 ((eq ch ?\t)
                  (let* ((col (current-column))
                         (tab-len (- tab-width (% col tab-width))))
                    (add-text-properties
                     (point) (1+ (point))
                     `(matteo/indent-dots t
                       display ,(make-string tab-len matteo/indent-dots-char)
                       face matteo/indent-dots-face))))))
              (forward-char))))
        (forward-line 1)))))

(define-minor-mode matteo/indent-dots-mode
  "Show leading spaces as dots."
  :lighter " IndDots"
  (if matteo/indent-dots-mode
      (progn
        (jit-lock-register #'matteo/indent-dots--apply)
        (jit-lock-refontify))
    (jit-lock-unregister #'matteo/indent-dots--apply)
    (matteo/indent-dots--clear (point-min) (point-max))
    (jit-lock-refontify)))

(add-hook 'prog-mode-hook #'matteo/indent-dots-mode)

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

;; Consult
(unless (package-installed-p 'consult)
  (package-install 'consult))
(global-set-key (kbd "s-b") 'consult-buffer)
;; Alt + o to toggle last 2 files
(global-set-key (kbd "M-o") (lambda () (interactive)
                              (switch-to-buffer (other-buffer (current-buffer) t))))
;; Vertico - The vertical list interface
(unless (package-installed-p 'vertico)
  (package-install 'vertico))
(require 'vertico)
(vertico-mode 1)

;; Orderless - Allows searching "config init" to find "init.el"
(unless (package-installed-p 'orderless)
  (package-install 'orderless))
(require 'orderless)
(setq completion-styles '(orderless basic)
      completion-category-defaults nil
      completion-category-overrides '((file (styles partial-completion))))

;; Recentf - Enables "Recent Files" in consult-buffer
(recentf-mode 1)
