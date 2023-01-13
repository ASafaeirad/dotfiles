vim.g.neovide_cursor_vfx_mode = "pixiedust"
vim.g.neovide_transparency = 1
-- vim.g.neovide_cursor_trail_legnth = 0
-- vim.g.neovide_cursor_animation_length = 0
-- vim.g.neovide_floating_blur_amount_x = 0
-- vim.g.neovide_floating_blur_amount_y = 0

vim.g.neovide_scale_factor = 1.0

vim.cmd([[
  let g:gui_font_size = 12
  let g:font_family = 'JetBrainsMono\ Nerd\ Font\ Mono,DejaVuSansMono\ Nerd\ Font\ Mono,VimFile'

  silent! execute('set guifont ='.g:font_family.':h'.g:gui_font_size)

  function! ResizeFont(delta)
    let g:gui_font_size = g:gui_font_size + a:delta
    execute('set guifont ='.g:font_family.':h'.g:gui_font_size)
  endfunction

  function! ResetFont()
    let g:gui_font_size = 12
    execute('set guifont=Input\ Mono,DejaVuSansMono\ Nerd\ Font\ Mono,VimFile:h12')
  endfunction
  
  noremap <expr><C-=> ResizeFont(1)
  noremap <expr><C--> ResizeFont(-1)
  noremap <expr><C-0> ResetFont()
]])
