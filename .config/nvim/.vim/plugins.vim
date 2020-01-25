call plug#begin(stdpath('data') . '/plugged')
	Plug 'neoclide/coc.nvim', {'branch': 'release'}
	Plug 'scrooloose/nerdtree'
	"Plug 'tsony-tsonev/nerdtree-git-plugin'
	Plug 'Xuyuanp/nerdtree-git-plugin'
	Plug 'tiagofumo/vim-nerdtree-syntax-highlight'
	Plug 'ryanoasis/vim-devicons'
	Plug 'airblade/vim-gitgutter'
	Plug 'ctrlpvim/ctrlp.vim' " fuzzy find files
	Plug 'scrooloose/nerdcommenter'
	"Plug 'prettier/vim-prettier', { 'do': 'yarn install' }
	Plug 'christoomey/vim-tmux-navigator'
	Plug 'morhetz/gruvbox'
	Plug 'HerringtonDarkholme/yats.vim' " TS Syntax
call plug#end()

let g:gruvbox_italic=1
let g:gruvbox_contrast_dark='soft'
let g:gruvbox_invert_selection=0

try
   colorscheme gruvbox
catch
endtry

let NERDTreeShowHidden=1
let NERDTreeQuitOnOpen=1

" Open empty vim with NerdTree
 if has("autocmd")
   autocmd StdinReadPre * let s:std_in=1
   autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif
 endif


