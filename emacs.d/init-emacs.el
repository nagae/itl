;; ========================================
;; 
;; Emacs の基本設定
;; 
;; ========================================

;; ----------------------------------------
;; 日本語関係
;; ----------------------------------------
;; 言語を日本語にする
(set-language-environment 'Japanese)
;; 極力 UTF-8とする
(prefer-coding-system 'utf-8)

;; ----------------------------------------
;; デフォルト設定
;; ----------------------------------------
;; スタートアップメッセージを非表示
(setq inhibit-startup-message t)
;; バッファ末尾に余計な改行コードを防ぐための設定
(setq next-line-add-newlines nil)
;; 列数表示
(column-number-mode 1)
;; 行数表示
(line-number-mode t)
;; 選択部分のハイライト
(transient-mark-mode t)
;; リージョン内の文字をBSで削除
(delete-selection-mode 1)
;; 対応するカッコをハイライト
(show-paren-mode 1)
;; *~ バックアップファイルは必要
(setq make-backup-files t)
;; #* バックアップファイルは必要
(setq auto-save-default t)
;; 補完機能を使う
(setq partial-completion-mode 1) 
;; file名の補完で大文字小文字を区別しない
(setq completion-ignore-case t) 
;; 削除ファイルをゴミ箱へ
(setq delete-by-moving-to-trash t)
(setq trash-directory "~/.Trash")
;; 時刻の表示( 曜日 月 日 時間:分 )
(setq display-time-day-and-date t)
(setq display-time-24hr-format t)
(display-time-mode t)
;; C-x n / C-x C-n の設定
(put 'narrow-to-region 'disabled nil)	; C-x n n でナローイング
(put 'set-goal-column 'disabled nil)	; C-x C-n で goal-column
;; M-: でeldoc-mode
(add-hook 'eval-expression-minibuffer-setup-hook 'eldoc-mode)

;; ----------------------------------------
;; helm
;; ----------------------------------------
(require 'helm)
(require 'helm-config)
(helm-mode 1)
;; TAB を補完に使う
(define-key helm-find-files-map (kbd "TAB") 'helm-execute-persistent-action)
(define-key helm-read-file-map (kbd "TAB") 'helm-execute-persistent-action)
;; M-x を helm-M-x に置換
(global-set-key (kbd "M-x") 'helm-M-x)
;; C-x b を helm-mini に置換
(global-set-key (kbd "C-x b") 'helm-mini) 
;; C-x C-f を helm-fild-files に置換
;; https://qiita.com/jabberwocky0139/items/86df1d3108e147c69e2c
(global-set-key (kbd "C-x C-f") 'helm-find-files) 

(setq helm-buffers-fuzzy-matching t
      helm-recentf-fuzzy-match    t)

;; ----------------------------------------
;; キーバインド
;; ----------------------------------------
;; Command-Key and Option-Key
(setq ns-command-modifier (quote meta))	; command key をメタキーに
(setq ns-alternate-modifier (quote super)) ; option key をsuperキーに
;; システムへ修飾キーを渡さない
(setq mac-pass-control-to-system nil)
(setq mac-pass-command-to-system nil)
(setq mac-pass-option-to-system nil)
;; C-k で改行も含めてカット
(setq kill-whole-line t)
;; M-g で goto-line
(global-set-key "\M-g" 'goto-line)
;; M-n, M-p で next-error, previous-error (org のspan tree の検索で利用) 
(global-set-key "\M-n" 'next-error)
(global-set-key "\M-p" 'previous-error)
;; C-? で C-o と同様にウィンドウを切り替え
(global-set-key (kbd "C-:") 'other-window)
;; バッファを C-> C-< で切り替える
(global-set-key (kbd "C-<") 'bs-cycle-previous)
(global-set-key (kbd "C->") 'bs-cycle-next)
;; ediff で別ウィンドウを表示しない
(setq ediff-window-setup-function 'ediff-setup-windows-plain)

;; ----------------------------------------
;; dired
;; ----------------------------------------
;; dired で r キーでファイル名変更が行えるように
(require 'wdired)
(define-key dired-mode-map "r" 'wdired-change-to-wdired-mode)
;; dired を拡張
(load "dired-x")
;; ファイル名のみ表示
(define-key dired-mode-map (kbd "(") 'dired-hide-details-mode)
(define-key dired-mode-map (kbd ")") 'dired-hide-details-mode)
;; dired-filder-mode を dired-modeでonにする
(defun dired-mode-hooks()
	(dired-filter-mode))
(add-hook 'dired-mode-hook 'dired-mode-hooks)
;; dired で RET キーで新規にバッファを作成していたのを a に割当
(put 'dired-find-alternate-file 'disabled nil)
(define-key dired-mode-map (kbd "RET") 'dired-find-alternate-file)
(define-key dired-mode-map "a" 'dired-advertised-find-file)
;;; dired を使って、一気にファイルの coding system (漢字) を変換する
;; http://www.bookshelf.jp/soft/meadow_25.html#SEC278
(require 'dired-aux)
(add-hook 'dired-mode-hook
          (lambda ()
            (define-key (current-local-map) "T"
              'dired-do-convert-coding-system)))
(defvar dired-default-file-coding-system nil
  "*Default coding system for converting file (s).")
(defvar dired-file-coding-system 'no-conversion)
(defun dired-convert-coding-system ()
  (let ((file (dired-get-filename))
        (coding-system-for-write dired-file-coding-system)
        failure)
    (condition-case err
        (with-temp-buffer
          (insert-file file)
          (write-region (point-min) (point-max) file))
      (error (setq failure err)))
    (if (not failure)
        nil
      (dired-log "convert coding system error for %s:\n%s\n" file failure)
      (dired-make-relative file))))
(defun dired-do-convert-coding-system (coding-system &optional arg)
  "Convert file (s) in specified coding system."
  (interactive
   (list (let ((default (or dired-default-file-coding-system
                            buffer-file-coding-system)))
           (read-coding-system
            (format "Coding system for converting file (s) (default, %s): "
                    default)
            default))
         current-prefix-arg))
  (check-coding-system coding-system)
  (setq dired-file-coding-system coding-system)
  (dired-map-over-marks-check
   (function dired-convert-coding-system) arg 'convert-coding-system t))

;; ----------------------------------------
;; eshell
;; ----------------------------------------
;; s-! で eshell-command を起動できるように
(global-set-key (kbd "s-!") 'eshell-command)
(setq eshell-directory-name "~/.emacs.d/eshell/")

;; ----------------------------------------
;; auto-fill-mode
;; ----------------------------------------
;; テキスト・モードでは auto-fill-mode
(add-hook 'text-mode-hook
          '(lambda ()
             (setq fill-column 80)
             (auto-fill-mode t)
             ))


;; ----------------------------------------
;; aspell
;; ----------------------------------------
;; aspell を使うためには, ~/.aspell.conf に lang en_US を記述しておく必要がある
;; $ echo "lang en_US" > ~/.aspell.conf
(setq-default ispell-program-name "aspell")
(with-eval-after-load "ispell"
  (add-to-list 'ispell-skip-region-alist '("[^\000-\377]+")))

;; ----------------------------------------
;; セッションを自動的に保存
;; ----------------------------------------
;; M-x package-install RET session RET
(add-hook 'after-init-hook 'session-initialize)
(setq session-save-file-coding-system 'utf-8-unix)

;; ----------------------------------------
;; browse-kill-ring
;; ----------------------------------------
;; M-y を単独で使う場合には browse-kil-ring を呼び出せる
(browse-kill-ring-default-keybindings)

;; ----------------------------------------
;; word-count-mode
;; ----------------------------------------
;; http://www.emacswiki.org/emacs/WordCount
;; ----------------------------------------
(require 'wc-mode)
(global-set-key "\M-+" 'wc-mode)

;; ----------------------------------------
;; sr-speedbar
;; ----------------------------------------
;; http://www.emacswiki.org/emacs/sr-speedbar.el
;; ----------------------------------------
(require 'sr-speedbar)
;; s-s で sr-speedbar を呼び出す
(global-set-key (kbd "s-s") 'sr-speedbar-toggle)
;; sr-speedbar ウィンドウで ^ を押すと1つ上のディレクトリに移動
(define-key speedbar-file-key-map "^" 'speedbar-up-directory)

;; ----------------------------------------
;; magit
;; ----------------------------------------
;; http://philjackson.github.com/magit/
;; ----------------------------------------
(require 'magit)
;; C-x g でmagit-status を呼び出す
(global-set-key (kbd "C-x g") 'magit-status)
(global-set-key [(control \?)] 'magit-status)
(setq magit-last-seen-setup-instructions "1.4.0") ; 1.4.0のメッセージを表示させない

;; ----------------------------------------
;; markdown-mode
;; ----------------------------------------
;; http://jblevins.org/projects/markdown-mode/
(autoload 'markdown-mode "markdown-mode"
   "Major mode for editing Markdown files" t)
(add-to-list 'auto-mode-alist '("\\.md" . gfm-mode))

;; SKKで変換確定を return で行なうと行頭にカーソルが飛ぶ問題の対策
(defun my--markdown-entery-key-ad (this-func &rest args)
  "markdown-modeでskk-henkan-mode中にエンターすると行頭にカーソルが飛んでしまう問題の対応"
  (if skk-henkan-mode (skk-kakutei)
    (apply this-func args)))
(advice-add #'markdown-enter-key :around #'my--markdown-entery-key-ad)

;; ----------------------------------------
;; simplenote2 モード
;; ~/.emacs.d/init.el に以下を書き込んで利用する
;; (setq simplenote2-email "example@sample.com")
;; (setq simplenote2-password "password")
;; ----------------------------------------
(require 'simplenote2)
(simplenote2-setup)
(add-hook 'simplenote2-note-mode-hook
          (lambda ()
	    (auto-fill-mode 0)
            (local-set-key (kbd "C-c C-t") 'simplenote2-add-tag)
            (local-set-key (kbd "C-c C-c") 'simplenote2-push-buffer)
            (local-set-key (kbd "C-c C-d") 'simplenote2-pull-buffer)))
;; スクロールバーを非表示
(set-scroll-bar-mode nil)
;; ツールバーを非表示
(tool-bar-mode -1)
;; ドラッグ&ドロップの挙動：挿入しないで新たにファイルを開く
(define-key global-map [ns-drag-file] 'ns-find-file)
;; 新しいウィンドウを開かずに，新規バッファに開く
(setq ns-pop-up-frames nil)

;; ----------------------------------------
;; フルスクリーン切り替え
;; ----------------------------------------
;; M-x toggle-fullscreen でフルスクリーンの切り替え
(defun toggle-fullscreen ()
  (interactive)
  (set-frame-parameter nil 'fullscreen (if (frame-parameter nil 'fullscreen)
                                           nil
                                           'fullboth)))
;; C-^ にフルスクリーン切り替えを割当てる
(global-set-key (kbd "C-^") 'toggle-fullscreen)

;; ----------------------------------------
;; フォントの設定 
;; ----------------------------------------
;; https://github.com/adobe-fonts/source-han-code-jp
;; 
;; Source Han Code JP N のインストール方法:
;; 1. 以下のサイトの OTC ディレクトリから SourceHanCodeJP.ttc をダウンロード:
;; https://github.com/adobe-fonts/source-han-code-jp/tree/release
;; 2. ダウンロードしたフォントをダブルクリックするとフォントブックが開くので「インストール」をクリック
(set-default-font "Source Han Code JP N")
(add-to-list 'default-frame-alist
                       '(font . "Source Han Code JP N-14"))

;; ----------------------------------------
;; テーマの設定
;; ----------------------------------------
;; 組み込みテーマでいいなら, M-x load-theme で好きなのを探して
;; 下記を参考に気に入ったテーマを自動で読込むように設定すればよい
;
;(load-theme 'deeper-blue t) ; 組み込みの中では一番好み
;(load-theme 'misterioso t)
;(load-theme 'wombat t)
;; 
;; zenburn もお勧め
(load-theme 'zenburn t)

;; ----------------------------------------
;; ポップアップ・ダイアログを禁止する
;; ----------------------------------------
(defalias 'message-box 'message)
(setq use-dialog-box nil)

;; ----------------------------------------
;; ワークスペースの管理: persp-mode
;; ----------------------------------------
;; http://emacs.rubikitch.com/persp-mode/
(setq persp-keymap-prefix (kbd "C-c p")) ;prefix
(setq persp-add-on-switch-or-display t) ;バッファを切り替えたら見えるようにする
(persp-mode 1)
(defun persp-register-buffers-on-create ()
  (interactive)
  (dolist (bufname (condition-case _
                       (helm-comp-read
                        "Buffers: "
                        (mapcar 'buffer-name (buffer-list))
                        :must-match t
                        :marked-candidates t)
                     (quit nil)))
    (persp-add-buffer (get-buffer bufname))))
(add-hook 'persp-activated-hook 'persp-register-buffers-on-create)

;; ----------------------------------------
;; C言語用の設定
;; irony-mode を使うためには, 一度だけ M-x irony-install-server の実行が必要
;; =============
;; irony-mode
;; =============
(add-hook 'c++-mode-hook 'irony-mode)
(add-hook 'c-mode-hook 'irony-mode)
;; =============
;; company mode
;; =============
(add-hook 'c++-mode-hook 'company-mode)
(add-hook 'c-mode-hook 'company-mode)
;; replace the `completion-at-point' and `complete-symbol' bindings in
;; irony-mode's buffers by irony-mode's function
(defun my-irony-mode-hook ()
(define-key irony-mode-map [remap completion-at-point]
  'irony-completion-at-point-async)
(define-key irony-mode-map [remap complete-symbol]
  'irony-completion-at-point-async))
(add-hook 'irony-mode-hook 'my-irony-mode-hook)
(add-hook 'irony-mode-hook 'irony-cdb-autosetup-compile-options)
(eval-after-load 'company
'(add-to-list 'company-backends 'company-irony))
;; (optional) adds CC special commands to `company-begin-commands' in order to
;; trigger completion at interesting places, such as after scope operator
;;     std::|
(add-hook 'irony-mode-hook 'company-irony-setup-begin-commands)
;; =============
;; flycheck-mode
;; =============
(add-hook 'c++-mode-hook 'flycheck-mode)
(add-hook 'c-mode-hook 'flycheck-mode)
(eval-after-load 'flycheck
'(add-hook 'flycheck-mode-hook #'flycheck-irony-setup))
;; =============
;; eldoc-mode
;; =============
(add-hook 'irony-mode-hook 'irony-eldoc)
;; ==========================================
;; (optional) bind TAB for indent-or-complete
;; ==========================================
(defun irony--check-expansion ()
(save-excursion
  (if (looking-at "\\_>") t
    (backward-char 1)
    (if (looking-at "\\.") t
      (backward-char 1)
      (if (looking-at "->") t nil)))))
(defun irony--indent-or-complete ()
"Indent or Complete"
(interactive)
(cond ((and (not (use-region-p))
            (irony--check-expansion))
       (message "complete")
       (company-complete-common))
      (t
       (message "indent")
       (call-interactively 'c-indent-line-or-region))))
(defun irony-mode-keys ()
"Modify keymaps used by `irony-mode'."
(local-set-key (kbd "TAB") 'irony--indent-or-complete)
(local-set-key [tab] 'irony--indent-or-complete))
(add-hook 'c-mode-common-hook 'irony-mode-keys)
