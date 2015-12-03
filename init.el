;; packages
(setq package-archives '(("gnu" . "http://elpa.gnu.org/packages/")
                         ("org" . "http://orgmode.org/elpa/")
                         ("marmalade" . "http://marmalade-repo.org/packages/")
                         ("melpa" . "http://melpa.milkbox.net/packages/")))
(package-initialize)

(defun require-package (package)
  (setq-default highlight-tabs t)
  "Install given PACKAGE."
  (unless (package-installed-p package)
    (unless (assoc package package-archive-contents)
      (package-refresh-contents))
    (package-install package)))

(require 'evil)
(evil-mode 1)
(define-key evil-normal-state-map (kbd "j") 'evil-next-visual-line)
(define-key evil-normal-state-map (kbd "k") 'evil-previous-visual-line)

(require 'clang-format)

(require 'evil-org)
;; gh	outline-up-heading
;; gj	org-forward-heading-same-level
;; gk	org-backward-heading-same-level
;; gl	outline-next-visible-heading
;; t	org-todo
;; T	org-insert-todo-heading nil
;; H	org-beginning-of-line
;; L	org-end-of-line
;; o	always-insert-item
;; O	org-insert-heading
;; ’$’	org-end-of-line
;; ’^’	org-beginning-of-line
;; <	org-metaleft
;; >	org-metaright
;; <leader>a	org-agenda
;; <leader>t	org-show-todo-tree
;; <leader>c	org-archive-subtree
;; <leader>l	evil-org-open-links
;; <leader>o	evil-org-recompute-clocks
;; TAB	org-cycle
;; M-l	org-metaright
;; M-h	org-metaleft
;; M-k	org-metaup
;; M-j	org-metadown
;; M-L	org-shiftmetaright
;; M-H	org-shiftmetaleft
;; M-K	org-shiftmetaup
;; M-J	org-shiftmetadown
;; M-o	org-insert-heading+org-metaright
;; M-t	org-insert-todo-heading nil+ org-metaright

;; (require 'powerline)
;; (require 'powerline-evil)
;; (powerline-evil-center-color-theme)

(setq custom-safe-themes t)

(require 'smart-mode-line)
(setq sml/theme 'light)
(sml/setup)

(require 'evil-leader)
(global-evil-leader-mode)
(evil-leader/set-leader "<SPC>")

(require 'evil-commentary)
(evil-commentary-mode)
(evil-define-key 'normal evil-commentary-mode-map " /" 'evil-commentary)

(require 'fsharp-mode)
(evil-define-key 'normal fsharp-mode-map (kbd "SPC c") 'compile)
(evil-define-key 'normal fsharp-mode-map (kbd "SPC t") 'fsharp-ac/show-tooltip-at-point)
(evil-define-key 'normal fsharp-mode-map (kbd "SPC d") 'fsharp-ac/gotodefn-at-point)
(evil-define-key 'normal fsharp-mode-map (kbd "SPC .") 'fsharp-ac/complete-at-point)
(evil-define-key 'normal fsharp-mode-map (kbd "SPC p") 'fsharp-ac/load-project)

;;; autocomplete snippets
(require 'yasnippet)
(yas-global-mode 1)

; autocomplete keywords
(require 'auto-complete)
(require 'auto-complete-config)
(ac-config-default)

;; irony mode
(require 'irony)
(add-hook 'c++-mode-hook 'irony-mode)
(add-hook 'c-mode-hook 'irony-mode)
(add-hook 'objc-mode-hook 'irony-mode)

;; company (autocomplete menu)
(add-hook 'after-init-hook 'global-company-mode)
(eval-after-load 'company
  '(add-to-list 'company-backends 'company-irony))
;; (optional) adds CC special commands to `company-begin-commands' in order to
;; trigger completion at interesting places, such as after scope operator
;;     std::|
(add-hook 'irony-mode-hook 'company-irony-setup-begin-commands)

;; replace the `completion-at-point' and `complete-symbol' bindings in
;; irony-mode's buffers by irony-mode's function
(defun my-irony-mode-hook ()
  (define-key irony-mode-map [remap completion-at-point]
    'irony-completion-at-point-async)
  (define-key irony-mode-map [remap complete-symbol]
    'irony-completion-at-point-async))
(add-hook 'irony-mode-hook 'my-irony-mode-hook)
(add-hook 'irony-mode-hook 'irony-cdb-autosetup-compile-options)

;; SLIME
(setq inferior-lisp-program "sbcl")
(add-to-list 'load-path "/usr/share/emacs/site-lisp/slime/")
(require 'slime)
(slime-setup '(slime-fancy))

(if (file-directory-p "~/quicklisp")
  (load (expand-file-name "~/quicklisp/slime-helper.el"))
    (setq inferior-lisp-program "sbcl") )

;; shortcuts
(define-key evil-normal-state-map (kbd "<SPC>seb") 'slime-eval-buffer) ; Slime Eval Buffer
(define-key evil-normal-state-map (kbd "<SPC>set") 'slime-eval-defun)  ; Slime Eval Toplevel
(define-key evil-normal-state-map (kbd "<SPC>ss")  'slime)

;; rainbow parens
(require 'rainbow-delimiters)
(add-hook 'prog-mode-hook #'rainbow-delimiters-mode)

;; esc quits
(defun minibuffer-keyboard-quit ()
  "Abort recursive edit.
In Delete Selection mode, if the mark is active, just deactivate it;
then it takes a second \\[keyboard-quit] to abort the minibuffer."
  (interactive)
  (if (and delete-selection-mode transient-mark-mode mark-active)
      (setq deactivate-mark  t)
    (when (get-buffer "*Completions*") (delete-windows-on "*Completions*"))
    (abort-recursive-edit)))
(define-key evil-normal-state-map [escape] 'keyboard-quit)
(define-key evil-visual-state-map [escape] 'keyboard-quit)
(define-key minibuffer-local-map [escape] 'minibuffer-keyboard-quit)
(define-key minibuffer-local-ns-map [escape] 'minibuffer-keyboard-quit)
(define-key minibuffer-local-completion-map [escape] 'minibuffer-keyboard-quit)
(define-key minibuffer-local-must-match-map [escape] 'minibuffer-keyboard-quit)
(define-key minibuffer-local-isearch-map [escape] 'minibuffer-keyboard-quit)
(global-set-key [escape] 'evil-exit-emacs-state)

;; highlight matching paren
(show-paren-mode t)

;; don't make backup files
(setq make-backup-files nil)

;; disable toolbar
(tool-bar-mode -1)

;; set tabwith
(setq-default c-basic-offset 4)

;; always scroll 3 lines at the time
(setq mouse-wheel-scroll-amount '(3 ((shift) . 3)))
(setq mouse-wheel-progressive-speed nil) 
(setq mouse-wheel-follow-mouse 't) 
(setq scroll-step 3)

;; fish fix
(add-hook 'term-mode-hook
          (lambda ()
            (toggle-truncate-lines)
            (setq term-prompt-regexp "^.*❯❯❯ ")
            (make-local-variable 'mouse-yank-at-point)
            (setq mouse-yank-at-point t)
            (make-local-variable 'transient-mark-mode)
            (setq transient-mark-mode nil)
            (setq yas-dont-activate t)))

(require 'color-theme-sanityinc-tomorrow)
(color-theme-sanityinc-tomorrow-eighties)
