;; -*- lexical-binding: t; -*-

(setq inhibit-startup-message t
      package-native-compile t
      custom-file (expand-file-name "custom.el" user-emacs-directory))

(when (file-exists-p custom-file)
  (load custom-file t))

(setq-default tab-width 4
			  display-line-numbers-type 'relative)

(when (find-font (font-spec :name "Fira Code"))
  (set-face-attribute 'default nil :font "Fira Code" :height 140))

(add-to-list 'default-frame-alist '(alpha-background . 90))
(when (display-graphic-p)
  (set-frame-parameter nil 'alpha-background 90))

(menu-bar-mode 0)
(tool-bar-mode 0)
(when (fboundp 'scroll-bar-mode)
  (scroll-bar-mode 0))
(column-number-mode 1)
(global-auto-revert-mode 1)
(savehist-mode 1)
(save-place-mode 1)
(recentf-mode 1)
(repeat-mode 1)
(winner-mode 1)
(show-paren-mode 1)
(delete-selection-mode 1)
(setq enable-recursive-minibuffers t)
(tab-bar-mode 1)
(editorconfig-mode 1)
(global-hl-line-mode 1)
(which-function-mode 1)
(setq which-func-display 'header)
(setq scroll-conservatively 101
      scroll-margin 10
      scroll-preserve-screen-position t
      auto-window-vscroll nil)
(setq mouse-wheel-scroll-amount '(1 ((shift) . hscroll))
      mouse-wheel-progressive-speed nil)
(when (fboundp 'pixel-scroll-precision-mode)
  (pixel-scroll-precision-mode 1))

(electric-pair-mode 1)
(global-prettify-symbols-mode 1)

(add-hook 'prog-mode-hook #'display-line-numbers-mode)
(add-hook 'prog-mode-hook #'flymake-mode)
(setq flymake-show-diagnostics-at-end-of-line t)

(setq use-short-answers t
      confirm-kill-processes nil
      treesit-font-lock-level 4)
(add-hook 'prog-mode-hook #'flyspell-prog-mode)

(require 'package)
(setq package-archives
      '(("gnu" . "https://elpa.gnu.org/packages/")
        ("nongnu" . "https://elpa.nongnu.org/nongnu/")
        ("melpa" . "https://melpa.org/packages/")))
(package-initialize)
(require 'use-package)
(setq use-package-always-ensure nil)

(use-package treesit
  :ensure nil
  :init
  (setq treesit-language-source-alist
        '((asm "https://github.com/rush-rs/tree-sitter-asm")
          (bash "https://github.com/tree-sitter/tree-sitter-bash")
          (c "https://github.com/tree-sitter/tree-sitter-c")
          (c-sharp "https://github.com/tree-sitter/tree-sitter-c-sharp")
          (cpp "https://github.com/tree-sitter/tree-sitter-cpp")
          (cuda "https://github.com/tree-sitter-grammars/tree-sitter-cuda")
          (cmake "https://github.com/uyha/tree-sitter-cmake")
          (css "https://github.com/tree-sitter/tree-sitter-css")
          (dockerfile "https://github.com/camdencheek/tree-sitter-dockerfile")
          (fish "https://github.com/ram02z/tree-sitter-fish")
          (go "https://github.com/tree-sitter/tree-sitter-go")
          (haskell "https://github.com/tree-sitter/tree-sitter-haskell")
          (html "https://github.com/tree-sitter/tree-sitter-html")
          (java "https://github.com/tree-sitter/tree-sitter-java")
          (javascript "https://github.com/tree-sitter/tree-sitter-javascript"
                      "master" "src")
          (json "https://github.com/tree-sitter/tree-sitter-json")
          (latex "https://github.com/latex-lsp/tree-sitter-latex"
                 "master" "src")
          (lua "https://github.com/tree-sitter-grammars/tree-sitter-lua")
          (make "https://github.com/tree-sitter-grammars/tree-sitter-make")
          (markdown "https://github.com/tree-sitter/tree-sitter-markdown"
                    "master" "tree-sitter-markdown/src")
          (nix "https://github.com/nix-community/tree-sitter-nix")
          (python "https://github.com/tree-sitter/tree-sitter-python")
          (regex "https://github.com/tree-sitter/tree-sitter-regex")
          (rust "https://github.com/tree-sitter/tree-sitter-rust")
          (scss "https://github.com/tree-sitter-grammars/tree-sitter-scss")
          (slang "https://github.com/tree-sitter-grammars/tree-sitter-slang")
          (sql "https://github.com/DerekStride/tree-sitter-sql"
               "gh-pages" "src")
          (toml "https://github.com/tree-sitter-grammars/tree-sitter-toml")
          (tsx "https://github.com/tree-sitter/tree-sitter-typescript"
               nil "tsx/src")
          (typescript "https://github.com/tree-sitter/tree-sitter-typescript"
                      nil "typescript/src")
          (vue "https://github.com/tree-sitter-grammars/tree-sitter-vue")
          (yaml "https://github.com/tree-sitter-grammars/tree-sitter-yaml")
          (zig "https://github.com/maxxnino/tree-sitter-zig")
          (bibtex "https://github.com/latex-lsp/tree-sitter-bibtex")
          (ini "https://github.com/justinmk/tree-sitter-ini"))))
(defconst my/treesit-languages
  '(asm bash c c-sharp cpp cuda cmake css dockerfile fish go haskell html java
    javascript json ini latex lua make markdown nix python regex rust scss slang sql
    toml tsx typescript vue yaml zig bibtex))
(defun treesit-install-grammars ()
  (interactive)
  (dolist (language my/treesit-languages)
    (unless (treesit-language-available-p language)
      (treesit-install-language-grammar language))))
(setq major-mode-remap-alist
      '((c-mode . c-ts-mode)
        (c++-mode . c++-ts-mode)
        (python-mode . python-ts-mode)
        (rust-mode . rust-ts-mode)
        (go-mode . go-ts-mode)
        (java-mode . java-ts-mode)
        (js-mode . js-ts-mode)
        (typescript-mode . typescript-ts-mode)
        (tsx-mode . tsx-ts-mode)
        (json-mode . json-ts-mode)
        (yaml-mode . yaml-ts-mode)
        (conf-toml-mode . toml-ts-mode)
        (css-mode . css-ts-mode)
        (lua-mode . lua-ts-mode)
        (sh-mode . bash-ts-mode)
        (cmake-mode . cmake-ts-mode)
        (csharp-mode . csharp-ts-mode)))

(require 'c-ts-mode)
(defun my/c-like-treesit-setup (language)
  (when (treesit-ready-p language)
    (let ((primary-parser (treesit-parser-create language)))
      (setq-local syntax-propertize-function #'c-ts-mode--syntax-propertize
                  treesit-font-lock-settings (c-ts-mode--font-lock-settings language)
                  treesit-primary-parser primary-parser)
      (let ((indent-rules
             (c-ts-mode--simple-indent-rules 'cpp c-ts-mode-indent-style)))
        (setcar indent-rules (cons language (cdar indent-rules)))
        (setq-local treesit-simple-indent-rules indent-rules))
      (treesit-major-mode-setup))))

(define-derived-mode cuda-ts-mode c-ts-base-mode "CUDA"
  "Major mode for CUDA, powered by tree-sitter."
  (my/c-like-treesit-setup 'cuda))

(define-derived-mode slang-ts-mode c-ts-base-mode "Slang"
  "Major mode for Slang, powered by tree-sitter."
  (my/c-like-treesit-setup 'slang)
  (remove-hook 'flymake-diagnostic-functions #'flymake-cc t))

(add-to-list 'auto-mode-alist '("\\.cuh?\\'" . cuda-ts-mode))
(add-to-list 'auto-mode-alist '("\\.slang\\(?:h\\)?\\'" . slang-ts-mode))

(use-package doom-themes
  :ensure t
  :config
  (load-theme 'doom-city-lights t))
(use-package solaire-mode
  :ensure t
  :init
  (solaire-global-mode 1))
(use-package doom-modeline
  :ensure t
  :init
  (doom-modeline-mode 1))

(use-package evil
  :ensure t
  :init
  (setq evil-want-keybinding nil
        evil-want-C-u-scroll t
        evil-want-C-i-jump t
        evil-undo-system 'undo-redo)
  :config
  (evil-mode 1))

(use-package evil-collection
  :ensure t
  :after evil
  :demand t
  :config
  (evil-collection-init))

(use-package evil-goggles
  :ensure t
  :config
  (evil-goggles-mode)
  (evil-goggles-use-diff-faces))

(use-package evil-surround
  :ensure t
  :after evil
  :config
  (global-evil-surround-mode 1))
(use-package evil-nerd-commenter
  :ensure t
  :after evil
  :config
  (evil-define-key '(normal visual) 'global (kbd "gc") #'evilnc-comment-operator))
(use-package evil-mc
  :ensure t
  :after evil
  :config
  (global-evil-mc-mode 1)
  (defun my/evil-mc-toggle-freeze ()
    "Freeze/thaw all cursors (nvim `<M-t>' toggle)."
    (interactive)
    (if evil-mc-frozen (evil-mc-resume-cursors) (evil-mc-pause-cursors)))
  (evil-define-key '(normal visual) 'global
    (kbd "M-n") #'evil-mc-make-and-goto-next-match
    (kbd "M-p") #'evil-mc-make-and-goto-prev-match
    (kbd "M-j") #'evil-mc-make-cursor-move-next-line
    (kbd "M-k") #'evil-mc-make-cursor-move-prev-line
    (kbd "M-t") #'my/evil-mc-toggle-freeze
    (kbd "M-a") #'evil-mc-make-all-cursors)
  (evil-define-key 'visual 'global
    (kbd "gC") #'evil-mc-make-cursor-in-visual-selection-beg))

(use-package expreg
  :ensure t
  :commands (expreg-expand expreg-contract)
  :bind (("C-=" . expreg-expand)
         ("C--" . expreg-contract)))
(use-package ws-butler
  :ensure t
  :init
  (ws-butler-global-mode 1))
(use-package undo-fu-session
  :ensure t
  :init
  (undo-fu-session-global-mode 1))

(use-package diff-hl
  :ensure t
  :init
  (global-diff-hl-mode 1)
  (add-hook 'dired-mode-hook #'diff-hl-dired-mode)
  (add-hook 'magit-post-refresh-hook #'diff-hl-magit-post-refresh))
(add-hook 'prog-mode-hook #'diff-hl-flydiff-mode)
(use-package hl-todo
  :ensure t
  :init
  (global-hl-todo-mode 1))
(use-package rainbow-mode
  :ensure t
  :hook (prog-mode . rainbow-mode))


(use-package magit
  :ensure t
  :commands (magit-status magit-project-status)
  :custom
  (magit-save-repository-buffers nil)
  (magit-diff-refine-hunk t)
  (magit-revision-insert-related-refs nil)
  (magit-uniquify-buffer-names nil))

(use-package consult
  :ensure t
  :commands (consult-buffer
             consult-recent-file
             consult-line
             consult-imenu
             consult-ripgrep
             consult-fd
             consult-flymake
             consult-xref)
  :bind (("C-x b" . consult-buffer))
  :custom
  (consult-preview-key 'any)
  :init
  (setq xref-show-xrefs-function #'consult-xref
        xref-show-definitions-function #'consult-xref)
  :config
  (with-eval-after-load 'pulse
    (when (boundp 'consult-after-jump-hook)
      (add-hook 'consult-after-jump-hook #'pulse-momentary-highlight-one-line))))

(use-package embark
  :ensure t
  :bind (("C-." . embark-act)
         ("C-h B" . embark-bindings))
  :config
  (evil-define-key '(normal visual insert emacs replace motion operator)
    'global (kbd "C-.") #'embark-act))
(use-package embark-consult
  :ensure t
  :after (embark consult)
  :hook (embark-collect-mode . consult-preview-at-point-mode))
(use-package wgrep
  :ensure t
  :commands (wgrep-change-to-wgrep-mode)
  :config
  (define-key grep-mode-map (kbd "C-x C-s") #'wgrep-change-to-wgrep-mode)
  (define-key grep-mode-map (kbd "e") #'wgrep-change-to-wgrep-mode))

(use-package helpful
  :ensure t
  :bind (("C-h f" . helpful-callable)
         ("C-h v" . helpful-variable)
         ("C-h k" . helpful-key)
         ("C-h x" . helpful-command)
         ("C-h F" . helpful-function)
         ("C-c C-d" . helpful-at-point)))
(use-package elisp-demos
  :ensure t
  :after helpful
  :config
  (advice-add 'helpful-update :after #'elisp-demos-advice-helpful-update))

(use-package mu4e
  :ensure nil
  :commands (mu4e mu4e-update-mail-and-index mu4e-compose-new mu4e-search)
  :custom
  (mu4e-get-mail-command "mbsync -a")
  (mu4e-update-interval nil)
  (mu4e-change-filenames-when-moving t)
  (mu4e-confirm-quit nil)
  (mu4e-compose-format-flowed t)
  (mu4e-maildir-shortcuts
   '((:maildir "/Inbox" :key ?i)
     (:maildir "/[Gmail].Sent Mail" :key ?s)
     (:maildir "/[Gmail].Drafts" :key ?d)
     (:maildir "/[Gmail].Trash" :key ?t)
     (:maildir "/[Gmail].All Mail" :key ?a)))
  (mu4e-sent-folder "/[Gmail].Sent Mail")
  (mu4e-drafts-folder "/[Gmail].Drafts")
  (mu4e-trash-folder "/[Gmail].Trash")
  (mu4e-refile-folder "/[Gmail].All Mail")
  (user-mail-address "leij49456@gmail.com")
  (smtpmail-smtp-server "smtp.gmail.com")
  (smtpmail-smtp-service 587)
  (smtpmail-stream-type 'starttls)
  (message-send-mail-function #'smtpmail-send-it))

(use-package eglot
  :demand t
  :custom
  (eglot-sync-connect 0)
  (eglot-autoshutdown t)
  (eglot-stay-out-of '(flymake company))
  (eglot-max-file-watches 5000)
  :config
  (add-to-list 'eglot-server-programs
               '((vue-mode vue-ts-mode) "vue-language-server" "--stdio"))
  (add-to-list 'eglot-server-programs
               '((toml-ts-mode conf-toml-mode) "taplo" "lsp" "stdio"))
  (add-to-list 'eglot-server-programs
               '(markdown-ts-mode "marksman" "server"))
  (add-to-list 'eglot-server-programs
               '(nix-ts-mode "nixd"))
  (add-to-list 'eglot-server-programs
               '((cuda-ts-mode) "clangd"))
  (add-to-list 'eglot-server-programs
               '((slang-ts-mode) "slangd"))
  :commands (eglot eglot-ensure)
  :hook ((go-mode python-mode java-mode c-mode c++-mode rust-mode
          cuda-ts-mode slang-ts-mode
          go-ts-mode python-ts-mode java-ts-mode c-ts-mode c++-ts-mode
          rust-ts-mode
          lua-mode lua-ts-mode
          cmake-mode cmake-ts-mode
          csharp-mode csharp-ts-mode
          js-mode js-ts-mode javascript-mode javascriptreact-mode
          typescript-mode typescript-ts-mode typescriptreact-mode tsx-ts-mode
          vue-mode vue-ts-mode
          json-mode json-ts-mode jsonc-mode js-json-mode
          sh-mode bash-ts-mode
          nix-mode nix-ts-mode
          markdown-mode markdown-ts-mode
          toml-ts-mode conf-toml-mode
          tex-mode latex-mode LaTeX-mode plain-tex-mode context-mode texinfo-mode)
         . eglot-ensure))

(use-package apheleia
  :ensure t
  :commands (apheleia-format-buffer)
  :config
  (setf (alist-get 'ruff-fix apheleia-formatters)
        '("ruff" "check" "--fix" "--stdin-filename" filepath "-"))
  (dolist (entry
           '((lua-mode . stylua)
             (lua-ts-mode . stylua)
             (cmake-mode . cmake-format)
             (javascript-mode . prettier-javascript)
             (js-mode . prettier-javascript)
             (js-ts-mode . prettier-javascript)
             (javascriptreact-mode . prettier-javascript)
             (typescript-mode . prettier-typescript)
             (typescript-ts-mode . prettier-typescript)
             (typescriptreact-mode . prettier-typescript)
             (tsx-ts-mode . prettier-typescript)
             (vue-mode . prettier)
             (web-mode . prettier)
             (python-mode . (ruff ruff-fix))
             (python-ts-mode . (ruff ruff-fix))
             (go-mode . (gofumpt goimports))
             (go-ts-mode . (gofumpt goimports))
             (rust-mode . rustfmt)
             (rust-ts-mode . rustfmt)
             (c-mode . clang-format)
             (c-ts-mode . clang-format)
             (c++-mode . clang-format)
             (c++-ts-mode . clang-format)
             (cuda-ts-mode . clang-format)
             (sh-mode . shfmt)
             (bash-ts-mode . shfmt)
             (zsh-mode . shfmt)
             (html-mode . prettier-html)
             (mhtml-mode . prettier-html)
             (css-mode . prettier-css)
             (css-ts-mode . prettier-css)
             (scss-mode . prettier-scss)
             (json-mode . prettier-json)
             (json-ts-mode . prettier-json)
             (jsonc-mode . prettier-json)
             (yaml-mode . prettier-yaml)
             (yaml-ts-mode . prettier-yaml)
             (tex-mode . latexindent)
             (latex-mode . latexindent)
             (bibtex-mode . bibtex-tidy)))
    (setf (alist-get (car entry) apheleia-mode-alist)
          (cdr entry)))
  (setf (alist-get 'bibtex-tidy apheleia-formatters)
        '("bibtex-tidy" "--no-modify")))

(use-package dired
  :ensure nil
  :custom
  (dired-dwim-target t)
  (dired-recursive-copies 'always)
  (dired-recursive-deletes 'top)
  (dired-listing-switches "-ahl -v --group-directories-first")
  :config
  (require 'dired-x)
  (add-hook 'dired-mode-hook #'dired-omit-mode)
  (require 'wdired)
  (define-key dired-mode-map (kbd "C-c C-e") #'wdired-change-to-wdired-mode))
(setq dired-auto-revert-buffer t)
(with-eval-after-load 'wgrep (setq wgrep-auto-save-buffer t))
(use-package nerd-icons
  :ensure t)

(use-package nerd-icons-dired
  :ensure t
  :after (nerd-icons dired)
  :hook (dired-mode . nerd-icons-dired-mode))

(use-package nerd-icons-corfu
  :ensure t
  :after (nerd-icons corfu)
  :config
  (add-to-list 'corfu-margin-formatters #'nerd-icons-corfu-formatter))

(use-package indent-bars
  :ensure t
  :custom
  (indent-bars-treesit-support t)
  :hook ((prog-mode yaml-mode) . indent-bars-mode))

(defvar leader-map (make-sparse-keymap))
(defvar leader-find-map (make-sparse-keymap))
(defvar leader-search-map (make-sparse-keymap))
(defvar leader-git-map (make-sparse-keymap))
(defvar leader-code-map (make-sparse-keymap))
(require 'project)
(defvar leader-project-map (make-sparse-keymap))
(defvar leader-terminal-map (make-sparse-keymap))
(defvar leader-mail-map (make-sparse-keymap))
(defvar leader-window-map (make-sparse-keymap))



(define-key leader-find-map (kbd "d") #'dired)
(define-key leader-map (kbd "f") leader-find-map)
(define-key leader-find-map (kbd "f") #'consult-fd)
(define-key leader-find-map (kbd "b") #'consult-buffer)
(define-key leader-find-map (kbd "r") #'consult-recent-file)

(define-key leader-map (kbd "s") leader-search-map)
(define-key leader-search-map (kbd "g") #'consult-ripgrep)
(define-key leader-search-map (kbd "l") #'consult-line)
(define-key leader-search-map (kbd "i") #'consult-imenu)
(define-key leader-search-map (kbd "r") #'consult-register)
(define-key leader-search-map (kbd "d") #'consult-flymake)
(define-key leader-search-map (kbd "y") #'consult-yank-from-kill-ring)
(define-key leader-search-map (kbd "m") #'consult-mark)
(define-key leader-search-map (kbd "o") #'consult-outline)
(global-set-key (kbd "M-y") #'consult-yank-from-kill-ring)
(global-set-key [remap goto-line] #'consult-goto-line)

(define-key leader-map (kbd "g") leader-git-map)
(define-key leader-git-map (kbd "g") #'magit-status)
(define-key leader-git-map (kbd "G") #'magit-project-status)

(defvar leader-ui-map (make-sparse-keymap))
(defun my/toggle-flymake-inline-diagnostics ()
  (interactive)
  (setq-default flymake-show-diagnostics-at-end-of-line
                (not flymake-show-diagnostics-at-end-of-line))
  (when (bound-and-true-p flymake-mode)
    (flymake-start t))
  (message "Inline diagnostics %s"
           (if flymake-show-diagnostics-at-end-of-line "enabled" "disabled")))


(define-key leader-map (kbd "c") leader-code-map)
(define-key leader-code-map (kbd "d") #'flymake-show-diagnostics)
(define-key leader-code-map (kbd "a") #'eglot-code-actions)
(define-key leader-code-map (kbd "r") #'eglot-rename)
(define-key leader-code-map (kbd "f") #'apheleia-format-buffer)
(define-key leader-code-map (kbd "h") #'eldoc-doc-buffer)
(define-key leader-code-map (kbd "i") #'eglot-inlay-hints-mode)

(define-key leader-map (kbd "u") leader-ui-map)
(define-key leader-ui-map (kbd "h") #'eglot-inlay-hints-mode)
(define-key leader-ui-map (kbd "d") #'my/toggle-flymake-inline-diagnostics)

(define-key leader-map (kbd "p") leader-project-map)
(define-key leader-project-map (kbd "p") #'project-switch-project)
(define-key leader-project-map (kbd "f") #'project-find-file)
(define-key leader-project-map (kbd "b") #'project-switch-to-buffer)
(define-key leader-project-map (kbd "c") #'project-compile)
(define-key leader-project-map (kbd "k") #'project-kill-buffers)
(define-key leader-project-map (kbd "d") #'project-dired)
(define-key leader-project-map (kbd "r") #'project-find-regexp)

(define-key leader-map (kbd "t") leader-terminal-map)
(define-key leader-terminal-map (kbd "t") #'vterm)
(define-key leader-terminal-map (kbd "o") #'vterm-other-window)
(define-key leader-map (kbd "w") leader-window-map)
(define-key leader-window-map (kbd "s") #'split-window-below)
(define-key leader-window-map (kbd "v") #'split-window-right)
(define-key leader-window-map (kbd "o") #'other-window)
(define-key leader-window-map (kbd "u") #'winner-undo)
(define-key leader-window-map (kbd "r") #'winner-redo)
(define-key leader-git-map (kbd "n") #'diff-hl-next-hunk)
(define-key leader-git-map (kbd "p") #'diff-hl-previous-hunk)
(define-key evil-normal-state-map (kbd "]H") #'diff-hl-next-hunk)
(define-key evil-normal-state-map (kbd "[H") #'diff-hl-previous-hunk)
(define-key evil-normal-state-map (kbd "]e") #'flymake-goto-next-error)
(define-key evil-normal-state-map (kbd "[e") #'flymake-goto-prev-error)
(setq delete-by-moving-to-trash t)
(define-key leader-map (kbd "m") leader-mail-map)
(define-key leader-mail-map (kbd "m") #'mu4e)
(define-key leader-mail-map (kbd "u") #'mu4e-update-mail-and-index)
(define-key leader-mail-map (kbd "c") #'mu4e-compose-new)


(evil-define-key '(normal visual motion) 'global (kbd "SPC") leader-map)



(setq org-directory (file-name-as-directory (expand-file-name "~/org/"))
      org-default-notes-file (expand-file-name "inbox.org" org-directory)
      org-agenda-files (list org-default-notes-file)
      org-capture-templates
      `(("t" "Task" entry
         (file+headline ,org-default-notes-file "Tasks")
         "* TODO %?\n  %U\n")
        ("n" "Note" entry
         (file+headline ,org-default-notes-file "Notes")
         "* %?\n  %U\n")))

(use-package org
  :ensure t
  :hook (org-mode . visual-line-mode)
  :custom
  (org-startup-folded 'content)
  (org-startup-indented t)
  (org-hide-emphasis-markers t)
  (org-pretty-entities t)
  (org-return-follows-link t)
  (org-src-fontify-natively t)
  (org-edit-src-content-indentation 0))
(setq org-log-done 'time)
(use-package org-modern
  :ensure t
  :after org
  :init
  (add-hook 'org-mode-hook #'org-modern-mode))

(use-package evil-org
  :ensure t
  :after (evil org)
  :hook (org-mode . evil-org-mode)
  :config
  (require 'evil-org-agenda)
  (evil-org-agenda-set-keys))

(defvar leader-org-map (make-sparse-keymap))
(define-key leader-map (kbd "o") leader-org-map)
(define-key leader-org-map (kbd "a") #'org-agenda)
(define-key leader-org-map (kbd "c") #'org-capture)
(define-key leader-org-map (kbd "s") #'org-store-link)

(use-package which-key
  :ensure t
  :init
  (which-key-mode 1)
  :custom
  (which-key-idle-delay 0.5)
  :config
  (which-key-add-key-based-replacements
   "SPC f" "Find"
   "SPC s" "Search"
   "SPC g" "Git"
   "SPC c" "Code"
   "SPC o" "Org"
   "SPC p" "Project"
   "SPC w" "Window"
   "SPC m" "Mail"))


(use-package corfu
  :ensure t
  :custom
  (corfu-auto t)
  (corfu-cycle t)
  (corfu-preselect 'prompt)
  :init
  (global-corfu-mode 1))
(use-package cape
  :ensure t
  :init
  (add-to-list 'completion-at-point-functions #'cape-dabbrev)
  (add-to-list 'completion-at-point-functions #'cape-file)
  (add-to-list 'completion-at-point-functions #'cape-history))
(with-eval-after-load 'corfu (require 'corfu-history) (corfu-history-mode 1))

(use-package tempel
  :ensure t
  :bind (("M-+" . tempel-complete)
         ("M-*" . tempel-insert))
  :init
  (defun my/tempel-setup-capf ()
    (setq-local completion-at-point-functions
                (cons #'tempel-expand completion-at-point-functions)))
  (add-hook 'prog-mode-hook #'my/tempel-setup-capf)
  (add-hook 'text-mode-hook #'my/tempel-setup-capf))

(use-package tempel-collection
  :ensure t
  :after tempel)

(use-package markdown-mode
  :ensure t
  :commands (markdown-mode gfm-mode))
(setq markdown-fontify-code-blocks-natively t)

(use-package corfu-popupinfo
  :ensure nil
  :after corfu
  :demand t
  :config
  (corfu-popupinfo-mode 1))

(use-package orderless
  :ensure t
  :custom
  (completion-styles '(orderless basic))
  (completion-category-defaults nil)
  (completion-category-overrides
   '((file (styles basic partial-completion))))
  (completion-pcm-leading-wildcard t))

(use-package marginalia
  :ensure t
  :init
  (marginalia-mode 1))

(use-package vertico
  :ensure t
  :init
  (vertico-mode 1))
(with-eval-after-load 'vertico
  (require 'vertico-directory)
  (define-key vertico-map (kbd "RET") #'vertico-directory-enter)
  (define-key vertico-map (kbd "DEL") #'vertico-directory-delete-char)
  (define-key vertico-map (kbd "M-DEL") #'vertico-directory-delete-word))

(use-package vertico-posframe
  :ensure t
  :config
  (vertico-posframe-mode 1))

(use-package vterm
  :ensure t
  :custom
  (vterm-kill-buffer-on-exit t)
  (vterm-max-scrollback 5000)
  :config
  (add-hook 'vterm-mode-hook #'goto-address-mode)
  (add-hook 'vterm-mode-hook (lambda () (display-line-numbers-mode 0))))
(use-package ligature
  :ensure t
  :load-path "path-to-ligature-repo"
  :config
  ;; Enable the "www" ligature in every possible major mode
  (ligature-set-ligatures 't '("www"))
  ;; Enable traditional ligature support in eww-mode, if the
  ;; `variable-pitch' face supports it
  (ligature-set-ligatures 'eww-mode '("ff" "fi" "ffi"))
  ;; Enable all Cascadia and Fira Code ligatures in programming modes
  (ligature-set-ligatures 'prog-mode
                        '(;; == === ==== => =| =>>=>=|=>==>> ==< =/=//=// =~
                          ;; =:= =!=
                          ("=" (rx (+ (or ">" "<" "|" "/" "~" ":" "!" "="))))
                          ;; ;; ;;;
                          (";" (rx (+ ";")))
                          ;; && &&&
                          ("&" (rx (+ "&")))
                          ;; !! !!! !. !: !!. != !== !~
                          ("!" (rx (+ (or "=" "!" "\." ":" "~"))))
                          ;; ?? ??? ?:  ?=  ?.
                          ("?" (rx (or ":" "=" "\." (+ "?"))))
                          ;; %% %%%
                          ("%" (rx (+ "%")))
                          ;; |> ||> |||> ||||> |] |} || ||| |-> ||-||
                          ;; |->>-||-<<-| |- |== ||=||
                          ;; |==>>==<<==<=>==//==/=!==:===>
                          ("|" (rx (+ (or ">" "<" "|" "/" ":" "!" "}" "\]"
                                          "-" "=" ))))
                          ;; \\ \\\ \/
                          ("\\" (rx (or "/" (+ "\\"))))
                          ;; ++ +++ ++++ +>
                          ("+" (rx (or ">" (+ "+"))))
                          ;; :: ::: :::: :> :< := :// ::=
                          (":" (rx (or ">" "<" "=" "//" ":=" (+ ":"))))
                          ;; // /// //// /\ /* /> /===:===!=//===>>==>==/
                          ("/" (rx (+ (or ">"  "<" "|" "/" "\\" "\*" ":" "!"
                                          "="))))
                          ;; .. ... .... .= .- .? ..= ..<
                          ("\." (rx (or "=" "-" "\?" "\.=" "\.<" (+ "\."))))
                          ;; -- --- ---- -~ -> ->> -| -|->-->>->--<<-|
                          ("-" (rx (+ (or ">" "<" "|" "~" "-"))))
                          ;; *> */ *)  ** *** ****
                          ("*" (rx (or ">" "/" ")" (+ "*"))))
                          ;; www wwww
                          ("w" (rx (+ "w")))
                          ;; <> <!-- <|> <: <~ <~> <~~ <+ <* <$ </  <+> <*>
                          ;; <$> </> <|  <||  <||| <|||| <- <-| <-<<-|-> <->>
                          ;; <<-> <= <=> <<==<<==>=|=>==/==//=!==:=>
                          ;; << <<< <<<<
                          ("<" (rx (+ (or "\+" "\*" "\$" "<" ">" ":" "~"  "!"
                                          "-"  "/" "|" "="))))
                          ;; >: >- >>- >--|-> >>-|-> >= >== >>== >=|=:=>>
                          ;; >> >>> >>>>
                          (">" (rx (+ (or ">" "<" "|" "/" ":" "=" "-"))))
                          ;; #: #= #! #( #? #[ #{ #_ #_( ## ### #####
                          ("#" (rx (or ":" "=" "!" "(" "\?" "\[" "{" "_(" "_"
                                       (+ "#"))))
                          ;; ~~ ~~~ ~=  ~-  ~@ ~> ~~>
                          ("~" (rx (or ">" "=" "-" "@" "~>" (+ "~"))))
                          ;; __ ___ ____ _|_ __|____|_
                          ("_" (rx (+ (or "_" "|"))))
                          ;; Fira code: 0xFF 0x12
                          ("0" (rx (and "x" (+ (in "A-F" "a-f" "0-9")))))
                          ;; Fira code:
                          "Fl"  "Tl"  "fi"  "fj"  "fl"  "ft"
                          ;; The few not covered by the regexps.
                          "{|"  "[|"  "]#"  "(*"  "}#"  "$>"  "^="))
  ;; Enables ligature checks globally in all buffers. You can also do it
  ;; per mode with `ligature-mode'.
  (global-ligature-mode t))
