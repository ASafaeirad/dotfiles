call plug#begin(stdpath('data') . '/plugged')
	Plug 'neoclide/coc.nvim', {'branch': 'release'}
	Plug 'dense-analysis/ale'
	Plug 'wakatime/vim-wakatime'
	Plug 'sonph/onehalf', {'rtp': 'vim/'}
	Plug 'ayu-theme/ayu-vim' " or other package manager
	Plug 'scrooloose/nerdtree'
	"Plug 'tsony-tsonev/nerdtree-git-plugin'
	Plug 'Xuyuanp/nerdtree-git-plugin'
	Plug 'tiagofumo/vim-nerdtree-syntax-highlight'
	Plug 'ryanoasis/vim-devicons'
	Plug 'airblade/vim-gitgutter'
	Plug 'ctrlpvim/ctrlp.vim' " fuzzy find files
	Plug 'scrooloose/nerdcommenter'
	Plug 'prettier/vim-prettier', { 'do': 'yarn install' }
	Plug 'christoomey/vim-tmux-navigator'
	Plug 'morhetz/gruvbox'
	Plug 'HerringtonDarkholme/yats.vim' " TS Syntax
	Plug 'maxmellon/vim-jsx-pretty'
call plug#end()

let g:gruvbox_italic=1
let g:gruvbox_contrast_dark='soft'
let g:gruvbox_invert_selection=0

" IndentLine {{
let g:indentLine_char = ''
let g:indentLine_first_char = ''
let g:indentLine_showFirstIndentLevel = 1
let g:indentLine_setColors = 0
" }}

let g:netrw_home=$XDG_CACHE_HOME.'/nvim'

let ayucolor="mirage" " for mirage version of theme
colorscheme ayu
" colorscheme onehalfdark

let NERDTreeShowHidden=1

let NERDTreeQuitOnOpen=1


" Open empty vim with NerdTree
 if has("autocmd")
	autocmd StdinReadPre * let s:std_in=1
	autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif
 endif
