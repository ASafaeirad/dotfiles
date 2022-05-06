function! MyHighlights() abort
    highlight Whitespace cterm=NONE ctermbg=NONE  ctermfg=239
    highlight Search     cterm=NONE ctermbg=237  ctermfg=NONE
endfunction

augroup MyColors
    autocmd!
    autocmd ColorScheme * call MyHighlights()
augroup END

