set runtimepath+=~/.cache/dein/repos/github.com/Shougo/dein.vim

if dein#load_state('~/.cache/dein')
  call dein#begin('~/.cache/dein')
  call dein#add('~/.cache/dein/repos/github.com/Shougo/dein.vim')

  " Add or remove your plugins here:
  call dein#add('morhetz/gruvbox')
  call dein#add('scrooloose/nerdtree')

  " Required:
  call dein#end()
  call dein#save_state()

endif

" Required:
filetype plugin indent on
syntax enable

"if dein#check_install()
"  call dein#install()
"endif


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
" if has("autocmd")
"   autocmd StdinReadPre * let s:std_in=1
"   autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif
" endif


