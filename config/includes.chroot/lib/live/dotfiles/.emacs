;;; package --- Summary;
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
  (define-key global-map (kbd "C-x C-b") 'helm-buffers-list)
  (define-key global-map (kbd "C-x b") 'helm-buffers-list))

;;; helm-project
(use-package helm-projectile
  :ensure t
  :init
  (projectile-global-mode)
  (setq projectile-completion-system 'helm)
  (helm-projectile-on))

;;; helm-swoop
(use-package helm-swoop
  :ensure t
  :bind
  (("M-s s" . helm-swoop))
  )

;;; which-key
(use-package which-key
  :ensure t
  :init (which-key-mode))

;;; neotree
(use-package neotree
  :ensure t
  :init
  (global-set-key (kbd "C-x t f") 'neotree-find)
  (global-set-key (kbd "C-x t o") 'neotree-show)
  (global-set-key (kbd "C-x t c") 'neotree-hide))

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
  (add-hook 'java-mode-hook 'helm-gtags-mode)
  (add-hook 'c++-mode-hook 'helm-gtags-mode)
  (add-hook 'asm-mode-hook 'helm-gtags-mode)
  (add-hook 'php-mode-hook 'helm-gtags-mode)
  (add-hook 'python-mode-hook 'helm-gtags-mode)
  (eval-after-load "helm-gtags"
    '(progn
       (define-key helm-gtags-mode-map (kbd "C-c t f") 'helm-gtags-find-tag)
       (define-key helm-gtags-mode-map (kbd "C-c t r") 'helm-gtags-find-rtag)
       (define-key helm-gtags-mode-map (kbd "C-c t s") 'helm-gtags-find-symbol)
       (define-key helm-gtags-mode-map (kbd "C-c t g") 'helm-gtags-parse-file)
       (define-key helm-gtags-mode-map (kbd "C-c t p") 'helm-gtags-previous-history)
       (define-key helm-gtags-mode-map (kbd "C-c t n") 'helm-gtags-next-history)
       (define-key helm-gtags-mode-map (kbd "C-c t t") 'helm-gtags-pop-stack) )
    )
  )

;;; git-gutter
(use-package git-gutter
  :ensure t
  :init
  (global-git-gutter-mode 1)
  (git-gutter:linum-setup)
  (global-set-key (kbd "C-x g p") 'git-gutter:previous-hunk)
  (global-set-key (kbd "C-x g n") 'git-gutter:next-hunk)
  (global-set-key (kbd "C-x g s") 'git-gutter:stage-hunk)
  )

;;; magit
(use-package magit
  :ensure t
  :init
  (global-set-key (kbd "C-x g v") 'magit-status)
  (global-set-key (kbd "C-x g d") 'magit-diff-buffer-file)
  (global-set-key (kbd "C-x g l") 'magit-log-buffer-file)
  (global-set-key (kbd "C-x g a") 'magit-log-all)
  )

;;; switch-window
(use-package switch-window
  :ensure t
  :init
  (global-set-key (kbd "C-x o") 'switch-window)
  )
(use-package windmove
  :bind
  (("<f2> <right>" . windmove-right)
   ("<f2> <left>" . windmove-left)
   ("<f2> <up>" . windmove-up)
   ("<f2> <down>" . windmove-down)
   ))
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


;; hide the minor modes
(defvar hidden-minor-modes
  '(flycheck-mode which-key-mode projectile-mode git-gutter-mode helm-mode))
(defun purge-minor-modes ()
  (interactive)
  (dolist (x hidden-minor-modes nil)
    (let ((trg (cdr (assoc x minor-mode-alist))))
      (when trg
        (setcar trg "")))))
(add-hook 'after-change-major-mode-hook 'purge-minor-modes)

;;; customize
(defalias 'yes-or-no-p 'y-or-n-p)
(global-set-key (kbd "M-o") 'mode-line-other-buffer)
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

;;; term
(progn
  (let ((x 2) (tkey ""))
    (while (<= x 8)
      ;; shift
      (if (= x 2)
          (setq tkey "S-"))
      ;; alt
      (if (= x 3)
          (setq tkey "M-"))
      ;; alt + shift
      (if (= x 4)
          (setq tkey "M-S-"))
      ;; ctrl
      (if (= x 5)
          (setq tkey "C-"))
      ;; ctrl + shift
      (if (= x 6)
          (setq tkey "C-S-"))
      ;; ctrl + alt
      (if (= x 7)
          (setq tkey "C-M-"))
      ;; ctrl + alt + shift
      (if (= x 8)
          (setq tkey "C-M-S-"))

      ;; arrows
      (define-key key-translation-map (kbd (format "M-[ 1 ; %d A" x)) (kbd (format "%s<up>" tkey)))
      (define-key key-translation-map (kbd (format "M-[ 1 ; %d B" x)) (kbd (format "%s<down>" tkey)))
      (define-key key-translation-map (kbd (format "M-[ 1 ; %d C" x)) (kbd (format "%s<right>" tkey)))
      (define-key key-translation-map (kbd (format "M-[ 1 ; %d D" x)) (kbd (format "%s<left>" tkey)))
      ;; home
      (define-key key-translation-map (kbd (format "M-[ 1 ; %d H" x)) (kbd (format "%s<home>" tkey)))
      ;; end
      (define-key key-translation-map (kbd (format "M-[ 1 ; %d F" x)) (kbd (format "%s<end>" tkey)))
      ;; page up
      (define-key key-translation-map (kbd (format "M-[ 5 ; %d ~" x)) (kbd (format "%s<prior>" tkey)))
      ;; page down
      (define-key key-translation-map (kbd (format "M-[ 6 ; %d ~" x)) (kbd (format "%s<next>" tkey)))
      ;; insert
      (define-key key-translation-map (kbd (format "M-[ 2 ; %d ~" x)) (kbd (format "%s<delete>" tkey)))
      ;; delete
      (define-key key-translation-map (kbd (format "M-[ 3 ; %d ~" x)) (kbd (format "%s<delete>" tkey)))
      ;; f1
      (define-key key-translation-map (kbd (format "M-[ 1 ; %d P" x)) (kbd (format "%s<f1>" tkey)))
      ;; f2
      (define-key key-translation-map (kbd (format "M-[ 1 ; %d Q" x)) (kbd (format "%s<f2>" tkey)))
      ;; f3
      (define-key key-translation-map (kbd (format "M-[ 1 ; %d R" x)) (kbd (format "%s<f3>" tkey)))
      ;; f4
      (define-key key-translation-map (kbd (format "M-[ 1 ; %d S" x)) (kbd (format "%s<f4>" tkey)))
      ;; f5
      (define-key key-translation-map (kbd (format "M-[ 15 ; %d ~" x)) (kbd (format "%s<f5>" tkey)))
      ;; f6
      (define-key key-translation-map (kbd (format "M-[ 17 ; %d ~" x)) (kbd (format "%s<f6>" tkey)))
      ;; f7
      (define-key key-translation-map (kbd (format "M-[ 18 ; %d ~" x)) (kbd (format "%s<f7>" tkey)))
      ;; f8
      (define-key key-translation-map (kbd (format "M-[ 19 ; %d ~" x)) (kbd (format "%s<f8>" tkey)))
      ;; f9
      (define-key key-translation-map (kbd (format "M-[ 20 ; %d ~" x)) (kbd (format "%s<f9>" tkey)))
      ;; f10
      (define-key key-translation-map (kbd (format "M-[ 21 ; %d ~" x)) (kbd (format "%s<f10>" tkey)))
      ;; f11
      (define-key key-translation-map (kbd (format "M-[ 23 ; %d ~" x)) (kbd (format "%s<f11>" tkey)))
      ;; f12
      (define-key key-translation-map (kbd (format "M-[ 24 ; %d ~" x)) (kbd (format "%s<f12>" tkey)))
      ;; f13
      (define-key key-translation-map (kbd (format "M-[ 25 ; %d ~" x)) (kbd (format "%s<f13>" tkey)))
      ;; f14
      (define-key key-translation-map (kbd (format "M-[ 26 ; %d ~" x)) (kbd (format "%s<f14>" tkey)))
      ;; f15
      (define-key key-translation-map (kbd (format "M-[ 28 ; %d ~" x)) (kbd (format "%s<f15>" tkey)))
      ;; f16
      (define-key key-translation-map (kbd (format "M-[ 29 ; %d ~" x)) (kbd (format "%s<f16>" tkey)))
      ;; f17
      (define-key key-translation-map (kbd (format "M-[ 31 ; %d ~" x)) (kbd (format "%s<f17>" tkey)))
      ;; f18
      (define-key key-translation-map (kbd (format "M-[ 32 ; %d ~" x)) (kbd (format "%s<f18>" tkey)))
      ;; f19
      (define-key key-translation-map (kbd (format "M-[ 33 ; %d ~" x)) (kbd (format "%s<f19>" tkey)))
      ;; f20
      (define-key key-translation-map (kbd (format "M-[ 34 ; %d ~" x)) (kbd (format "%s<f20>" tkey)))
      
      (setq x (+ x 1))
      ))
  )
(defun indent-buffer ()
  (interactive)
  (save-excursion
    (indent-region (point-min) (point-max) nil)))
(global-set-key [f12] 'indent-buffer)

;; Mutt support.
(setq auto-mode-alist (append '(("/tmp/mutt.*" . mail-mode)) auto-mode-alist))

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(Buffer-menu-use-header-line nil)
 '(backup-by-copying t)
 '(backup-directory-alist (quote (("." . "~/.emacs.d/backup"))))
 '(column-number-mode t)
 '(custom-enabled-themes (quote (smart-mode-line-respectful deeper-blue)))
 '(custom-safe-themes
   (quote
    ("3c83b3676d796422704082049fc38b6966bcad960f896669dfc21a7a37a748fa" "c74e83f8aa4c78a121b52146eadb792c9facc5b1f02c917e3dbb454fca931223" "a27c00821ccfd5a78b01e4f35dc056706dd9ede09a8b90c6955ae6a390eb1c1e" default)))
 '(default-input-method "vietnamese-telex")
 '(delete-old-versions 6)
 '(global-linum-mode t)
 '(helm-gtags-auto-update t)
 '(indent-tabs-mode nil)
 '(initial-scratch-message nil)
 '(keep-new-versions 2)
 '(menu-bar-mode nil)
 '(package-selected-packages
   (quote
    (dockerfile-mode go-mode helm-gitlab gitlab kubernetes yaml-mode bitbucket helm which-key use-package switch-window nhexl-mode neotree multiple-cursors markdown-mode magit helm-projectile helm-gtags helm-ag git-gutter flycheck ac-php)))
 '(scroll-bar-mode nil)
 '(tab-width 4)
 '(tool-bar-mode nil)
 '(tramp-auto-save-directory "~/.emacs.d/backup")
 '(version-control t))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

;; smart-mode-line
(use-package smart-mode-line
  :ensure t
  :init
  (smart-mode-line-enable)
  (setq sml/no-confirm-load-theme t)
  )
;; go-mode
(use-package go-guru
  :ensure t
  )
(use-package go-autocomplete
  :ensure t
  )
(use-package go-projectile
  :ensure t
  :init
  (defun my-switch-project-hook ()
    (go-set-project))
  (add-hook 'projectile-after-switch-project-hook 'my-switch-project-hook)
  (defun my-go-mode-hook ()
    (add-hook 'before-save-hook 'gofmt-before-save) ; gofmt before every save
    (setq gofmt-command "goimports")
    (go-guru-hl-identifier-mode)                    ; highlight identifiers  
    (local-set-key (kbd "M-.") 'godef-jump)
    (local-set-key (kbd "M-*") 'pop-tag-mark)
    (auto-complete-mode 1))                         ; Enable auto-complete mode
  (add-hook 'go-mode-hook 'my-go-mode-hook)
  (with-eval-after-load 'go-mode
    (require 'go-autocomplete))
  )
;;; python-mode
(use-package jedi
  :ensure t
  :init
  (defvar jedi-config:use-system-python nil)
  (defvar jedi-config:with-virtualenv nil)
  (defvar jedi-config:vcs-root-sentinel ".git")
  (defvar jedi-config:python-module-sentinel "__init__.py")
  
  (defun get-project-root (buf repo-file &optional init-file)
    "Just uses the vc-find-root function to figure out the project root.
       Won't always work for some directory layouts."
    (let* ((buf-dir (expand-file-name (file-name-directory (buffer-file-name buf))))
           (project-root (vc-find-root buf-dir repo-file)))
      (if project-root
          (expand-file-name project-root)
        nil)))
  
  (defun get-project-root-with-file (buf repo-file &optional init-file)
    "Guesses that the python root is the less 'deep' of either:
         -- the root directory of the repository, or
         -- the directory before the first directory after the root
            having the init-file file (e.g., '__init__.py'."

    ;; make list of directories from root, removing empty
    (defun make-dir-list (path)
      (delq nil (mapcar (lambda (x) (and (not (string= x "")) x))
                        (split-string path "/"))))
    ;; convert a list of directories to a path starting at "/"
    (defun dir-list-to-path (dirs)
      (mapconcat 'identity (cons "" dirs) "/"))
    ;; a little something to try to find the "best" root directory
    (defun try-find-best-root (base-dir buffer-dir current)
      (cond
       (base-dir ;; traverse until we reach the base
        (try-find-best-root (cdr base-dir) (cdr buffer-dir)
                            (append current (list (car buffer-dir)))))
       
       (buffer-dir ;; try until we hit the current directory
        (let* ((next-dir (append current (list (car buffer-dir))))
               (file-file (concat (dir-list-to-path next-dir) "/" init-file)))
          (if (file-exists-p file-file)
              (dir-list-to-path current)
            (try-find-best-root nil (cdr buffer-dir) next-dir))))
       
       (t nil)))
    
    (let* ((buffer-dir (expand-file-name (file-name-directory (buffer-file-name buf))))
           (vc-root-dir (vc-find-root buffer-dir repo-file)))
      (if (and init-file vc-root-dir)
          (try-find-best-root
           (make-dir-list (expand-file-name vc-root-dir))
           (make-dir-list buffer-dir)
           '())
        vc-root-dir))) ;; default to vc root if init file not given

  ;; Set this variable to find project root
  (defvar jedi-config:find-root-function 'get-project-root-with-file)

  (defun current-buffer-project-root ()
    (funcall jedi-config:find-root-function
             (current-buffer)
             jedi-config:vcs-root-sentinel
             jedi-config:python-module-sentinel))

  (defun jedi-config:setup-server-args ()
    ;; little helper macro for building the arglist
    (defmacro add-args (arg-list arg-name arg-value)
      `(setq ,arg-list (append ,arg-list (list ,arg-name ,arg-value))))
    ;; and now define the args
    (let ((project-root (current-buffer-project-root)))

      (make-local-variable 'jedi:server-args)

      (when project-root
        (message (format "Adding system path: %s" project-root))
        (add-args jedi:server-args "--sys-path" project-root))

      (when jedi-config:with-virtualenv
        (message (format "Adding virtualenv: %s" jedi-config:with-virtualenv))
        (add-args jedi:server-args "--virtual-env" jedi-config:with-virtualenv))))

  ;; Use system python
  (defun jedi-config:set-python-executable ()
    (set-exec-path-from-shell-PATH)
    (make-local-variable 'jedi:server-command)
    (set 'jedi:server-command
         (list (executable-find "python"))))

  ;; Now hook everything up
  ;; Hook up to autocomplete
  (add-to-list 'ac-sources 'ac-source-jedi-direct)

  ;; Enable Jedi setup on mode start
  (add-hook 'python-mode-hook 'jedi:setup)

  ;; Buffer-specific server options
  (add-hook 'python-mode-hook
            'jedi-config:setup-server-args)
  (when jedi-config:use-system-python
    (add-hook 'python-mode-hook
              'jedi-config:set-python-executable))

  ;; And custom keybindings
  (defun jedi-config:setup-keys ()
    (local-set-key (kbd "M-.") 'jedi:goto-definition)
    (local-set-key (kbd "M-,") 'jedi:goto-definition-pop-marker)
    (local-set-key (kbd "M-?") 'jedi:show-doc)
    (local-set-key (kbd "M-/") 'jedi:get-in-function-call))

  ;; Don't let tooltip show up automatically
  (setq jedi:get-in-function-call-delay 10000000)
  ;; Start completion at method dot
  (setq jedi:complete-on-dot t)
  ;; Use custom keybinds
  (add-hook 'python-mode-hook 'jedi-config:setup-keys)
  (add-to-list 'ac-sources 'ac-source-jedi-direct)
  (add-hook 'python-mode-hook 'jedi:setup))

;; php-mode
(use-package ac-php
  :ensure t
  :init
  (defun bs-php-mode-hook ()
    (auto-complete-mode t)                 ;; «
    (require 'ac-php)                      ;; «
    (setq ac-sources  '(ac-source-php ))   ;; «
    (yas-global-mode 1)                    ;; «
    (setq php-template-compatibility nil))
  (add-hook 'php-mode-hook 'bs-php-mode-hook)
  )

