;;; .doom.d/config.el -*- lexical-binding: t; -*-

;; appperence
(setq doom-theme 'doom-nord)
(setq +font-size (pcase (system-name)
                   ("desktop" 22)
                   ("laptop" 22)
                   ("x1yoga" 30)
                   (_ 24))
      doom-font (font-spec :family "Sarasa Mono SC" :size +font-size)
      doom-variable-pitch-font (font-spec :family "Victor Mono" :size +font-size))
      ;; doom-variable-pitch-font (font-spec :family "Roboto")
      

(after! unicode-fonts
  (dolist (unicode-block '("Bopomofo"
                           "Bopomofo Extended"
                           "CJK Compatibility"
                           "CJK Compatibility Forms"
                           "CJK Compatibility Ideographs"
                           "CJK Compatibility Ideographs Supplement"
                           "CJK Radicals Supplement"
                           "CJK Strokes"
                           "CJK Symbols and Punctuation"
                           "CJK Unified Ideographs"
                           "CJK Unified Ideographs Extension A"
                           "CJK Unified Ideographs Extension B"
                           "CJK Unified Ideographs Extension C"
                           "CJK Unified Ideographs Extension D"
                           "CJK Unified Ideographs Extension E"))
    (push "Sarasa Mono SC" (cadr (assoc unicode-block unicode-fonts-block-font-mapping)))))

;; keybindings
(map!
 "C-<f1>" #'my/lsp-breadcrumb-go-up
 "<f2>" #'lsp-ui-find-next-reference
 "S-<f2>" #'lsp-ui-find-prev-reference
 "M-n" (lambda () (interactive) (lsp-ui-find-next-reference t))
 "M-p" (lambda () (interactive) (lsp-ui-find-prev-reference t))
 "<f3>" #'git-gutter:next-hunk
 "S-<f3>" #'git-gutter:previous-hunk
 "<f4>" (lambda () (interactive) (xref-push-marker-stack) (bmkp-cycle-local-file 1))
 "S-<f4>" (lambda () (interactive) (xref-push-marker-stack) (bmkp-cycle-local-file -1))
 "M-[" (lambda () (interactive) (xref-push-marker-stack) (bmkp-cycle-this-file/buffer 1))
 "M-]" (lambda () (interactive) (xref-push-marker-stack) (bmkp-cycle-this-file/buffer -1))

 "M-s" #'swiper-thing-at-point
 "M-S" #'+default/search-project-for-symbol-at-point
 "M-*" #'pop-tag-mark
 "M-8" #'er/expand-region
 ;; "C-<escape>" #'+ivy/projectile-find-file
 "C-<tab>" #'next-buffer
 "C-c '" #'consult-imenu-multi
 "<backtab>" #'+fold/toggle
 "C-c C-r" #'consult-recent-file
 ;; "C-c C-f" #'+ivy/projectile-find-file ; use default C-c C-p C-f
 ;; "C-x o" #'other-frame
 ;; "C-x 1" #'delete-other-frames
 ;; "C-x 2" #'make-frame-command
 ;; "C-x 3" #'make-frame-command
 ;; "C-x 0" #'delete-frame
 "C-x k" #'kill-current-buffer
 "M-m" 'iy-go-to-char
 "M-M" 'iy-go-to-char-backward
 "C-c C-t" #'my-open-terminal
 "C-M-o" #'my-open-in-vscode
 "C-v" #'my-scroll-up-command
 "M-v" #'my-scroll-down-command
 "<next>" #'my-scroll-up-command
 "<prev>" #'my-scroll-down-command
 "M-<next>" #'my-scroll-other-window
 "M-<prior>" #'my-scroll-other-window-down
 "M-SPC" #'xref-push-marker-stack
 "C-M-SPC" (lambda () (interactive) (cycle-spacing -1))
 "<f21>" (lambda () (interactive) (iy-go-to-char-backward 1 ?\())
 "<f22>" (lambda () (interactive) (iy-go-to-char 1 ?\))))

