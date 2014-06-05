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
set colorcolumn=81
set statusline=%f\ %y\ format:\ %{&ff};\ C%c\ L%l/%L
set noswapfile
set laststatus=2

syntax enable
colorscheme desert

" The default red color column is obnoxius in terminals.
highlight ColorColumn ctermbg=8
