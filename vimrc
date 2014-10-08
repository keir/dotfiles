" Package vim plugins with plugin-per-directory.
" TODO(keir): Figure out why this is not working.
"execute pathogen#infect()

set t_Co=256
set hlsearch
set background=dark
set shiftwidth=2
set smartindent
set expandtab
set hlsearch
set ignorecase
set statusline=%f\ %y\ format:\ %{&ff};\ C%c\ L%l/%L
set noswapfile
set laststatus=2

syntax enable
colorscheme desert

" The default red color for the 80-char column is obnoxius.
set colorcolumn=81
highlight ColorColumn ctermbg=8
highlight ColorColumn guibg='#444444'
