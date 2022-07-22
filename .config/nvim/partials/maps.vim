nmap <leader>R :source $MYVIMRC<CR>
vnoremap <C-c> "+y
inoremap <C-v> <F10><C-r>+<F10>
nmap <leader>o o<Esc>d$
nmap <leader>O O<Esc>d$
nmap <leader>c "_c
nmap <leader>d "_d
vnoremap <leader>p "_dP
vnoremap <leader>c "_c
vnoremap p "_dP
map <leader><Bslash> :NERDTreeToggle<CR>

" Remap VIM 0 to first non-blank character
map 0 ^

" Move a line of text using ALT+[jk] or Command+[jk] on mac
nmap <M-k> mz:m-2<cr>`z
nmap <M-j> mz:m+<cr>`z
vmap <M-j> :m'>+<cr>`<my`>mzgv`yo`z
vmap <M-k> :m'<-2<cr>`>my`<mzgv`yo`z

if has("mac") || has("macunix")
  nmap <D-j> <M-j>
  nmap <D-k> <M-k>
  vmap <D-j> <M-j>
  vmap <D-k> <M-k>
endif

nmap <C-b> 
nnoremap <A-K> ""Y""pk
nnoremap <A-J> ""Y""Pj
vnoremap <A-J> y'>p
"vnoremap <A-K> y'>P

" let g:VM_maps = {}
" let g:VM_maps['Find Under']         = '<C-b>'
" let g:VM_maps['Find Subword Under'] = '<C-b>'
" let g:VM_maps['Find Word']          = '<C-b>'


