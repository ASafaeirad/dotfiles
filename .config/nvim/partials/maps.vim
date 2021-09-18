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

" Move lines via Alt-VIM keys
nnoremap <A-j> :m .+1<CR>==
nnoremap <A-k> :m .-2<CR>==
inoremap <A-j> <Esc>:m .+1<CR>==gi
inoremap <A-k> <Esc>:m .-2<CR>==gi
vnoremap <A-j> :m '>+1<CR>gv=gv
vnoremap <A-k> :m '<-2<CR>gv=gv

nnoremap <A-J> ""Y""Pj
nnoremap <A-K> ""Y""pk
vnoremap <A-J> y'>p
vnoremap <A-K> y'>P

