if &compatible
  set nocompatible
endif

source ~/.config/nvim/.vim/plugins.vim
source ~/.config/nvim/.vim/init.vim
source ~/.config/nvim/.vim/abbrevations.vim
source ~/.config/nvim/.vim/snippets.vim
source ~/.config/nvim/.vim/maps.vim

set path+=**
set number
set relativenumber

" code folding settings
set noexpandtab             " insert tabs rather than spaces for <Tab>
set foldmethod=syntax       " fold based on indent
set foldnestmax=10          " deepest fold is 10 levels
set nofoldenable            " don't fold by default
set foldlevel=1

set pastetoggle=<F10>

