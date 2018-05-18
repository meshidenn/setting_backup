; ---- language-env DON'T MODIFY THIS LINE!
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ���ܸ�ɽ��������
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Added by Package.el.  This must come before configurations of
;; installed packages.  Don't delete this line.  If you don't want it,
;; just comment it out by adding a semicolon to the start of the line.
;; You may delete these explanatory comments.
(package-initialize)

(if (not (boundp 'MULE))
    (if (featurep 'xemacs)
        ; xemacs21 �ξ��
	(progn
	  (set-language-environment "Japanese")
	  (set-default-buffer-file-coding-system 'utf-8)
	  (set-keyboard-coding-system 'utf-8)
	  (if (not window-system) (set-terminal-coding-system 'utf-8))
        )
        ; emacs20 �ξ��
        (progn
	  (set-language-environment "Japanese")
	  (set-default-coding-systems 'utf-8)
	  (set-keyboard-coding-system 'utf-8)
	  (if (not window-system) (set-terminal-coding-system 'utf-8))
        )
    )
)
; ���ܸ� info ��ʸ���������ʤ��褦��
(auto-compression-mode t)
; xemacs �� shell-mode �� ���ܸ� EUC ���Ȥ���褦�ˤ���
(if (featurep 'xemacs)
    (add-hook 'shell-mode-hook (function
       (lambda () (set-buffer-process-coding-system 'euc-japan 'euc-japan))))
)
; ���ܸ� grep
(if (file-exists-p "/usr/bin/jgrep")
    (setq grep-command "jgrep -n -e ")
  )

;; Emacs 23������С��������
;;(when (< emacs-major-version 23)
;;  (defvar user-emacs-directory "~/.emacs.d/"))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; path���ɲ�
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; load-path���ɲä���ؿ������
(defun add-to-load-path (&rest paths)
  (let (path)
    (dolist (path paths paths)
      (let ((default-directory
	      (expand-file-name (concat user-emacs-directory path))))
	(add-to-list 'load-path default-directory)
	(if (fboundp 'normal-top-level-add-subdirs-to-load-path)
	    (normal-top-level-add-subdirs-to-load-path))))))

(add-to-load-path "elisp"  ".cask")

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; melpa
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(require 'package)
(add-to-list 'package-archives
	     '("melpa". "https://melpa.org/packages/"))

(package-initialize)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; cask���ɤ߹���
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(require 'cask "/usr/local/opt/cask/cask.el")
(cask-initialize)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; multi-term
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(when (require 'multi-term nil t)
  (setq multi-term-program "/bin/bash"))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Elpy ��ͭ����
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(elpy-enable)
;;; ���Ѥ��� Anaconda �β��۴Ķ�������
(defvar venv-default "~/.pyenv/versions/anaconda3-4.3.1/envs/")
;;; virtualenv ��ȤäƤ���ʤ鼡�Τ褦�ʥѥ�
(defvar venv-default "~/.virtualenvs/hoge")
;;; �ǥե���ȴĶ���ͭ����
;;(pyvenv-activate venv-default)
;;; REPL �Ķ��� IPython ��Ȥ�
(setq python-shell-interpreter "jupyter"
      python-shell-interpreter-args "console --simple-prompt")
;;; ��ư�䴰�ΥХå�����ɤȤ��� Rope �� Jedi ������
(setq elpy-rpc-backend "jedi")

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; C and C++
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(require 'cc-mode)

;; c-mode-common-hook �� C/C++ ������
(add-hook 'c-mode-common-hook
          (lambda ()
            (setq c-default-style "k&r") ;; �����˥ϥ󡦥�å�����������
            (setq indent-tabs-mode nil)  ;; ���֤����Ѥ��ʤ�
            (setq c-basic-offset 4)      ;; indent �� 4 ���ڡ���
            ))

;;; C++
(add-to-list 'auto-mode-alist '("\\.h\\'" . c++-mode))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; �����Ѵ� (Anthy) ������
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;(set-input-method "japanese-egg-anthy")
;(global-set-key "\C-o" 'toggle-input-method)
;(toggle-input-method nil)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; �������ȥ�å�������ɽ�����ʤ�������󥻥�2003/07/15
;(setq inhibit-startup-message t)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; X�ǤΥ��顼ɽ��
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(require 'font-lock)
(if (not (featurep 'xemacs))
    (global-font-lock-mode t)
)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;���顼ɽ���������ޥ��� 2003/07/15
(setq default-frame-alist
      (append (list '(foreground-color . "white")
                    '(background-color . "black")
                    '(border-color . "#ffffff")
                    '(mouse-color . "Blue")
                    '(cursor-color . "black")
                    '(width . 80)
                    '(height . 50)
                    )
              default-frame-alist))
(set-face-foreground 'mode-line "white")
(set-face-background 'mode-line "black")
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ��������С���ü��ɽ��
(set-scroll-bar-mode 'right)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ��������С�����ɽ��
;;(scroll-bar-mode -1)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ����ɽ��
(setq display-time-day-and-date t)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; �⡼�ɥ饤��˸��߻����ɽ�����롥
(display-time)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;�ġ���С���ä�
(tool-bar-mode 0)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;��˥塼�С���ä�
(menu-bar-mode 0)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;�����ȥ�С��˥ե�����̾��ɽ��
(setq frame-title-format (format "emacs@%s : %%f" (system-name)))
;;cua-mode
(cua-mode t)
(setq cua-enable-cua-keys nil)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; C �ץ����ν�
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;(defun my-c-mode-common-hook ()
;   (c-set-style "linux") (setq indent-tabs-mode t) ;linux ���������Ȥ�
;      /usr/src/linux/Documentation/CodingStyle ����
;   (c-set-style "k&r") ;k&r���������Ȥ��Ϥ����ͭ���ˤ���
;   (c-set-style "gnu") ;�ǥե���Ȥ�����
; )
;(add-hook 'c-mode-common-hook 'my-c-mode-common-hook)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Java ��������				
(setq auto-mode-alist
      (nconc '(("\\.java$" . c++-mode))
	     auto-mode-alist))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ������
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Delete�����ǥ���������֤�ʸ�����ä���褦�ˤ���
(global-set-key [delete] 'delete-char)
;; C-h �����ǥ�������κ���ʸ�����ä���褦�ˤ��롣
;; ����������Ȥ�� C-h �ϥإ�פʤΤǡ�
;; �����ͭ���ˤ���ȡ��إ�פ�Ȥ��Ȥ��ˤ�
;; M-x help �� F1 ��Ȥ�ɬ�פ�����ޤ���
;(global-set-key "\C-h" 'backward-delete-char)

; ---- language-env end DON'T MODIFY THIS LINE!
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;for print buffer `�ץ���������
(setq lpr-command  "/usr/bin/lpr")
;(setq lpr-switches '("-PPHASER2"))
(setq lpr-switches '("-PPostScript-Printer"))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; �ޡ������֤��鿧���դ���
(setq transient-mark-mode t)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; �ޥ�������Υڡ����������˥���������֤˥ڡ����Ȥ���
;(setq mouse-yank-at-point-t)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ��ɽ��
(setq line-number-mode t)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ��ɽ��
(setq column-number-mode t)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; ����ʤ�����
(setq canna-hostname "earll")
;; �������
(cua-mode t)
(setq cua-enable-cua-keys nil)
;; ���ֹ�򺸤�ɽ����ver23�ʹߤ��б���
(global-linum-mode t)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; key bindings
(define-key global-map "\C-x?" 'help-for-help)
(define-key global-map "\C-h" 'backward-delete-char)
;(define-key global-map "\C-xs" 'shell) 
(define-key global-map "\C-xc" 'compile)
(define-key global-map "\C-xg" 'goto-line)
(define-key global-map "\C-xa" 'abbrev-mode)
(define-key global-map "\C-t" 'canna-touroku-region)
(define-key global-map "\C-z" 'undo)
(define-key global-map "\C-xrp" 'replace-regexp)
(define-key global-map "\C-xw" 'copy-region-as-kill)
(global-set-key [f8] 'neotree-toggle)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; visible bell
(setq visible-bell t)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; scroll mode
(setq scroll-step 2)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;            compile mode 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(setq compile-command "make -k -f Makefile")
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;           fortran-mode
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(setq fortran-comment-region "c")
(setq fortran-comment-indent-style nil)
(setq fortran-continuation-string "&")
(setq fortran-mode-hook
	      '(lambda ()
	 (abbrev-mode 1)
       )
)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; font
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;(setq standard-fontset-spec18 "-sony-fixed-medium-r-normal--16-120-100-100-c-80-*-*")
;;(create-fontset-from-fontset-spec standard-fontset-spec18 nil 'noerror)
;;(set-default-font standard-fontset-spec18)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;=============================================================================
;;                    scroll on  mouse wheel
;;=============================================================================
;(defun up-slightly () (interactive) (scroll-up 5))
;(defun down-slightly () (interactive) (scroll-down 5))
;(global-set-key [mouse-4] 'down-slightly)
;(global-set-key [mouse-5] 'up-slightly)

;(defun up-one () (interactive) (scroll-up 1))
;(defun down-one () (interactive) (scroll-down 1))
;(global-set-key [S-mouse-4] 'down-one)
;(global-set-key [S-mouse-5] 'up-one)

;(defun up-a-lot () (interactive) (scroll-up))
;(defun down-a-lot () (interactive) (scroll-down))
;(global-set-key [C-mouse-4] 'down-a-lot)
;(global-set-key [C-mouse-5] 'up-a-lot)

;
;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;dired-mode
;(add-hook 'dired-load-hook
;          (function (lambda ()
;                      (load "dired-aux")
;                      (load "dired-dia")
;                      (load "dired-dia-ls")
;                      (load "recursive-file-op")
;                      )))
;
;(define-key global-map "\M-d" 'dired-dia-do-delete-recursive)
;(define-key global-map "\M-c" 'dired-dia-do-copy-recursive)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;mew
(autoload 'mew "mew" nil t)
(autoload 'mew-send "mew" nil t)

;;; Makefile �� etcdir �ǻ��ꤷ���ǥ��쥯�ȥ�
;(setq mew-icon-directory "/usr/local/share/emacs/site-lisp/mew/etc")

(if (boundp 'read-mail-command)
    (setq read-mail-command 'mew))
(autoload 'mew-user-agent-compose "mew" nil t)
(if (boundp 'mail-user-agent)
    (setq mail-user-agent 'mew-user-agent))
(if (fboundp 'define-mail-user-agent)
    (define-mail-user-agent
      'mew-user-agent
      'mew-user-agent-compose
      'mew-draft-send-message
      'mew-draft-kill
      'mew-send-hook))


(setq mew-user "bar")

;;; �᡼�륢�ɥ쥹�� @ �ʹߤ���ꤹ�롣
(setq mew-mail-domain "flab.isas.ac.jp")

;;; POP�����Ѥ����硣APOP �ξ������ꤹ��ɬ�פϤʤ���
(setq mew-pop-auth 'pass)

;;; POP�����ФΥ�������Ȥ���ꤹ�롣
(setq mew-pop-user "nonomura")

;;; ���Ѥ���POP�����Ф���ꤹ�롣
(setq mew-pop-server "flabmail.eng.isas.jaxa.jp")

;;; ���Ѥ���SMTP�����Сʥ᡼�륵���Сˤ���ꤹ�롣
(setq mew-smtp-server "flabmail.eng.isas.jaxa.jp")
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;�Ϥ�ä���ĳ��ˤ���(���ޥ��"|"���ڤ��ؤ����) 
;;����˥��ޥ��"m"�ǥե졼��κ���Ǿ�ɽ�����ڤ��ؤ� 
(setq ediff-split-window-function 'split-window-horizontally) 

;;; ���֤ȥ��ڡ����򤹤٤�̵�뤹��diff���ץ��������� 
(setq ediff-diff-options "-w")

;;;  e-diff tiisai window wo kesu
(setq ediff-window-setup-function 'ediff-setup-windows-plain)

;;;  subversion
;(load-file "~/psvn.el") 

;(define-key global-map "\C-xv" 'svn-status)

;;;  yatex
(setq auto-mode-alist
      (cons (cons "\\.tex$" 'yatex-mode) auto-mode-alist))
(autoload 'yatex-mode "yatex" "Yet Another LaTeX mode" t)

(setq load-path (cons "~/yatex1.73" load-path))

(setq tex-command "/usr/bin/platex")
;(setq tex-command "/usr/bin/latex")
(setq dvi2-command "/usr/bin/xdvi")

;(setq ispell-program-name "aspell") 

;;; tramp settings
(require 'tramp)
(setq tramp-default-method "ssh")
(put 'scroll-left 'disabled nil)

;; ~/.emacs.d/elisp �ǥ��쥯�ȥ����ɥѥ����ɲä���
(add-to-list 'load-path "~/.emacs.d/elisp")

;; auto-install������
;;(when (require 'auto-install nil t)
  ;; ���󥹥ȡ���ǥ��쥯�ȥ������
;;  (setq auto-install-directory "~/.emacs.d/elisp/")
  ;; EmacsWilki����Ͽ����Ƥ���elisp��̾�����������
;;  (auto-install-update-emacswiki-package-name t)
  ;; install-elisp�ؿ������Ѳ�ǽ�ˤ���
;;  (auto-install-compatibility-setup))

;; redo+������
(when (require 'redo+ nil t)
  ;; C-'��redo�������Ƥ�
  (global-set-key (kbd "C-'") 'redo)
  )

(autoload 'python-mode "python-mode" "Python editing mode." t)
(add-to-list 'auto-mode-alist '("\\.py\\'" . python-mode))
(add-to-list 'interpreter-mode-alist '("python" . python-mode))

;; python-mode ����ɤ���
(when (autoload 'python-mode "python-mode" "Python editing mode." t)
  ;; python-mode �ΤȤ��Τ� python-pep8 �Υ����Х���ɤ�ͭ���ˤ���
  (setq python-mode-hook
  (function (lambda ()
    (local-set-key "\C-c\ p" 'python-pep8))))
  (setq auto-mode-alist (cons '("\\.py$" . python-mode) auto-mode-alist))
  (setq interpreter-mode-alist (cons '("python" . python-mode)
                                     interpreter-mode-alist)))

;; jedi
;; python
;;(require 'jedi-core)
;;(setq jedi:complete-on-dot t)
;;(setq jedi:use-shortcuts t)
;;(add-hook 'python-mode-hook 'jedi:setup)
;;(add-to-list 'company-backends 'company-jedi)

;;(jedi:setup)
;;(define-key jedi-mode-map (kbd "<C-tab>") nil) ;;C-tab�ϥ�����ɥ��ΰ�ư���Ѥ���
;;(setq jedi:complete-on-dot t)
;;(setq ac-sources
;;  (delete 'ac-source-words-in-same-mode-buffers ac-sources)) ;;jedi���䴰��������Ǥ���
;;(add-to-list 'ac-sources 'ac-source-filename)
;;(add-to-list 'ac-sources 'ac-source-jedi-direct)
;;(define-key python-mode-map "\C-ct" 'jedi:goto-definition)
;;(define-key python-mode-map "\C-cb" 'jedi:goto-definition-pop-marker)
;;(define-key python-mode-map "\C-cr" 'helm-jedi-related-names)

;; flymake for python
;;(add-hook 'python-mode-hook 'flymake-find-file-hook)
;;(when (load "flymake" t)
;; (defun flymake-pyflakes-init ()
;;    (let* ((temp-file (flymake-init-create-temp-buffer-copy
;;                       'flymake-create-temp-inplace))
;;           (local-file (file-relative-name
;;                        temp-file
;;                        (file-name-directory buffer-file-name)))))))
;;(load-library "flymake-cursor")

;; pep8������
;; (require 'py-autopep8)
;; (setq py-autopep8-options '("--max-line-length=200"))
;; (setq flycheck-flake8-maximum-line-length 200)
;;(py-autopep8-enable-on-save)
;;(define-key python-mode-map (kbd "C-c F") 'py-autopep8)
;;(define-key python-mode-map (kbd "C-c f") 'py-autopep8-region)

;; ��¸���˥Хåե����Τ�ư��������
(add-hook 'before-save-hook 'py-autopep8-before-save)

;;flymake
;; (flymake-mode t)
;;error��warning��ɽ������
;;(require 'flymake-python-pyflakes)
;;(flymake-python-pyflakes-load)

;;(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
;; '(package-selected-packages (quote (python))))
;;(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
;; )

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; flycheck
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(when (require 'flycheck nil t)
  (remove-hook 'elpy-modules 'elpy-module-flymake)
  (add-hook 'elpy-mode-hook 'flycheck-mode))

(define-key elpy-mode-map (kbd "C-c C-v") 'helm-flycheck)
(require 'smartrep)   
(smartrep-define-key elpy-mode-map "C-c"
  '(("C-n" . flycheck-next-error)
    ("C-p" . flycheck-previous-error)))

;; google-cpplint
;;(eval-after-load 'flycheck
;;  '(progn
;;     (require 'flycheck-google-cpplint)
     ;; Add Google C++ Style checker.
     ;; In default, syntax checked by Clang and Cppcheck.
     ;;(flycheck-add-next-checker 'c/c++-cppcheck
     ;;                           '(warning . c/c++-googlelint))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; flymake
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(require 'flymake-google-cpplint)
(add-hook 'c-mode-hook 'flymake-google-cpplint-load)
(add-hook 'c++-mode-hook 'flymake-google-cpplint-load)

(custom-set-variables
 '(flymake-google-cpplint-verbose "3")
 '(flymake-google-cpplint-linelength "120")
 )

(custom-set-variables
 '(flymake-google-cpplint-command "/Users/hiroki-iida/.pyenv/shims/cpplint"))

