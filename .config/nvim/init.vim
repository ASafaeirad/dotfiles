if &compatible
  set nocompatible
endif

source ~/.config/nvim/partials/plugins.vim
source ~/.config/nvim/partials/init.vim
source ~/.config/nvim/partials/abbrevations.vim
source ~/.config/nvim/partials/snippets.vim
source ~/.config/nvim/partials/maps.vim

set path+=**
set number
set relativenumber

set pastetoggle=<F10>

" code folding settings
set noexpandtab             " insert tabs rather than spaces for <Tab>
set foldmethod=syntax       " fold based on indent
set foldnestmax=10          " deepest fold is 10 levels
set nofoldenable            " don't fold by default
set foldlevel=1

" use XDG style
set directory=$XDG_CACHE_HOME/vim,~/,/tmp " swp files
set backupdir=$XDG_CACHE_HOME/vim,~/,/tmp " bak files
set viminfo+=n$XDG_CACHE_HOME/vim/viminfo
set undodir=$XDG_CACHE_HOME/vim/undo,~/,/tmp


