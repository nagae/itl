;; ========================================
;;
;; TeX 関連
;;
;; ========================================

;; ----------------------------------------
;; RefTeX / BibTeX-mode
;; ----------------------------------------
;; RefTeXによる数式の引用を \eqref にする
(setq reftex-default-bibliography
      '("~/Dropbox/texmf/bibtex/bib/Mendeley/library.bib"
	"~/Dropbox/texmf/bibtex/bib/mybib.bib"	))
(setq reftex-label-alist '((nil ?e nil "\\eqref{%s}" nil nil)))
(setq reftex-cite-format 'natbib)

;; RefTeXで挿入するラベルをプロンプトで聞く
;; 1つ目の引数は自動生成されるラベルに文脈を反映させる環境
;; 2つ目の引数にプロンプトを有効とする環境
;; 例えば，("s" "sft") なら，1)節(s)の見出しを文脈から自動生成
;; 2)節(s)，図(f)，表(t)についてはプロンプトが有効，数式(e)についてはプロンプト無し
;; s: section
;; f: figure
;; t: table
;; e: equation
;; なお，番号をリセットするには M-x reftex-reset-mode
(setq reftex-insert-label-flags '("s" "sfte"))

;; ----------------------------------------
;; AUCTeX + preview latex
;; ----------------------------------------
; 参考: 
; http://homepage.mac.com/matsuan_tamachan/software/AucTex.html
; http://at-aka.blogspot.com/2005/09/preview-latex-20059-auctex.html
; http://www.emacswiki.org/emacs/AUCTeX#toc2
; http://www.tom.sfc.keio.ac.jp/~hattori/blog/setting/2009/01/auctex-dvipdfmx.html
(require 'tex-site)
(require 'tex)
;(load "auctex.el" nil t t)
;(load "preview-latex.el" nil t t)

;; 複数ファイルに分割した場合にマスターファイルを認識させる
(setq-default TeX-master nil)

;; 構文解析
(setq TeX-parse-self t)			; 自動で構文を解析
(setq TeX-auto-save t)			; 構文を解析した結果を自動保存

;; LaTeX-math や RefTeX を使えるように
(add-hook 'LaTeX-mode-hook 'LaTeX-math-mode)
(add-hook 'LaTeX-mode-hook 'turn-on-reftex)
;; LaTeX モードでは flyspell モードに (org-mode で export するたびに ispell が起動するので外す)
;(add-hook 'LaTeX-mode-hook (lambda () (flyspell-mode t)))

; (add-hook 'LaTeX-mode-hook 'TeX-PDF-mode) ; これすると .eps が使えない

;; RefTeX との連携
;; http://www.gnu.org/s/emacs/manual/html_node/reftex/AUCTeX_002dRefTeX-Interface.html
(setq reftex-plug-into-AUCTeX t)

;; 禁則処理によって行長が述びてもよいように
;; http://oku.edu.mie-u.ac.jp/~okumura/texwiki/?AUCTeX
(setq kinsoku-limit 10)

;; 数式をインラインで表示
(setq preview-image-type 'dvipng)

;; doc-view-mode で自動的に再読み込み
(setq TeX-PDF-mode t)
(add-hook 'doc-view-mode-hook 'auto-revert-mode)

;; AUC-mode で呼び出せる TeX コマンド
(add-hook 'LaTeX-mode-hook (function (lambda ()
  (add-to-list 'TeX-command-list
    '("pLaTeX" "platex --shell-escape %`%S%(PDFout)%(mode)%' %t"
      TeX-run-TeX nil (latex-mode) :help "Run ASCII pLaTeX"))
  (add-to-list 'TeX-command-list
    '("pBibTeX" "pbibtex -kanji=utf8 '%s'"
      TeX-run-TeX nil nil :help "Run pBiBTeX"))
  (add-to-list 'TeX-command-list
    '("latexmk" "latexmk -f '%s' " TeX-run-command nil nil
      :help "Run latexmk"))
  (add-to-list 'TeX-command-list
    '("direct" "latexmk -pv -f '%s' " TeX-run-command nil nil
      :help "Run latexmk and open"))
  (add-to-list 'TeX-command-list
    '("dvipdfmx" "dvipdfmx -V7 -o '%s.pdf' '%s.dvi' " TeX-run-command nil nil
      :help "Run dvipdfmx"))
  (add-to-list 'TeX-command-list
    '("lualatex" "lualatex -shell-escape -f '%s' " TeX-run-TeX nil nil :help "Run LuaLaTeX"))
)))

;; ----------------------------------------
;; CDLaTeX
;; ----------------------------------------
;; add more notations to cdlatex mode
;; http://staff.science.uva.nl/~dominik/Tools/cdlatex/cdlatex.el
(setq cdlatex-env-alist
      '(("align*" "\\begin{align*}\n?\n\\end{align*}\n" nil)
	("equation*" "\\begin{equation*}\n?\n\\end{equation*}\n" nil)
	("cases" "\\begin{cases}\n?\n\\end{cases}" nil)
	("split" "\\begin{split}\n?\n\\end{split}" nil)
	("bmatrix" "\\begin{bmatrix}\n?\n\\end{bmatrix}" nil)
	("bMatriX" "\\begin{bMatriX}\n?\n\\end{bMatriX}" nil)
	("frame" "\\begin{frame}\n\\frametitle{?}\n\\end{frame}\n" nil)
	("subequations" "\\begin{subequations}\nAUTOLABEL?\n\\end{subequations}\n" nil)
	))
(setq cdlatex-command-alist
      '(("eq*" "Insert equation* env" "" cdlatex-environment ("equation*") t t)
	("ca" "Insert case env" "" cdlatex-environment ("cases") t t)
	("sp" "Insert bmatrix env" "" cdlatex-environment ("split") t t)
	("bm" "Insert bmatrix env" "" cdlatex-environment ("bmatrix") t t)
	("bM" "Insert bmatrix env" "" cdlatex-environment ("bMatriX") t t)
	))
(setq cdlatex-math-symbol-alist
      '((?\; ("\\Vt" "\\Rm" "\\Cl"))
	))

;; ----------------------------------------
;; CDLaTeX
;; ----------------------------------------
(add-hook 'org-mode-hook 'turn-on-org-cdlatex)
(define-key org-cdlatex-mode-map "_" 'self-insert-command)
(define-key org-cdlatex-mode-map "^" 'self-insert-command)
(define-key org-cdlatex-mode-map "{" 'cdlatex-pbb)
(define-key org-cdlatex-mode-map "[" 'cdlatex-pbb)


;; ----------------------------------------
;; latex-math-preview (2016.5.10)
;; ---------------------------------------- 
(autoload 'latex-math-preview-expression "latex-math-preview" nil t)
(autoload 'latex-math-preview-insert-symbol "latex-math-preview" nil t)
(autoload 'latex-math-preview-save-image-file "latex-math-preview" nil t)
(autoload 'latex-math-preview-beamer-frame "latex-math-preview" nil t)

(setq-default latex-math-preview-tex-to-png-for-preview '(lualatex-to-dvi dvipng))
(setq-default latex-math-preview-tex-to-png-for-save '(lualatex-to-dvi dvipng))
(setq-default latex-math-preview-tex-to-eps-for-save '(lualatex-to-dvi dvips-to-eps))
(setq-default latex-math-preview-tex-to-ps-for-save '(lualatex-to-dvi dvips-to-ps))
(setq-default latex-math-preview-beamer-to-png '(lualatex-to-pdf gs-to-png))
(define-key org-mode-map (kbd "C-c p") 'latex-math-preview-expression)
