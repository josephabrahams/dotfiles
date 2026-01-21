" vi:ft=vim

" =======================================================================
" XDG Base Directory
" ======================================================================

" Add XDG config directory to runtimepath for colors and plugins
set runtimepath^=~/.config/vim

" Use XDG state directory for viminfo
if !has('nvim')
    set viminfofile=$HOME/.local/state/vim/viminfo
endif


" ======================================================================
" General Settings
" ======================================================================

set encoding=utf-8              " Use UTF-8 encoding
set backspace=indent,eol,start  " Allow backspace in insert mode
set history=1000                " Store lots of :cmdline history
set showcmd                     " Show incomplete cmds down the bottom
set showmode                    " Show current mode down the bottom
set visualbell                  " No sounds
set autoread                    " Reload files when changed outside vim
set title                       " Show filename in terminal title
set mouse=a                     " Enable mouse support
let mapleader = ','             " Change leader to a comma


" ======================================================================
" File Handling
" ======================================================================

set noswapfile                  " Disable swap files
set backupcopy=yes              " Enable backup (see :help crontab)


" ======================================================================
" Search
" ======================================================================

set incsearch                   " Find the next match as we type the search
set hlsearch                    " Highlight search results
set ignorecase                  " Ignore case when searching...
set smartcase                   " ...unless we type a capital
set gdefault                    " Add the g flag to search/replace by default


" ======================================================================
" Scrolling
" ======================================================================

set scrolloff=7                 " Scroll 7 lines away from top/bottom
set sidescroll=1                " Keep the cursor on the screen


" ======================================================================
" Indentation
" ======================================================================

set autoindent                  " Auto-indent new lines
set smartindent                 " Smart auto-indenting
set smarttab                    " Smart tabbing
set shiftwidth=4                " Indent with 4 spaces
set softtabstop=4               " Insert mode tab and backspace use 4 spaces
set tabstop=4                   " Tab displays as 4 spaces
set expandtab                   " Use spaces instead of tabs


" ======================================================================
" Visual & UI
" ======================================================================

syntax on                       " Enable syntax highlighting
set number                      " Show line numbers
set ruler                       " Show cursor position
set laststatus=2                " Always show statusbar
set wildmenu                    " Better command-line completion


" ======================================================================
" Keybindings
" ======================================================================

" Cut/Paste
set clipboard=unnamed           " Yank and paste with the system clipboard
vnoremap p "_dP                 " Don't yank when replace-pasting

" Search
nnoremap <leader>/ :noh<CR>     " Clear search highlight

" Indentation
nnoremap <Tab> >>_
nnoremap <S-Tab> <<_
vnoremap <Tab> >gv
vnoremap <S-Tab> <gv

" Move lines up/down
nnoremap <C-k> :m .-2<CR>==
nnoremap <C-j> :m .+1<CR>==
vnoremap <C-k> :m '<-2<CR>gv=gv
vnoremap <C-j> :m '>+1<CR>gv=gv

" Save with sudo
function! SudoWrite()
    write !sudo tee > /dev/null %
    edit!
endfunction
cnoreabbrev w!! call SudoWrite()

" Reload .vimrc
noremap <silent> <leader>V :source ~/.config/vim/vimrc<CR>:filetype detect<CR>:echo 'vimrc reloaded'<CR><CR>

" Quick macro replay (also disables Ex mode)
noremap Q @q

" Strip trailing whitespace
function! StripWhitespace()
    let save_cursor = getpos(".")
    let old_query = getreg('/')
    :%s/\s\+$//e
    call setpos('.', save_cursor)
    call setreg('/', old_query)
endfunction
noremap <leader><space> :call StripWhitespace()<CR>


" ======================================================================
" Appearance
" ======================================================================

" Color scheme
colorscheme base16-default-dark

" Terminal-only color customization (applied after colorscheme loads)
if !has('gui_running')
    hi LineNr ctermbg=NONE                  " Match terminal background
    hi StatusLine ctermbg=238 ctermfg=248   " Grayscale: dark gray bar, light gray text
    hi StatusLineNC ctermbg=236 ctermfg=244 " Grayscale: darker for inactive
endif

" MacVim specific settings
if has('gui_running')
    set guioptions-=rLT         " Disable MacVim scrollbars and toolbar
    set guifont=Hack\ Nerd\ Font\ Mono:h14
    set linespace=1
endif

" Automatically rebalance windows on vim resize
autocmd VimResized * :wincmd=
