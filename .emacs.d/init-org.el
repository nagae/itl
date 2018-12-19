;; ========================================
;;
;; org-mode の設定
;;
;; ========================================
;; --------------------------------------------------------------------------------
;; org-mode を呼ぶ前に必要な処理(ここから)
;; ----------------------------------------
; org-mode では auto-fill-mode を切る
(add-hook 'org-mode-hook
          '(lambda ()
             (setq fill-column 80)
             (auto-fill-mode -1)
	     (flyspell-mode -1)
             ))

;; org-mode では ispell-parser を tex モードに
(add-hook 'org-mode-hook (lambda () (setq ispell-parser 'tex)))

;; C-c C-j でのインクリメンタルサーチを無効に(org-modeを呼ぶ前に)
(setq org-goto-auto-isearch nil)

;; 強調 (org-mode を呼ぶ前に設定する)
(defface my/org-alert-face
        '((t (:weight bold :foreground "black" :foreground "#FF0000")))
        "Face used to display alert'ed items.")
(defface my/org-structure-face
        '((t (:weight bold :foreground "black" :foreground "#0000FF")))
        "Face used to display alert'ed items.")
(setq org-emph-face t)
(setq org-emphasis-alist
      '(("*" my/org-alert-face bold)
	("/" italic)
	("_" underline)
	("=" org-verbatim verbatim)
	("~" org-code verbatim)
	))
;; (setq org-emphasis-alist
;;       '(("*" my/org-alert-face bold)
;; 	("/" italic)
;; 	("_" underline)
;; 	("=" org-verbatim verbatim)
;; 	("~" org-code verbatim)
;; 	("+" my/org-structure-face
;; 	 (:strike-through nil))
;; 	))

