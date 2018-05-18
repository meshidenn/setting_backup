; ---- language-env DON'T MODIFY THIS LINE!
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; 日本語表示の設定
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Added by Package.el.  This must come before configurations of
;; installed packages.  Don't delete this line.  If you don't want it,
;; just comment it out by adding a semicolon to the start of the line.
;; You may delete these explanatory comments.
(package-initialize)

(if (not (boundp 'MULE))
    (if (featurep 'xemacs)
        ; xemacs21 の場合
	(progn
	  (set-language-environment "Japanese")
	  (set-default-buffer-file-coding-system 'utf-8)
	  (set-keyboard-coding-system 'utf-8)
	  (if (not window-system) (set-terminal-coding-system 'utf-8))
        )
        ; emacs20 の場合
        (progn
	  (set-language-environment "Japanese")
	  (set-default-coding-systems 'utf-8)
	  (set-keyboard-coding-system 'utf-8)
	  (if (not window-system) (set-terminal-coding-system 'utf-8))
        )
    )
)
; 日本語 info が文字化けしないように
(auto-compression-mode t)
; xemacs の shell-mode で 日本語 EUC が使えるようにする
(if (featurep 'xemacs)
    (add-hook 'shell-mode-hook (function
       (lambda () (set-buffer-process-coding-system 'euc-japan 'euc-japan))))
)
; 日本語 grep
(if (file-exists-p "/usr/bin/jgrep")
    (setq grep-command "jgrep -n -e ")
  )

;; Emacs 23より前バージョン用
;;(when (< emacs-major-version 23)
;;  (defvar user-emacs-directory "~/.emacs.d/"))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; pathの追加
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; load-pathを追加する関数を定義
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
;; caskの読み込み
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(require 'cask "/usr/local/opt/cask/cask.el")
(cask-initialize)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; multi-term
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(when (require 'multi-term nil t)
  (setq multi-term-program "/bin/bash"))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Elpy を有効化
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(elpy-enable)
;;; 使用する Anaconda の仮想環境を設定
(defvar venv-default "~/.pyenv/versions/anaconda3-4.3.1/envs/")
;;; virtualenv を使っているなら次のようなパス
(defvar venv-default "~/.virtualenvs/hoge")
;;; デフォルト環境を有効化
;;(pyvenv-activate venv-default)
;;; REPL 環境に IPython を使う
(setq python-shell-interpreter "jupyter"
      python-shell-interpreter-args "console --simple-prompt")
;;; 自動補完のバックエンドとして Rope か Jedi を選択
(setq elpy-rpc-backend "jedi")

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; C and C++
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(require 'cc-mode)

;; c-mode-common-hook は C/C++ の設定
(add-hook 'c-mode-common-hook
          (lambda ()
            (setq c-default-style "k&r") ;; カーニハン・リッチースタイル
            (setq indent-tabs-mode nil)  ;; タブは利用しない
            (setq c-basic-offset 4)      ;; indent は 4 スペース
            ))

;;; C++
(add-to-list 'auto-mode-alist '("\\.h\\'" . c++-mode))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; 漢字変換 (Anthy) の設定
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;(set-input-method "japanese-egg-anthy")
;(global-set-key "\C-o" 'toggle-input-method)
;(toggle-input-method nil)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; スタートメッセージを表示しない。キャンセル2003/07/15
;(setq inhibit-startup-message t)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Xでのカラー表示
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(require 'font-lock)
(if (not (featurep 'xemacs))
    (global-font-lock-mode t)
)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;カラー表示カスタマイズ 2003/07/15
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
;; スクロールバーを右端に表示
(set-scroll-bar-mode 'right)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; スクロールバーを非表示
;;(scroll-bar-mode -1)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; 時間表示
(setq display-time-day-and-date t)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; モードラインに現在時刻を表示する．
(display-time)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;ツールバーを消す
(tool-bar-mode 0)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;メニューバーを消す
(menu-bar-mode 0)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;タイトルバーにファイル名を表示
(setq frame-title-format (format "emacs@%s : %%f" (system-name)))
;;cua-mode
(cua-mode t)
(setq cua-enable-cua-keys nil)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; C プログラムの書式
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;(defun my-c-mode-common-hook ()
;   (c-set-style "linux") (setq indent-tabs-mode t) ;linux 式がいいとき
;      /usr/src/linux/Documentation/CodingStyle 参照
;   (c-set-style "k&r") ;k&r式がいいときはこれを有効にする
;   (c-set-style "gnu") ;デフォルトの設定
; )
;(add-hook 'c-mode-common-hook 'my-c-mode-common-hook)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Java ソース用				
(setq auto-mode-alist
      (nconc '(("\\.java$" . c++-mode))
	     auto-mode-alist))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; いろいろ
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Deleteキーでカーソル位置の文字が消えるようにする
(global-set-key [delete] 'delete-char)
;; C-h キーでカーソルの左の文字が消えるようにする。
;; ただし、もともと C-h はヘルプなので、
;; これを有効にすると、ヘルプを使うときには
;; M-x help や F1 を使う必要があります。
;(global-set-key "\C-h" 'backward-delete-char)

; ---- language-env end DON'T MODIFY THIS LINE!
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;for print buffer `プリント用設定
(setq lpr-command  "/usr/bin/lpr")
;(setq lpr-switches '("-PPHASER2"))
(setq lpr-switches '("-PPostScript-Printer"))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; マーク位置から色を付ける
(setq transient-mark-mode t)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; マウスからのペースト操作時にカーソル位置にペーストする
;(setq mouse-yank-at-point-t)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; 行表示
(setq line-number-mode t)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; 列表示
(setq column-number-mode t)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; かんなの設定
(setq canna-hostname "earll")
;; 矩形選択
(cua-mode t)
(setq cua-enable-cua-keys nil)
;; 行番号を左に表示（ver23以降で対応）
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

;;; Makefile の etcdir で指定したディレクトリ
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

;;; メールアドレスの @ 以降を指定する。
(setq mew-mail-domain "flab.isas.ac.jp")

;;; POPを利用する場合。APOP の場合は設定する必要はない。
(setq mew-pop-auth 'pass)

;;; POPサーバのアカウントを指定する。
(setq mew-pop-user "nonomura")

;;; 利用するPOPサーバを指定する。
(setq mew-pop-server "flabmail.eng.isas.jaxa.jp")

;;; 利用するSMTPサーバ（メールサーバ）を指定する。
(setq mew-smtp-server "flabmail.eng.isas.jaxa.jp")
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;始めっから縦割りにする(コマンド"|"で切り替えれる) 
;;さらにコマンド"m"でフレームの最大最小表示の切り替え 
(setq ediff-split-window-function 'split-window-horizontally) 

;;; タブとスペースをすべて無視するdiffオプションの設定 
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

;; ~/.emacs.d/elisp ディレクトリをロードパスに追加する
(add-to-list 'load-path "~/.emacs.d/elisp")

;; auto-installの設定
;;(when (require 'auto-install nil t)
  ;; インストールディレクトリの設定
;;  (setq auto-install-directory "~/.emacs.d/elisp/")
  ;; EmacsWilkiに登録されているelispの名前を取得する
;;  (auto-install-update-emacswiki-package-name t)
  ;; install-elisp関数を利用可能にする
;;  (auto-install-compatibility-setup))

;; redo+の設定
(when (require 'redo+ nil t)
  ;; C-'にredoを割り当てる
  (global-set-key (kbd "C-'") 'redo)
  )

(autoload 'python-mode "python-mode" "Python editing mode." t)
(add-to-list 'auto-mode-alist '("\\.py\\'" . python-mode))
(add-to-list 'interpreter-mode-alist '("python" . python-mode))

;; python-mode をロードする
(when (autoload 'python-mode "python-mode" "Python editing mode." t)
  ;; python-mode のときのみ python-pep8 のキーバインドを有効にする
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
;;(define-key jedi-mode-map (kbd "<C-tab>") nil) ;;C-tabはウィンドウの移動に用いる
;;(setq jedi:complete-on-dot t)
;;(setq ac-sources
;;  (delete 'ac-source-words-in-same-mode-buffers ac-sources)) ;;jediの補完候補だけでいい
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

;; pep8の利用
;; (require 'py-autopep8)
;; (setq py-autopep8-options '("--max-line-length=200"))
;; (setq flycheck-flake8-maximum-line-length 200)
;;(py-autopep8-enable-on-save)
;;(define-key python-mode-map (kbd "C-c F") 'py-autopep8)
;;(define-key python-mode-map (kbd "C-c f") 'py-autopep8-region)

;; 保存時にバッファ全体を自動整形する
(add-hook 'before-save-hook 'py-autopep8-before-save)

;;flymake
;; (flymake-mode t)
;;errorやwarningを表示する
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

