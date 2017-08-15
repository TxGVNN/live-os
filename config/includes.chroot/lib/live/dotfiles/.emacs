;;; package --- Summary:
(require 'package)
(add-to-list 'package-archives
             '("melpa" . "https://melpa.org/packages/"))
(package-initialize)

;;; bootstrap `use-package'
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

;;; helm
(use-package helm
  :ensure t
  :init
  (require 'helm)
  (require 'helm-config)
  (helm-mode 1)
  (setq helm-mode-line-string "")
  (global-set-key (kbd "M-x") 'helm-M-x)
  (global-set-key (kbd "C-x C-f") 'helm-find-files)
  (add-to-list 'helm-sources-using-default-as-input 'helm-source-man-pages)
  (define-key global-map (kbd "C-c m") 'helm-imenu)
  (define-key global-map (kbd "C-x b") 'helm-buffers-list))

;;; helm-project
(use-package helm-projectile
  :ensure t
  :init
  (projectile-global-mode)
  (setq projectile-completion-system 'helm)
  (helm-projectile-on))

 ;;; which-key
(use-package which-key
  :ensure t
  :init (which-key-mode))

;;; neotree
(use-package neotree
  :ensure t
  :init
  (global-set-key [f3] 'neotree-toggle)
  (global-set-key [f2] 'neotree-find))

;;; flycheck
(use-package flycheck
  :ensure t
  :init (global-flycheck-mode))


;;; helm-gtags
(use-package helm-gtags
  :ensure t
  :init
  ;;; Enable helm-gtags-mode
  (add-hook 'c-mode-hook 'helm-gtags-mode)
  (add-hook 'c++-mode-hook 'helm-gtags-mode)
  (add-hook 'asm-mode-hook 'helm-gtags-mode)
  (add-hook 'php-mode-hook 'helm-gtags-mode)
  (eval-after-load "helm-gtags"
    '(progn
       (define-key helm-gtags-mode-map (kbd "C-c t f") 'helm-gtags-find-tag)
       (define-key helm-gtags-mode-map (kbd "C-c t r") 'helm-gtags-find-rtag)
       (define-key helm-gtags-mode-map (kbd "C-c t s") 'helm-gtags-find-symbol)
       (define-key helm-gtags-mode-map (kbd "C-c t g") 'helm-gtags-parse-file)
       (define-key helm-gtags-mode-map (kbd "C-c t p") 'helm-gtags-previous-history)
       (define-key helm-gtags-mode-map (kbd "C-c t n") 'helm-gtags-next-history)
       (define-key helm-gtags-mode-map (kbd "C-c t t") 'helm-gtags-pop-stack)))
  )

;;; git-gutter
(use-package git-gutter
  :ensure t
  :init
  (global-git-gutter-mode 1)
  (git-gutter:linum-setup)
  (global-set-key (kbd "C-c g p") 'git-gutter:previous-hunk)
  (global-set-key (kbd "C-c g n") 'git-gutter:next-hunk)
  )

;;; magit
(use-package magit
  :ensure t
  :init
  (global-set-key (kbd "C-c g s") 'magit-status)
  (global-set-key (kbd "C-c g a") 'magit-stage)
  (global-set-key (kbd "C-c g p") 'magit-push)
  (global-set-key (kbd "C-c g d") 'magit-diff)
  (global-set-key (kbd "C-c g l") 'magit-log)
  (global-set-key (kbd "C-c g o") 'magit-log-all)
  )

;;; switch-window
(use-package switch-window
  :ensure t
  :init
  (global-set-key (kbd "C-x o") 'switch-window)
  )

;; multiple-cursors
(use-package multiple-cursors
  :ensure t
  :init
  (global-set-key (kbd "C-c e a") 'mc/mark-all-like-this)
  (global-set-key (kbd "C-c e n") 'mc/mark-next-like-this)
  (global-set-key (kbd "C-c e p") 'mc/mark-previous-like-this)
  )

;;; hook
(add-hook 'git-gutter:update-hooks 'magit-after-revert-hook)
(add-hook 'git-gutter:update-hooks 'magit-not-reverted-hook)

;;; c-mode, c++-mode, objc-mode, java-mode
(defun my-c-mode-common-hook ()
  (c-set-offset 'substatement-open 0)
  (setq c++-tab-always-indent t)
  (setq c-basic-offset 4)                  ;; Default is 2
  (setq c-indent-level 4)                  ;; Default is 2
  (setq tab-stop-list '(4 8 12 16 20 24 28 32 36 40 44 48 52 56 60))
  )
(add-hook 'c-mode-common-hook 'my-c-mode-common-hook)


;;; customize
(defalias 'yes-or-no-p 'y-or-n-p)
(global-set-key (kbd "M-o") 'mode-line-other-buffer)
(global-set-key (kbd "C-c .") 'shell)
(set-default-font "Inconsolata 11")

;;; number key
(global-set-key (kbd "M-[ A") 'previous-line)
(global-set-key (kbd "M-[ B") 'next-line)
(global-set-key (kbd "M-[ C") 'left-char)
(global-set-key (kbd "M-[ D") 'right-char)
(global-set-key (kbd "M-O x") 'previous-line)
(global-set-key (kbd "M-O r") 'next-line)
(global-set-key (kbd "M-O t") 'left-char)
(global-set-key (kbd "M-O v") 'right-char)
(global-set-key (kbd "M-O y") 'scroll-down-command)
(global-set-key (kbd "M-O s") 'scroll-up-command)
(global-set-key (kbd "M-O w") 'move-beginning-of-line)
(global-set-key (kbd "M-O q") 'move-end-of-line)
(global-set-key (kbd "M-O m") 'newline)

(defun indent-buffer ()
  (interactive)
  (save-excursion
    (indent-region (point-min) (point-max) nil)))
(global-set-key [f12] 'indent-buffer)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(Buffer-menu-use-header-line nil)
 '(column-number-mode t)
 '(custom-enabled-themes (quote (deeper-blue)))
 '(default-input-method "vietnamese-telex")
 '(global-linum-mode t)
 '(helm-gtags-auto-update t)
 '(indent-tabs-mode nil)
 '(menu-bar-mode nil)
 '(package-selected-packages
   (quote
    (dockerfile-mode go-mode helm-gitlab gitlab kubernetes yaml-mode bitbucket helm which-key use-package switch-window nhexl-mode neotree multiple-cursors markdown-mode magit helm-projectile helm-gtags helm-ag git-gutter flycheck ac-php)))
 '(tab-width 4)
 '(tool-bar-mode nil))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