;; ----------------------------------------
;; org-mode を呼ぶ前に必要な処理(ここまで)
;; --------------------------------------------------------------------------------
(require 'org)

;; ----------------------------------------
;; org-mode の設定
;; ----------------------------------------
;; 基本ディレクトリ
;; Set to the location of your Org files on your local system
(setq org-directory "~/Dropbox/org")
;; Set to the name of the file where new notes will be stored
(setq org-mobile-inbox-for-pull "~/Dropbox/org/flagged.org")

;; キーバインドの設定
(global-set-key "\C-cl" 'org-store-link)
;(global-set-key "\C-ca" 'org-agenda)
(global-set-key "\C-cb" 'org-iswitchb)

;; デフォルトの設定
(setq org-startup-folded nil) 		; 折り畳まない
(setq org-startup-indented t)		; インデントする

;; 拡張子がorgのファイルを開いた時，自動的にorg-modeにする
(add-to-list 'auto-mode-alist '("\\.org$" . org-mode))

;; org-modeでの強調表示を可能にする
(add-hook 'org-mode-hook 'turn-on-font-lock)

;; 見出しの余分な*を消す
(setq org-hide-leading-stars t)

;; リスト番号にアルファベットも含める
(setq org-alphabetical-lists t)

;; M-x toggle-truncation を実行する度に折り返しを切り替える
;; http://d.hatena.ne.jp/stakizawa/20091025/t1
(setq org-startup-truncated t)
(defun toggle-truncation()
  (interactive)
  (cond ((eq truncate-lines nil)
         (setq truncate-lines t))
        (t
         (setq truncate-lines nil))))
(global-set-key (kbd "C-|") 'toggle-truncate-lines)  ; 折り返し表示ON/OFF

; 
; http://oku.edu.mie-u.ac.jp/~okumura/texwiki/?Emacs%2FOrg%20mode
;;
;; Org mode
;;
;; ----------------------------------------
;; org-mode + LaTeX
;; ----------------------------------------
;; LaTeX が使えるように
(require 'ox-latex)
;; Beamer が使えるように
(require 'ox-beamer)
;; LaTeX文を処理
(setq org-export-with-latex t)
;; LaTeX文を処理
(setq org-export-with-LaTeX-fragments t)
;; アーカイブされたsubtreeは出力しない
(setq org-export-with-archived-trees nil)
;;; \hypersetup{...} を出力しない
(setq org-latex-with-hyperref nil)
;;; org-mode で :PROPERTIES: :CUSTOM_ID: でラベルを
(setq org-latex-prefer-user-labels t)
;;
(setq org-format-latex-header
      '"\\documentclass{article}
%\\usepackage[usenames]{xcolor}
[PACKAGES]
[DEFAULT-PACKAGES]
\\pagestyle{empty}             % do not remove
% The settings below are copied from fullpage.sty
\\setlength{\\textwidth}{\\paperwidth}
\\addtolength{\\textwidth}{-3cm}
\\setlength{\\oddsidemargin}{1.5cm}
\\addtolength{\\oddsidemargin}{-2.54cm}
\\setlength{\\evensidemargin}{\\oddsidemargin}
\\setlength{\\textheight}{\\paperheight}
\\addtolength{\\textheight}{-\\headheight}
\\addtolength{\\textheight}{-\\headsep}
\\addtolength{\\textheight}{-\\footskip}
\\addtolength{\\textheight}{-3cm}
\\setlength{\\topmargin}{1.5cm}
\\addtolength{\\topmargin}{-2.54cm}
\\AtBeginDocument{\\color{white}}"
)

;; ----------------------------------------
;; org-mode + reftex
;; ----------------------------------------
;; RefTeXで使用するbibファイルの位置を指定する
(setq reftex-default-bibliography
      '("~/Dropbox/texmf/bibtex/bib/Mendeley/library.bib"
	"~/Dropbox/texmf/bibtex/bib/mybib.bib"	))
;; org-mode でreftexが使えるようにキーバインドを設定
(defun org-mode-reftex-setup ()
  (load-library "reftex")
  (and (buffer-file-name)
       (file-exists-p (buffer-file-name))
       (reftex-parse-all))
  (define-key org-mode-map (kbd "C-c C-x [") 'reftex-citation)
  (define-key org-mode-map (kbd "C-c C-x =") 'reftex-toc)
  (define-key org-mode-map (kbd "C-c C-x <") 'reftex-index)
  (define-key org-mode-map (kbd "C-c C-x >") 'reftex-display-index)
  (define-key org-mode-map (kbd "C-c C-x &") 'reftex-view-crossref)
  (define-key org-mode-map (kbd "C-c C-x )") 'reftex-reference)
  (define-key org-mode-map (kbd "C-c C-x (") 'reftex-label)
  )
(add-hook 'org-mode-hook 'org-mode-reftex-setup)

;; ----------------------------------------
;; Org-export
;; ----------------------------------------
;; AL, AH で LaTeX や HTML のアトリビュートを変更できるように
(add-to-list 'org-structure-template-alist '("AL" "#+ATTR_LaTeX:"))
(add-to-list 'org-structure-template-alist '("AH" "#+ATTR_HTML:"))
(add-to-list 'org-structure-template-alist '("LH" "#+LATEX_HEADER:"))
(add-to-list 'org-structure-template-alist '("BH" "#+BEAMER_HEADER:"))

;; Beamer で +hoge+ を \sout{hoge} ではなく \structure{hoge} に
(defun my-beamer-structure (contents backend info)
  (when (eq backend 'beamer)
    (replace-regexp-in-string "\\`\\\\[A-Za-z0-9]+" "\\\\structure" contents)))

(add-to-list 'org-export-filter-strike-through-functions 'my-beamer-structure)

;; ----------------------------------------
;; Org-export-latex
;; ----------------------------------------
;(require 'org-special-blocks)

;; 170331 org で preview が機能しなくなったので下記を修正
;; http://stackoverflow.com/questions/41568410/configure-org-mode-to-use-lualatex
;; <<<<<<<<<<
;; ;; PDF で出力するのに latexmk を使う
;; (setq org-latex-pdf-process 
;; 					     '("latexmk -e '$pdflatex=q/lualatex %S/' -e '$bibtex=q/bibtexu %B/' -e '$biber=q/biber --bblencoding=utf8 -u -U --shell-escape --output_safechars %B/' -e '$makeindex=q/makeindex -o %D %S/' -norc -gg -pdf %f"))

;; (setq org-latex-pdf-process
;;       '("lualatex --shell-escape -interaction nonstopmode -output-directory %o %f" "lualatex -interaction nonstopmode -output-directory %o %f" "lualatex -interaction nonstopmode -output-directory %o %f"))
;; ----------
;; PDF で出力するのに LuaLaTeX を使う
;; lualatex preview
;; もしこの設定でうまくいかない場合は *Org PDF LaTeX Output* を見ること.
;; TeXLive でインストールされる ghostscript (gs) が動いていないケースがある.
;; その場合は homebrew でインストールし直せば機能する
;; http://blog.ramshackleroad.com/post/164978298785/latexit-stopped-rendering


;(setq org-preview-latex-default-process 'luamagick)
;; >>>>>>>>>>

;; org-mode からのコンパイルを latexmk にする
(setq org-latex-pdf-process (list "latexmk -f %f"))

(setq org-preview-latex-process-alist
   (quote
    ((luamagick :programs
		("lualatex" "convert")
		:description "pdf > png" :message "you need to install lualatex and imagemagick." :use-xcolor t :image-input-type "pdf" :image-output-type "png" :image-size-adjust
		(1.0 . 1.0)
		:latex-compiler
		("lualatex -interaction nonstopmode -output-directory %o %f")
		:image-converter
		("convert -density %D -trim -antialias %f -quality 100 %O"))
     (udvipng :programs
	     ("latex" "dvipng")
	     :description "dvi > png" :message "you need to install the programs: latex and dvipng." :image-input-type "dvi" :image-output-type "png" :image-size-adjust
	     (1.0 . 1.0)
	     :latex-compiler
	     ("uplatex -interaction nonstopmode -output-directory %o %f")
	     :image-converter
	     ("dvipng -fg %F -bg %B -D %D -T tight -o %O %f"))
     (dvipng :programs
	     ("latex" "dvipng")
	     :description "dvi > png" :message "you need to install the programs: latex and dvipng." :image-input-type "dvi" :image-output-type "png" :image-size-adjust
	     (1.0 . 1.0)
	     :latex-compiler
	     ("platex -interaction nonstopmode -output-directory %o %f")
	     :image-converter
	     ("dvipng -fg %F -bg %B -D %D -T tight -o %O %f"))
     (dvisvgm :programs
	      ("latex" "dvisvgm")
	      :description "dvi > svg" :message "you need to install the programs: latex and dvisvgm." :use-xcolor t :image-input-type "dvi" :image-output-type "svg" :image-size-adjust
	      (1.7 . 1.5)
	      :latex-compiler
	      ("platex -interaction nonstopmode -output-directory %o %f")
	      :image-converter
	      ("dvisvgm %f -n -b min -c %S -o %O"))
     (imagemagick :programs
		  ("latex" "convert")
		  :description "pdf > png" :message "you need to install the programs: latex and imagemagick." :use-xcolor t :image-input-type "pdf" :image-output-type "png" :image-size-adjust
		  (1.0 . 1.0)
		  :latex-compiler
		  ("pdflatex -interaction nonstopmode -output-directory %o %f")
		  :image-converter
		  ("convert -density %D -trim -antialias %f -quality 100 %O")))))
;; 数式を表示させるのに imagemagick を使う(LuaLaTeXでは必須)
;(setq org-preview-latex-default-process 'dvipng) ;; dvipng を使う
(setq org-preview-latex-default-process 'imagemagick)
;(setq org-preview-latex-default-process 'udvipng) ;; dvipng を使う

;; 数式の表示形式
(setq org-format-latex-options 
      (quote
       (:foreground default
		    :background default
		    :scale 1.5
		    :html-foreground "White"
		    :html-background "Transparent"
		    :html-scale 2.0
		    :matchers
		    ("begin" "$1" "$" "$$" "\\(" "\\["))))

;; LaTeX でエクスポート
(setq org-export-latex-coding-system 'utf-8)
(setq org-export-latex-date-format "%Y-%m-%d")
(setq org-export-latex-default-class "jsarticle")
;; http://d.hatena.ne.jp/tamura70/20100217/org
(setq org-latex-classes
      '(("jsarticle"
	 "\\documentclass[11pt,a4paper,uplatex]{jsarticle}"
	 ("\\section{%s}" . "\\section*{%s}")
	 ("\\subsection{%s}" . "\\subsection*{%s}")
	 ("\\subsubsection{%s}" . "\\subsubsection*{%s}")
	 ("\\paragraph{%s}" . "\\paragraph*{%s}")
	 ("\\subparagraph{%s}" . "\\subparagraph*{%s}"))
	("jsce"
	 "\\documentclass[platex,nosetpagesize]{jsce}[NO-PACKAGES]"
	 ("\\section{%s}" . "\\section*{%s}")
	 ("\\subsection{%s}" . "\\subsection*{%s}")
	 ("\\subsubsection{%s}" . "\\subsubsection*{%s}")
	 ("\\paragraph{%s}" . "\\paragraph*{%s}")
	 ("\\subparagraph{%s}" . "\\subparagraph*{%s}"))
	("plain-jsarticle"
	 "\\documentclass[11pt,a4paper,uplatex]{jsarticle}
	 [NO-DEFAULT-PACKAGES]"
	 ("\\section{%s}" . "\\section*{%s}")
	 ("\\subsection{%s}" . "\\subsection*{%s}")
	 ("\\subsubsection{%s}" . "\\subsubsection*{%s}")
	 ("\\paragraph{%s}" . "\\paragraph*{%s}")
	 ("\\subparagraph{%s}" . "\\subparagraph*{%s}"))
	("esarticle"
	 "\\documentclass[11pt,a4paper,english,uplatex]{jsarticle}"
	 ("\\section{%s}" . "\\section*{%s}")
	 ("\\subsection{%s}" . "\\subsection*{%s}")
	 ("\\subsubsection{%s}" . "\\subsubsection*{%s}")
	 ("\\paragraph{%s}" . "\\paragraph*{%s}")
	 ("\\subparagraph{%s}" . "\\subparagraph*{%s}"))
	("article"
	 "\\documentclass[11pt,a4paper]{article}"
	 ("\\section{%s}" . "\\section*{%s}")
	 ("\\subsection{%s}" . "\\subsection*{%s}")
	 ("\\subsubsection{%s}" . "\\subsubsection*{%s}")
	 ("\\paragraph{%s}" . "\\paragraph*{%s}")
	 ("\\subparagraph{%s}" . "\\subparagraph*{%s}"))
	("jsbook"
	 "\\documentclass[11pt,a4paper]{jsbook}"
	 ("\\chapter{%s}" . "\\chapter*{%s}")
	 ("\\section{%s}" . "\\section*{%s}")
	 ("\\subsection{%s}" . "\\subsection*{%s}")
	 ("\\subsubsection{%s}" . "\\subsubsection*{%s}")
	 ("\\paragraph{%s}" . "\\paragraph*{%s}")
	 ("\\subparagraph{%s}" . "\\subparagraph*{%s}"))
	("beamer"
	 "\\documentclass[t,brown,hyperref={dvipdfmx,setpagesize=false,bookmarks=true,bookmarksnumbered=true,bookmarkstype=toc},color={dvipdfmx}]{beamer}
	 [NO-DEFAULT-PACKAGES]"
	 )
	("ltj-beamer"
	 "\\documentclass\{beamer\}
\\usepackage{luatexja}           %Beamerで日本語を使う
         [NO-DEFAULT-PACKAGES]"
	  ("\\section\{%s\}" . "\\section*\{%s\}")
               ("\\subsection\{%s\}" . "\\subsection*\{%s\}")
               ("\\subsubsection\{%s\}" . "\\subsubsection*\{%s\}")
	       )
	("ltj-beamer-modern"
	 "\\documentclass\{beamer\}
[NO-DEFAULT-PACKAGES]
\\usepackage{luatexja}           %Beamerで日本語を使う
\\definecolor{mWetAsphalt}{HTML}{34495e}
\\definecolor{mMidnightBlue}{HTML}{2c3e50}
\\definecolor{mPumpkin}{HTML}{d35400}
\\definecolor{mPomegranate}{HTML}{c0392b}
\\definecolor{mBelizeHole}{HTML}{2980b9}
\\definecolor{mGreenSea}{HTML}{16a085}
\\definecolor{mDarkBrown}{HTML}{604c38}
\\definecolor{mDarkTeal}{HTML}{23373b}
\\definecolor{mLightBrown}{HTML}{EB811B}
\\definecolor{mMediumBrown}{HTML}{C87A2F}
\\setbeamercolor{palette primary}{fg=mDarkTeal, bg=black!2}
\\setbeamercolor{palette primary}{fg=mWetAsphalt, bg=black!2}
\\setbeamercolor{palette secondary}{fg=white, bg=mDarkTeal}
\\setbeamercolor{palette quaternary}{fg=mDarkBrown}
\\setbeamercolor{palette tertiary}{fg=white, bg=mMediumBrown}
\\setbeamercolor{section title}{parent=palette primary}
\\setbeamercolor{frametitle}{parent=palette secondary}
\\setbeamercolor{background canvas}{parent=palette primary}
\\setbeamercolor{structure}{fg=mDarkTeal!50!mBelizeHole}
\\setbeamercolor{normal text}{fg=black!97}
\\setbeamercolor{alerted text}{fg=mLightBrown!20!mPumpkin}
\\setbeamercolor{footnote}{fg=mDarkTeal!50}
\\setbeamercolor{page number in head/foot}{fg=mDarkTeal}
\\setbeamercolor{block title alerted}{parent=palette tertiary}
\\setbeamercolor{block body alerted}{parent=normal text,use=block title alerted,bg=block title alerted.bg!10!bg}"
	  ("\\section\{%s\}" . "\\section*\{%s\}")
               ("\\subsection\{%s\}" . "\\subsection*\{%s\}")
               ("\\subsubsection\{%s\}" . "\\subsubsection*\{%s\}")
	       )
	("orgwp"
	 "\\documentclass[11pt,a4paper]{jsarticle}
         [DEFAULT-PACKAGES]\\usepackage{orgwp}"
	 ("\\section{%s}" . "\\section*{%s}")
	 ("\\subsection{%s}" . "\\subsection*{%s}")
	 ("\\subsubsection{%s}" . "\\subsubsection*{%s}")
	 ("\\paragraph{%s}" . "\\paragraph*{%s}")
	 ("\\subparagraph{%s}" . "\\subparagraph*{%s}"))
	("ltjsarticle"
	 "\\documentclass[11pt,a4paper]{ltjsarticle}\\usepackage{etex}
         [DEFAULT-PACKAGES]"
	 ("\\section{%s}" . "\\section*{%s}")
	 ("\\subsection{%s}" . "\\subsection*{%s}")
	 ("\\subsubsection{%s}" . "\\subsubsection*{%s}")
	 ("\\paragraph{%s}" . "\\paragraph*{%s}")
	 ("\\subparagraph{%s}" . "\\subparagraph*{%s}"))
	("amsart"
	 "\\documentclass[11pt,a4paper]{amsart}"
	 ("\\section{%s}" . "\\section*{%s}")
	 ("\\subsection{%s}" . "\\subsection*{%s}")
	 ("\\subsubsection{%s}" . "\\subsubsection*{%s}")
	 ("\\paragraph{%s}" . "\\paragraph*{%s}")
	 ("\\subparagraph{%s}" . "\\subparagraph*{%s}"))
	))


;; http://tmishina.cocolog-nifty.com/blog/2010/11/org-jsarticle-l.html
(setq org-latex-default-packages-alist
  '(;("AUTO"     "inputenc"  t)
    ;("T1"       "fontenc"   t)
    ("dvipdfmx" "graphicx"  t)
    ("dvipdfmx,usenames" "xcolor" t)
    ;("dvipdfmx,setpagesize=false,bookmarks=true,bookmarksnumbered=true,bookmarkstype=toc"     "hyperref"  nil)
    (""         "longtable" nil)
    (""         "float"     nil)
    (""         "latexsym"  t)
    (""         "amssymb"   t)
    (""         "ascmac"   t)
    (""         "fancybox"   t)
    (""         "soul"   t)
    (""         "tikz"   t)
    ;(""         "ulem"   nil)
    ;(""         "ulinej"   t)
    ;("expert,deluxe" "otf"  nil)
    ))

;; ----------------------------------------
;; org-capture-mode
;; ----------------------------------------
;;(setq org-default-notes-file (concat org-directory "~/Dropbox/org/notes.org"))
(define-key global-map "\C-cc" 'org-capture)

(setq org-capture-templates
      '(("t" "Todo" entry (file+headline "~/Dropbox/org/todo.org" "Tasks")
             "* TODO %?\n %i\n %a")
        ("j" "Journal" entry (file+datetree "~/Dropbox/org/journal.org")
             "* %?\ %U\n %i\n %a")
        ("n" "Note" entry (file+headline "~/Dropbox/org/notes.org" "Notes")
             "* %?\n %U\n %i")
        ("m" "Minutes" entry (file+headline "~/Dropbox/org/minutes.org" "Minutes")
             "* %u %?\n #+title: \n - 日時:%<%Y>年%<%m>月%<%d>日%<%H:%M>\n - 場所:\n - 出席者:\n - 欠席者:")
         ))


;; tikz をプレビューできるように
(add-to-list 'org-latex-packages-alist
             '("" "tikz" t))
(eval-after-load "preview"
  '(add-to-list 'preview-default-preamble "\\PreviewEnvironment{tikzpicture}" t))
