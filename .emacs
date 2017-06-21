(setq mac-option-modifier 'meta )
(setq mac-command-modifier 'super )
(define-key global-map [home] 'beginning-of-line)
(define-key global-map [end] 'end-of-line)

(define-key global-map [SC-up] 'scroll-down-line)
(define-key global-map [SC-down] 'scroll-up-line)

(define-key global-map [C-S-up] 'scroll-down-line)
(define-key global-map [C-S-down] 'scroll-up-line)

  
;; Turn on highlighting globally
(global-font-lock-mode t)

;; automatically load cperl-mode for perl files
(fset 'perl-mode 'cperl-mode)

;; show column number in status line
(setq column-number-mode t)


;;show only the toplevel nodes when loading a file
;;(add-hook 'cperl-mode-hook 'hide-body)

;; outline minor mode with cperl
(add-hook 'cperl-mode-hook 'outline-minor-mode)

;; Change the prefi xfor outline commands from C-c @ to C-c C-o
(setq outline-minor-mode-prefix "\C-co")

;;(load-file "cperl-mode.el")

;; disable tabs
(setq-default indent-tabs-mode nil)

(add-to-list 'load-path "~/.emacs.d/el-get/el-get")


(unless (require 'el-get nil 'noerror)
  (with-current-buffer
      (url-retrieve-synchronously
       "https://raw.githubusercontent.com/dimitri/el-get/master/el-get-install.el")
    (goto-char (point-max))
    (eval-print-last-sexp)))

(add-to-list 'el-get-recipe-path "~/.emacs.d/el-get-user/recipes")
(el-get 'sync)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ansi-color-names-vector
   ["#2e3436" "#a40000" "#4e9a06" "#c4a000" "#204a87" "#5c3566" "#729fcf" "#eeeeec"])
 '(auto-revert-remote-files t)
 '(custom-enabled-themes
   +(quote (deeper-blue)))
 '(elpy-rpc-backend "jedi")
 '(elpy-rpc-timeout 5)
 '(inhibit-startup-screen t))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(cperl-array-face ((t (:background "Black" :foreground "LightBlue" :weight bold))))
 '(cperl-hash-face ((t (:background "windowBackgroundColor" :foreground "red" :slant italic :weight bold))))
 '(font-lock-function-name-face ((t (:foreground "Cyan"))))
 '(linum ((t (:inherit (shadow default) :background "color-234" :box (:line-width 2 :color "grey75" :style released-button))))))

;;; cperl-mode is preferred to perl-mode
(defalias 'perl-mode 'cperl-mode)

; Outline-minor-mode key map
(define-prefix-command 'cm-map nil "Outline-")
; HIDE
(define-key cm-map "q" 'hide-sublevels)    ; Hide everything but the top-level headings
(define-key cm-map "t" 'hide-body)         ; Hide everything but headings (all body lines)
(define-key cm-map "o" 'hide-other)        ; Hide other branches
(define-key cm-map "c" 'hide-entry)        ; Hide this entry's body
(define-key cm-map "l" 'hide-leaves)       ; Hide body lines in this entry and sub-entries
(define-key cm-map "d" 'hide-subtree)      ; Hide everything in this entry and sub-entries
; SHOW
(define-key cm-map "a" 'show-all)          ; Show (expand) everything
(define-key cm-map "e" 'show-entry)        ; Show this heading's body
(define-key cm-map "i" 'show-children)     ; Show this heading's immediate child sub-headings
(define-key cm-map "k" 'show-branches)     ; Show all sub-headings under this heading
(define-key cm-map "s" 'show-subtree)      ; Show (expand) everything in this heading & below
; MOVE
(define-key cm-map "u" 'outline-up-heading)                ; Up
(define-key cm-map "n" 'outline-next-visible-heading)      ; Next
(define-key cm-map "p" 'outline-previous-visible-heading)  ; Previous
(define-key cm-map "f" 'outline-forward-same-level)        ; Forward - same level
(define-key cm-map "b" 'outline-backward-same-level)       ; Backward - same level
(global-set-key "\M-o" cm-map)

;;
;; Parenthesis matching enable and set style
;;
(show-paren-mode t)                 ; turn paren-mode on
(setq show-paren-style 'expression) ; alternatives are 'parenthesis' and 'mixed'

;;
;; Turn on linum mode for perl code
;;
(add-hook 'cperl-mode-hook 'my-cperl-mode-hook)
(defun my-cperl-mode-hook ()
  (linum-mode 1))

          
(setq cperl-invalid-face nil) 

;; Customize linum format to add space after line number
(setq linum-format "%4d ")

;; Set preferred indentation style
(setq cperl-indent-level 4)
(setq cperl-brace-offset 0)
(setq cperl-continued-brace-offset -4)
(setq cperl-label-offset -4)
(setq cperl-continued-statement-offset 4)
(setq cperl-extra-newline-before-brace 1)

;; Turn on automatic keyword and brace expansion
(setq cperl-electric-keywords 1)
(setq cperl-electric-parens 1)

;; Enable single keystroke to run commands against buffer
(defun shell-command-on-buffer ()
  "Asks for a command and executes it in inferior shell with current buffer
as input."
  (interactive)
  (shell-command-on-region
   (point-min) (point-max)
   (read-shell-command "Shell command on buffer: ")))

(defun perl-on-buffer ()
  "Runs perl in inferior shell with current buffer
as input."
  (interactive)
  (shell-command-on-region
   (point-min) (point-max)
   "perl"))

(defun perl-debug-on-buffer ()
  "Runs perl -d in inferior shell with current buffer
as input."
  (interactive)
  (shell-command-on-region
   (point-min) (point-max)
   "perl -d"))

(global-set-key (kbd "<f5>") 'perl-debug-on-buffer)
(global-set-key (kbd "C-<f5>") 'perl-on-buffer)


;;
;; More perl fun
;;


(defvar perl-syntax-bin "perl"
    "The perl binary used to check syntax.")

(defvar perl-syntax-check-filename nil)

(defun perl-syntax-check-fname-parser(fname)
  "Returns the original filename as parsed from compiler outuput if set,
          or the filename for the buffer used to produce the compiler output if not set.
          used as part of perl-syntax-check-only functionality"
  (message "parsing filename: current: %s, perl-syntax-check-filename: %s" fname perl-syntax-check=filename)
  (message fname)
  (if fname
      (fname)
  ) 
)

;;    (setq compilation-parse-errors-filename-function perl-syntax-check-filename)
     
(defun perl-syntax-check-only ()
  "Returns a either nil or t depending on whether \\
     the current buffer passes perl's syntax check."
  (interactive)
  (let ((buf (get-buffer-create "*Perl syntax check*")))
    (with-current-buffer buf (progn
                                  (read-only-mode 0)
                                  (setf (buffer-string) "")
                               )
    )
    (let ((syntax-ok (= 0 (save-excursion
                            (widen)
                            (call-process-region
                             (point-min) (point-max) perl-syntax-bin nil buf nil "-c"))) ))
      (if syntax-ok 
          (kill-buffer buf)
          (progn
             (display-buffer buf)
             (setq perl-syntax-check-filename (file-name-nondirectory (buffer-file-name)))
             (with-current-buffer buf (progn 
                                        (fundamental-mode)
                                        (goto-char (point-min))
                                        (while (re-search-forward "- line \\([0-9]+\\)" nil t)
                                        (replace-match (concat perl-syntax-check-filename " line \\1") nil nil))
                                        (compilation-mode)
                                        (first-error)
                                        )
                               )
          )
        )
      syntax-ok)))


  (defvar perl-syntax-mode nil
    "Check perl syntax before saving.")
  (make-variable-buffer-local 'perl-syntax-mode)
  (defun perl-syntax-write-hook ()
    "Check perl syntax during 'write-file-hooks' for 'perl-syntax-mode'"
    (if perl-syntax-mode
        (save-excursion
          (widen)
          (mark-whole-buffer)
          (not (perl-syntax-check-only)))
      nil))

(global-set-key "\C-c " 'perl-syntax-check-only)


  (defun perl-syntax-mode (&optional arg)
    "Perl syntax checking minor mode."
    (interactive "P")
    (setq perl-syntax-mode
          (if (null arg)
              (not perl-syntax-mode)
            (> (prefix-numeric-value arg) 0)))
    (if perl-syntax-mode
        (add-hook 'write-file-hooks 'perl-syntax-write-hook)
      (remove-hook 'write-file-hooks 'perl-syntax-write-hook)))
  (if (not (assq 'perl-syntax-mode minor-mode-alist))
      (setq minor-mode-alist
            (cons '(perl-syntax-mode " Perl Syntax")
                  minor-mode-alist)))
  (eval-after-load "cperl-mode"
    '(add-hook 'cperl-mode-hook 'perl-syntax-mode))
               

(setq perl-syntax-mode t);

(defmacro mark-active ()
    "Xemacs/emacs compatibility macro"
    (if (boundp 'mark-active)
        'mark-active
      '(mark)))

(defun perltidy ()
  "Run perltidy on the current region or buffer."
  (interactive)
  ; Inexplicably, save-excursion doesn't work here.
    (shell-command-on-region (point) (mark) "perltidy -bl -q -l=128" nil t)
)

(global-set-key "\C-ct" 'perltidy)


(defvar perltidy-mode nil
    "Automatically 'perltidy' when saving.")
  (make-variable-buffer-local 'perltidy-mode)
  (defun perltidy-write-hook ()
    "Perltidys a buffer during 'write-file-hooks' for 'perltidy-mode'"
    (if perltidy-mode
        (save-excursion
          (widen)
          (mark-whole-buffer)
          (not (perltidy)))
      nil))
  (defun perltidy-mode (&optional arg)
    "Perltidy minor mode."
    (interactive "P")
    (setq perltidy-mode
          (if (null arg)
              (not perltidy-mode)
            (> (prefix-numeric-value arg) 0)))
    (if perltidy-mode
        (add-hook 'write-file-hooks 'perltidy-write-hook)
      (remove-hook 'write-file-hooks 'perltidy-write-hook)))
  (if (not (assq 'perltidy-mode minor-mode-alist))
      (setq minor-mode-alist
            (cons '(perltidy-mode " Perltidy")
                  minor-mode-alist)))
  (eval-after-load "cperl-mode"
    '(add-hook 'cperl-mode-hook 'perltidy-mode))


;;
;; Setup packages
;;
(require 'package)
(setq package-archives '(("gnu" . "https://elpa.gnu.org/packages/")
                         ("marmalade" . "https://marmalade-repo.org/packages/")
                         ("melpa" . "https://melpa.org/packages/")
                         ("elpy" . "https://jorgenschaefer.github.io/packages/"))
      )


(package-initialize)
(elpy-enable)

(defun my-python-mode-hook ()
  "Sets custom (MDW) settings for python mode"
  (linum-mode 1)
  ;; (define-key python-mode-map (kbd "<f10>") 'gud-next)
  ;; (define-key python-mode-map (kbd "<f11>") 'gud-step)
  ;; (define-key python-mode-map (kbd "S-<f11>") 'gud-finish)
  ;; (define-key python-mode-map (kbd "<f5>") 'gud-cont)
  ;; (define-key python-mode-map (kbd "<f9>") 'gud-break)

  ;; (define-key inferior-python-mode-map (kbd "<f10>") 'gud-next)
  ;; (define-key inferior-python-mode-map (kbd "<f11>") 'gud-step)
  ;; (define-key inferior-python-mode-map (kbd "S-<f11>") 'gud-finish)
  ;; (define-key inferior-python-mode-map (kbd "<f5>") 'gud-cont)
  ;; (define-key inferior-python-mode-map (kbd "<f9>") 'gud-break)  
)

(add-hook 'python-mode-hook  'my-python-mode-hook)


(windmove-default-keybindings)
(setq windmove-wrap-around t)


(defconst user-init-dir
  (cond ((boundp 'user-emacs-directory)
         user-emacs-directory)
        ((boundp 'user-init-directory)
         user-init-directory)
        (t "~/.emacs.d/")))


(defun load-user-file (file)
  (interactive "f")
  "Load a file in current user's configuration directory"
  (load-file (expand-file-name file user-init-dir)))


(load-user-file "init_term.el")

(require 'gud)    
(define-key gud-mode-map (kbd "<f10>") 'gud-next)
(define-key gud-mode-map (kbd "<f11>") 'gud-step)
(define-key gud-mode-map (kbd "S-<f11>") 'gud-finish)
(define-key gud-mode-map (kbd "<f5>") 'gud-cont)
(define-key gud-mode-map (kbd "<f9>") 'gud-break)

(define-key gud-minor-mode-map (kbd "<f10>") 'gud-next)
(define-key gud-minor-mode-map (kbd "<f11>") 'gud-step)
(define-key gud-minor-mode-map (kbd "S-<f11>") 'gud-finish)
(define-key gud-minor-mode-map (kbd "<f5>") 'gud-cont)
(define-key gud-minor-mode-map (kbd "<f9>") 'gud-break)

(defun set-window-width (n)
  "Set the selected window's width."
  (adjust-window-trailing-edge (selected-window) (- n (window-width)) t))

(defun set-80-columns ()
  "Set the selected window to 80 columns."
  (interactive)
  (set-window-width 82))

(global-set-key (kbd "<f12>") 'set-80-columns)

(defun remove-trailing-whitespace ()
  "Removes trailing whitespace from all lines in the current buffer"
  (interactive)
  (save-excursion
    (beginning-of-buffer)
    (replace-regexp "\\s +$" "")
  ))

(global-set-key (kbd "<f12>") 'set-80-columns)
(global-set-key (kbd "C-c C-w") 'remove-trailing-whitespace)
(global-set-key (kbd "C-x g") 'magit-status) 

                                                                             
                                                                                
(add-to-list 'auto-mode-alist '("\\.t\\'" . cperl-mode))
(add-to-list 'auto-mode-alist '("\\.js\\'" . js2-mode))
(add-to-list 'auto-mode-alist '("\\.json\\'" . js2-mode))

(setenv "PATH" "$PATH:/usr/local/bin" 1)
(pyvenv-activate " ~/mfab/Scheduling/apps/ScheduleService/venv")

;;(remove-from-list 'auto-mode-alist '("\\.js\\'" . js2-mode))
;;(remove-from-list 'auto-mode-alist '("\\.json\\'" . js2-mode))

(desktop-save-mode 1)
(setq desktop-auto-save-timeout 120)
