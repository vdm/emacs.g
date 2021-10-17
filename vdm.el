(defvar previous-buffer-repeat-map
  (let ((map (make-sparse-keymap)))
    (define-key map [left] 'previous-buffer)
    map)
  "Keymap to repeat previous-window key sequences.  Used in `repeat-mode'.")
(put 'previous-buffer 'repeat-map 'previous-buffer-repeat-map)

(defvar next-buffer-repeat-map
  (let ((map (make-sparse-keymap)))
    (define-key map [right] 'next-buffer)
    map)
  "Keymap to repeat next-window key sequences.  Used in `repeat-mode'.")
(put 'next-buffer 'repeat-map 'next-buffer-repeat-map)

(repeat-mode 1)

(use-package vterm
  :load-path  "lib/vterm")

;; https://github.com/golang/tools/blob/master/gopls/doc/emacs.md
;;
;; Configuring project for Go modules
(require 'project)

(defun project-find-go-module (dir)
  (when-let ((root (locate-dominating-file dir "go.mod")))
    (cons 'go-module root)))

(cl-defmethod project-root ((project (head go-module)))
  (cdr project))

(add-hook 'project-find-functions #'project-find-go-module)

;; load before eglot to enable eglot integration
;; (require 'company)
;; (require 'yasnippet)

(require 'go-mode)
(require 'eglot)
;(add-hook 'go-mode-hook 'eglot-ensure)
(add-hook 'go-mode-hook
          (lambda ()
	    (eglot-ensure)
	    (setq gofmt-command "goimports")
            (add-hook 'before-save-hook 'gofmt-before-save)
            (setq tab-width 2)
            (setq indent-tabs-mode 1)))

(setq-default eglot-workspace-configuration
    '((:gopls .
        ((staticcheck . t)
         (matcher . "CaseSensitive")))))

(eww-open-file "/usr/local/go/doc/go_spec.html")
;; (rename-buffer "go_spec")

(define-key eglot-mode-map (kbd "C-c o") 'eglot-code-action-organize-imports)

;; without this, errors are highlighted but not shown under point, only under mouse pointer
;; https://github.com/joaotavora/eglot/issues/8#issuecomment-414149077
(advice-add 'eglot-eldoc-function :around
            (lambda (oldfun)
              (let ((help (help-at-pt-kbd-string)))
                (if help (message "%s" help) (funcall oldfun)))))
(use-package markdown-mode
  :ensure t
  :commands (markdown-mode gfm-mode)
  :mode (("README\\.md\\'" . gfm-mode)
         ("\\.md\\'" . markdown-mode)
         ("\\.markdown\\'" . markdown-mode))
  :init (setq markdown-command "pandoc"))
(use-package darkroom)
