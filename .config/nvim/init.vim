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
set directory=$XDG_DATA_HOME/nvim/swap
set undodir=$XDG_DATA_HOME/nvim/undo
set backupdir=$XDG_DATA_HOME/nvim/backup
set viewdir=$XDG_DATA_HOME/nvim/view
set viminfo+='1000,n$XDG_DATA_HOME/nvim/viminfo