(map! :map lsp-mode-map "<f1>" #'lsp-ui-doc-glance)


(defun my-scroll-up-command ()
  (interactive)
  (scroll-up-command (/ (window-body-height) 4)))
(defun my-scroll-down-command ()
  (interactive)
  (scroll-down-command (/ (window-body-height) 4)))
(defun my-scroll-other-window ()
  (interactive)
  (scroll-other-window (/ (window-body-height) 4)))
(defun my-scroll-other-window-down ()
  (interactive)
  (scroll-other-window-down (/ (window-body-height) 4)))

(defun my-open-in-vscode ()
  (interactive)
  (doom-call-process "code" (projectile-project-root) "-g" (format "%s:%s:%s" buffer-file-name (line-number-at-pos) (current-column))))

(run-with-timer 0 (* 5 60) 'recentf-save-list)

(map! :map general-override-mode-map
      "C-c C-f C-f" #'vimish-fold
      "C-c C-f C-d" #'vimish-fold-delete)

(map! :map ivy-minibuffer-map
      "C-r" #'ivy-restrict-to-matches)

(defun my-open-terminal ()
  "Open current directory in terminal."
  (interactive)
  (call-process-shell-command "run terminal; tmux new-window" nil 0))

(defun my-consult-bookmark ()
  (interactive)
  (progn
    (xref-push-marker-stack)
    (call-interactively #'consult-bookmark)))
(map! "M-`" #'my-consult-bookmark)

(require 'bookmark+)
(defun my-bookmark-cycle-other-window ()
  (interactive)
  (bmkp-cycle-file-other-window 1)
  (other-window 1))


;; tweaking
(setq auth-sources '("secrets:Login"))
; (setq display-line-numbers-type nil)
(setq inferior-lisp-program "/usr/bin/ros run")
(setq common-lisp-hyperspec-root "file:///usr/share/doc/hyperspec/")
(setq global-auto-revert-mode t
      auto-revert-interval 1)
(setq auto-save-default t)
(put 'narrow-to-region 'disabled nil)
;; additional terminal bindings under alacritty
(add-to-list 'term-file-aliases '("alacritty" . "xterm"))
;; https://github.com/hlissner/doom-emacs/issues/3038
(setq langtool-language-tool-jar "~/.local/share/languagetool/languagetool-commandline.jar")
;; (setq recenter-positions '(middle top))
(setq doom-snippets-dir "~/workspace/emacs-snippets")
;; (setq dtrt-indent-require-confirmation-flag t)
(add-to-list 'doom-detect-indentation-excluded-modes 'rustic-mode)
;; (setq doom-themes-treemacs-enable-variable-pitch nil)
(global-tree-sitter-mode)
(add-hook 'tree-sitter-after-on-hook #'tree-sitter-hl-mode)
(add-hook 'server-visit-hook #'with-editor-mode)
(after! magit
  (setq magit-diff-refine-hunk 'all))
  

;; deft
(after! deft
  (setq
   deft-directory "~/notes"
   deft-default-extension "md"
   deft-recursive t
   deft-file-naming-rules '((noslash . "-")
                            (nospace . "-")
                            (case-fn . downcase))
   deft-markdown-mode-title-level 1
   deft-use-filename-as-title nil
   deft-use-filter-string-for-filename t))

;; org
(setq org-directory "~/notes")


(after! org
  (map! :map org-mode-map
      "C-<return>" #'org-insert-heading-respect-content
      "C-RET" #'org-insert-heading-respect-content
      "C-S-RET" #'org-insert-todo-heading-respect-content
      "C-S-<return>" #'org-insert-todo-heading-respect-content)

  (setq org-roam-db-location (expand-file-name (concat "org-roam." (system-name) ".db") org-roam-directory))
  (map! :map org-roam-mode-map
        "C-c n l" #'org-roam
        "C-c n f" #'org-roam-find-file
        "C-c n g" #'org-roam-graph
        :map org-mode-map
        "C-c n i" #'org-roam-insert
        "C-c n I" #'org-roam-insert-immediate)

  (setq org-todo-keywords '((sequence "TODO(t)" "NEXT(n)" "PROG(p)" "|" "DONE(d)" "KILL(k)")))

  (setq org-agenda-files
        (directory-files-recursively "~/notes" "\\.org$"))

  ;; try t (org-todo) or ? help
  (setq org-use-speed-commands t)

  (setq org-capture-templates
        '(("t" "Capture" entry
           (file+headline +org-capture-todo-file "Inbox")
           "* %?\n%i\n%a" :prepend t)
          ("u" "URL" entry
           (file+headline +org-capture-todo-file "Inbox")
           "* %?\n%i\n" :prepend t)
          ("j" "Journal" entry
           (file+olp+datetree +org-capture-journal-file)))))

;; (setq org-refile-targets '(("~/Notes/gtd.org" :maxlevel . 3)
  ;;                            ("~/Notes/someday.org" :level . 1)
  ;;                            ("~/Notes/tickler.org" :maxlevel . 2)))

  ;; (require 'org-drill)
  ;; (setq org-capture-templates '(("t" "Todo [inbox]" entry
  ;;                                (file+headline "~/Notes/inbox.org" "Tasks")
  ;;                                "* TODO %i%?")
  ;;                               ("T" "Tickler" entry
  ;;                                (file+headline "~/Notes/tickler.org" "Tickler")
  ;;                                "* %i%? \n %U")))


  ;; (setq org-capture-templates
  ;;       '(("t" "Personal todo" entry
  ;;          (file+headline +org-capture-todo-file "Inbox")
  ;;          "* %?\n%i\n%a" :prepend t)
  ;;         ("u" "URL" entry
  ;;          (file+headline +org-capture-todo-file "URLs")
  ;;          "* %?\n%i\n" :prepend t)
  ;;         ("n" "Personal notes" entry

  ;;          (file+headline +org-capture-notes-file "Inbox")
  ;;          "* %u %?\n%i\n%a" :prepend t)
  ;;         ("j" "Journal" entry
  ;;          (file+olp+datetree +org-capture-journal-file)
  ;;          "* %U %?\n%i\n%a" :prepend t)
  ;;         ("p" "Templates for projects")
  ;;         ("pt" "Project-local todo" entry
  ;;          (file+headline +org-capture-project-todo-file "Inbox")
  ;;          "* TODO %?\n%i\n%a" :prepend t)
  ;;         ("pn" "Project-local notes" entry
  ;;          (file+headline +org-capture-project-notes-file "Inbox")
  ;;          "* %U %?\n%i\n%a" :prepend t)
  ;;         ("pc" "Project-local changelog" entry
  ;;          (file+headline +org-capture-project-changelog-file "Unreleased")
  ;;          "* %U %?\n%i\n%a" :prepend t)
  ;;         ("o" "Centralized templates for projects")
  ;;         ("ot" "Project todo" entry #'+org-capture-central-project-todo-file "* TODO %?\n %i\n %a" :heading "Tasks" :prepend nil)
  ;;         ("on" "Project notes" entry #'+org-capture-central-project-notes-file "* %U %?\n %i\n %a" :heading "Notes" :prepend t)
  ;;         ("oc" "Project changelog" entry #'+org-capture-central-project-changelog-file "* %U %?\n %i\n %a" :heading "Changelog" :prepend t)))

  ;; (setq org-agenda-files '("~/Notes/inbox.org"
  ;;                          "~/Notes/gtd.org"
  ;;                          "~/Notes/tickler.org"))
  ;; (setq org-refile-targets '(("~/Notes/gtd.org" :maxlevel . 3)
  ;;                            ("~/Notes/someday.org" :level . 1)
  ;;                            ("~/Notes/tickler.org" :maxlevel . 2)))
  ;; (setq org-todo-keywords '((sequence "TODO(t)" "WAITING(w)" "|" "DONE(d)" "CANCELLED(c)")))


;; lsp
(after! lsp-ui
  (setq lsp-ui-doc-show-with-cursor nil
      lsp-ui-doc-show-with-mouse t
      lsp-ui-doc-max-width 160
      lsp-ui-doc-max-height 200))

(setq lsp-headerline-breadcrumb-enable t)
;; (setq lsp-ui-sideline-enable nil)


(setq lsp-clients-clangd-args `(,(concat "-j=" (number-to-string (- (doom-system-cpus) 1)))
                                "--background-index"
                                "--clang-tidy"
                                "--compile-commands-dir=build"
                                "--completion-style=detailed"))


(add-hook! (rust-mode
            c-mode
            c++-mode
            python-mode
            go-mode)
           #'lsp)
(setq rustic-lsp-server 'rust-analyzer
      rustic-format-on-save t)
(setq lsp-rust-analyzer-server-display-inlay-hints t
      lsp-rust-analyzer-max-inlay-hint-length 20
      lsp-rust-analyzer-display-parameter-hints t
      lsp-rust-analyzer-display-chaining-hints t
      lsp-rust-analyzer-proc-macro-enable t)

;; c-mode
(setq compilation-skip-threshold 0)

(use-package! google-c-style
  :load-path "~/.config/doom/extra"
  :config

  (c-add-style "google" google-c-style)

  (c-add-style "llvm" '("gnu" (c-basic-offset . 2)
                        (fill-column . 80)
                        (c++-indent-level . 2)
                        (indent-tabs-mode . nil)
                        (c-comment-only-line-offset . 0)
                        (c-offsets-alist
                         (arglist-intro . ++)
                         (innamespace . 0)
                         (member-init-intro . ++)
                         (statement-cont . +))))

  (c-add-style "webkit" '("google" (c-basic-offset . 4)
                          (c-offsets-alist
                           (innamespace . 0)
                           (access-label . -)
                           (case-label . 0)
                           (member-init-intro . +)
                           (topmost-intro . 0)
                           (arglist-cont-nonempty . +))))

  (after! cc-mode
    (setq-default c-basic-offset 4
                  tab-width 4
                  c-default-style "google")))

(add-hook 'c-mode-common-hook #'+word-wrap-mode)

(after! smartparens
  (add-hook! (clojure-mode
              emacs-lisp-mode
              lisp-mode
              cider-repl-mode
              racket-mode
              racket-repl-mode) :append #'smartparens-strict-mode)
  (sp-use-smartparens-bindings)
  (map! :map smartparens-mode-map "M-<backspace>" nil))

;; save hooks
(add-hook 'before-save-hook 'gofmt-before-save)

(add-hook 'after-save-hook
          #'(lambda ()
              (and (save-excursion
                     (save-restriction
                       (widen)
                       (goto-char (point-min))
                       (save-match-data
                         (looking-at "^#!"))))
                   (not (file-executable-p buffer-file-name))
                   (shell-command (concat "chmod u+x " buffer-file-name))
                   (message
                    (concat "Saved as script: " buffer-file-name)))))

(require 'lsp)
(defun my/lsp-breadcrumb-go-up ()
  "breadcrumb go one level up"
  (interactive)
  (if (lsp-feature? "textDocument/documentSymbol")
      (-if-let* ((lsp--document-symbols-request-async t)
                 (symbols (lsp--get-document-symbols))
                 (symbols-hierachy (lsp--symbols->document-symbols-hierarchy symbols)))
          (let* ((get-symbol-point (lambda (symbol) (lsp--position-to-point (gethash "start" (gethash "selectionRange" symbol)))))
                 (point1 (funcall get-symbol-point (car (last symbols-hierachy)))))
            (if (= (point) point1)
                (-if-let* ((symbol (car (last symbols-hierachy 2)))
                           (point1 (funcall get-symbol-point symbol)))
                    (progn
                      (xref-push-marker-stack)
                      (goto-char point1)))
              (progn
                (xref-push-marker-stack)
                (goto-char point1)))))
    (lsp--info "Server does not support breadcrumb.")))

(after! haskell-mode
  (require 'shm)
  (defun shm/semicolon ()
    "Either insert a close paren or go to the end of the node."
    (interactive)
    (shm-with-fallback
     self-insert-command
     (if (shm-literal-insertion)
         (shm-insert-string ";")
       (progn (company-abort)
              (shm/reparse)
              (shm/goto-parent-end)))))
  (map! :map shm-map ";" #'shm/semicolon)
  ;; (set-face-background 'shm-current-face "#4c566a")
  ;; (set-face-background 'shm-quarantine-face "#bf616a")
  (add-hook 'haskell-mode-hook 'structured-haskell-mode))

;; markdown mode in rust doc
;; https://github.com/rust-lang/rust-mode/issues/100#issuecomment-691460816
(use-package poporg
  :config
  (setq poporg-edit-hook '(gfm-mode))
  (setq poporg-comment-skip-regexp "[[:space:]!/]*")
  (setq markdown-fontify-code-block-default-mode 'rustic-mode)
  (map! "C-c \"" #'poporg-dwim)
  ;; From https://doc.rust-lang.org/rustdoc/documentation-tests.html#attributes
  (setq rustdoc-attributes '("ignore" "should_panic" "no_run" "compile_fail" "edition2018"))

  (defun mg-markdown-get-lang-mode (lang)
    (if (member lang rustdoc-attributes) 'rustic-mode))
  (advice-add 'markdown-get-lang-mode :before-until #'mg-markdown-get-lang-mode))

(map!
 :after cdlatex
 :map cdlatex-mode-map
 "TAB" #'cdlatex-tab)

(use-package doom-themes
  :custom-face
  (default ((t (:background "#000000"))))
  (solaire-default-face ((t (:background "#161719"))))
  (shm-current-face ((t (:background "#4c566a"))))
  (shm-quarantine-face ((t (:background "#2e3440"))))
  :config
  (load-theme 'doom-spacegrey t))
