set t_Co=256
set hlsearch
set background=dark
set shiftwidth=2
set smartindent
set expandtab
set hlsearch
set ignorecase
set statusline=%f\ %y\ format:\ %{&ff};\ C%c\ L%l/%L\ %m
set noswapfile  " Swap files are super annoying in general; just forget them.
set laststatus=2
set autoread
set mousemodel=popup  " Right-click to copy/paste/etc.
set guioptions-=T     " Don't show the menubar in gvim.
set backspace=indent,eol,start  " Needed on Windows to support bksp everywhere.
set wildmenu  " Display possible choices when opening files e.g. :e .v*<TAB>.

if has("win32")
  set guifont="Consolas:h8:cANSI"
end

syntax enable
colorscheme desert

" The default red color for the 80-char column is obnoxius.
set colorcolumn=81
highlight ColorColumn ctermbg=8
highlight ColorColumn guibg='#444444'

let mapleader = ","

" ----------------------------- vim-plug ---------------------------------------
" When setting up a new computer, run ":PlugInstall" in Vim to set up. Run
" ":PlugUpdate" periodically to update all plugins.

" Specify a directory for plugins (for Neovim: ~/.local/share/nvim/plugged)
call plug#begin('~/.vim/plugged')

" Easy align makes column-alignment faster and simpler.
Plug 'junegunn/vim-easy-align'

" See github activity on a project in vim.
Plug 'junegunn/vim-github-dashboard'

" Add NERDTree, and also add git integration to show flags.
Plug 'scrooloose/nerdtree', { 'on': 'NERDTreeToggle' }
Plug 'Xuyuanp/nerdtree-git-plugin'

"Add NERDCommenter
Plug 'scrooloose/nerdcommenter'

" Indicate changes on the sidebar.
Plug 'mhinz/vim-signify'
"let g:signify_vcs_list

" TODO: Set You Complete Me up someday; could be nice.
"Plug 'rdnetto/YCM-Generator', { 'branch': 'stable' }

" Plugin outside ~/.vim/plugged with post-update hook
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
"let g:fzf_launcher = 'urxvt -geometry 120x30 -e sh -c %s'
let g:fzf_launcher = 'xterm -bg black -geometry 120x30 -e sh -c %s'
noremap <leader>s :FZF<CR>

" Git integration.
Plug 'tpope/vim-fugitive'
" After running a grep command (like :Ggrep), pop the quick fix window open.
autocmd QuickFixCmdPost *grep* cwindow
noremap <leader>c :Gstatus<CR>

" Better status line.
" Also check out: https://github.com/powerline/powerline
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

" Syntax highlighting for the GN build system.
Plug 'https://gn.googlesource.com/gn', { 'rtp': 'tools/gn/misc/vim' }

" Initialize plugin system
call plug#end()
" ----------------------------- vim-plug end -----------------------------------

" Make C-s work like escape, and also save. Much easier to type on keyboards
" that have awkward escape keys.
imap <C-s> <ESC>:wa<CR>
nmap <C-s> :wa<CR>

" Move up and down by visual line - so even wrapped lines move up and down one
" line rather than jumping down.
nnoremap j gj
nnoremap k gk
