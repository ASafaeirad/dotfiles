vim.g.neovide_cursor_vfx_mode = "pixiedust"
vim.g.neovide_transparency = 0.8
vim.g.neovide_floating_blur_amount_x = 2
vim.g.neovide_floating_blur_amount_y = 2

vim.g.neovide_scale_factor = 1.0

-- let g:neovide_scale_factor = g:neovide_scale_factor * a:delta
-- vim.cmd([[
--   let g:neovide_scale_factor=1.0
--   function! ChangeScaleFactor(delta)
--     set guifont = "Input Mono,DejaVuSansMono Nerd Font Mono,VimFile:h12",
--   endfunction
--   nnoremap <expr><C-=> ChangeScaleFactor(1.25)
--   nnoremap <expr><C--> ChangeScaleFactor(1/1.25)
-- ]])

vim.cmd([[
  let g:gui_font_size = 12
  silent! execute('set guifont=Input\ Mono,DejaVuSansMono\ Nerd\ Font\ Mono,VimFile:h'.g:gui_font_size)

  function! ResizeFont(delta)
    let g:gui_font_size = g:gui_font_size + a:delta
    execute('set guifont=Input\ Mono,DejaVuSansMono\ Nerd\ Font\ Mono,VimFile:h'.g:gui_font_size)
  endfunction

  function! ResetFont()
    let g:gui_font_size = 12
    execute('set guifont=Input\ Mono,DejaVuSansMono\ Nerd\ Font\ Mono,VimFile:h12')
  endfunction
  
  noremap <expr><C-=> ResizeFont(1)
  noremap <expr><C--> ResizeFont(-1)
  noremap <expr><C-0> ResetFont()
]])
