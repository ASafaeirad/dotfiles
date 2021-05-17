function! MyHighlights() abort
		highlight Whitespace cterm=NONE ctermbg=NONE  ctermfg=239
endfunction

augroup MyColors
    autocmd!
    autocmd ColorScheme * call MyHighlights()
augroup END

