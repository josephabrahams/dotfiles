" --------------------------------------------------------
" General Settings
" --------------------------------------------------------

set nocompatible
set encoding=utf-8
set number                      " Show line numbers
set backspace=indent,eol,start  " Allow backspace in insert mode
set history=1000                " Store lots of :cmdline history
set showcmd                     " Show incomplete cmds down the bottom
set showmode                    " Show current mode down the bottom
set visualbell                  " No sounds
set autoread                    " Reload files when changed outside vim

" Make Vim act like an IDE - http://joseph.is/1ttteph
set hidden

" Enable syntax highlighting
syntax on

" Change leader to a comma
let mapleader=','

" Load Vundle plugins
if filereadable( expand('~/.vimrc.bundles') )
    source ~/.vimrc.bundles
endif


" --------------------------------------------------------
" Ag
" --------------------------------------------------------

nnoremap <leader>a :Ag ""<Left>


" --------------------------------------------------------
" Appearance
" --------------------------------------------------------

set laststatus=2                " Always show statusbar
set nocursorline                " Don't highlight current line
set ruler                       " Show where you are

" automatically rebalance windows on vim resize
autocmd VimResized * :wincmd=

" Set 256 color space
if matchstr($TERM,256) || has('gui_running')
    set t_Co=256
endif

" Enable Base16 color scheme
if &t_Co == 256
    let base16colorspace=256
    colorscheme base16-default
    if has('gui_running')
        set guioptions-=rLT     " Disable MacVim scrollbars and toolbar
        set guifont=Menlo:h14
        set linespace=1
        set background=light
        hi LineNr guibg=#f5f5f5 " Match background of light theme
    else
        set background=dark
        hi LineNr ctermbg=00    " Match background of dark theme
    endif
endif


" --------------------------------------------------------
" Command Mode
" --------------------------------------------------------

" Emacs movements
cnoremap <C-A> <Home>
cnoremap <C-B> <Left>
cnoremap <C-F> <Right>
cnoremap <Esc>b <S-Left>
cnoremap <Esc>f <S-Right>
cnoremap <C-K> <C-\>estrpart(getcmdline(), 0, getcmdpos()-1)<CR>

" echo PWD in command mode
cnoremap <C-L> <C-R>=expand("%:p:h") . "/"<CR>


" --------------------------------------------------------
" Completion
" --------------------------------------------------------

set wildmode=list:longest
set wildmenu                    " Enable ctrl-n and ctrl-p to scroll thru matches
set wildignore=*.o,*.obj,*~     " Stuff to ignore when tab completing
set wildignore+=*vim/undo*
set wildignore+=*sass-cache*
set wildignore+=*DS_Store*
set wildignore+=vendor/**
set wildignore+=*.gem
set wildignore+=*.pyc
set wildignore+=*.sql
set wildignore+=log/**
set wildignore+=node_modules/**
set wildignore+=tmp/**
set wildignore+=*.png,*.jpeg,*.jpg,*.gif


" ---------------------------------------------------------
" CtrlP
" ---------------------------------------------------------

if exists("g:ctrlp_user_command")
    unlet g:ctrlp_user_command
endif
if executable('ag')
    " Use Ag in CtrlP for listing files.
    " Lightning fast and respects .gitignore
    let g:ctrlp_user_command =
        \ 'ag %s --files-with-matches -g "" --ignore "\.git$\|\.hg$\|\.svn$"'

    " Ag is fast enough that CtrlP doesn't need to cache
    let g:ctrlp_use_caching = 0
else
    " Fall back to using git ls-files if Ag is not available
    let g:ctrlp_custom_ignore = '\.git$\|\.hg$\|\.svn$'
    let g:ctrlp_user_command =
    \ ['.git', 'cd %s && git ls-files . --cached --exclude-standard --others']
endif

let g:ctrlp_match_window='order:ttb,max:20'

" Don't use Ctrl-p as the mapping
let g:ctrlp_map = '<leader>t'
nnoremap <silent> <leader>t :CtrlP<CR>

" Additional mapping for buffer search
nnoremap <leader>b :CtrlPBuffer<CR>

" Clear the cache before search
nnoremap <leader>T :CtrlPClearCache<CR>:CtrlP<CR>

"Cmd-Shift-(M)ethod - jump to a method (tag in current file)
"Ctrl-m is not good - it overrides behavior of Enter
nnoremap <silent> <D-M> :CtrlPBufTag<CR>


" --------------------------------------------------------
" Cut/Paste
" --------------------------------------------------------

" Yank and paste with the system clipboard
set clipboard=unnamed

" Don't copy the contents of an overwritten selection.
vnoremap p "_dP

" Copy a whole line, but not linebreaks
nnoremap <leader>y ^v$hy

" Select all text
noremap <C-G> ggVG


" --------------------------------------------------------
" Folds
" --------------------------------------------------------

set foldmethod=indent           " Fold based on indent
set foldnestmax=3               " Deepest fold is 3 levels
set nofoldenable                " Dont fold by default


" ---------------------------------------------------------
" Goto File
" ---------------------------------------------------------

" Automatically jump to a file at /some/path.rb:50
nnoremap <silent> <leader>gf :vertical botright wincmd F<CR>


" --------------------------------------------------------
" Grep
" --------------------------------------------------------

if executable('ag')
    " Use Ag for lightning fast search
    set grepprg=ag\ --nogroup\ --nocolor
else
    " Fall back to using git ls-files if Ag is not available
    set grepprg=git\ grep
endif
let g:grep_cmd_opts = '--line-number'


" --------------------------------------------------------
" Line Length
" --------------------------------------------------------

" don't show line length bar on start
set colorcolumn=

" toggle line length with <leader>l
function! ColorColumnToggle()
    if &colorcolumn
        set colorcolumn=
    else
        set colorcolumn=80,120
    endif
endfunction
nnoremap <leader>l :call ColorColumnToggle()<CR>


" --------------------------------------------------------
" GitGutter
" --------------------------------------------------------

" Enable GitGutter on start
let g:gitgutter_enabled=1

" Toggle with `,g`
nnoremap <leader>g :GitGutterToggle<CR>


" --------------------------------------------------------
" Helpers
" --------------------------------------------------------

" In case you forgot to sudo
cnoremap w!! %!sudo tee > /dev/null %

" Delete buffer while keeping window layout
nnoremap <leader>c :Kwbd<CR>

" Open current directory in finder
nnoremap <leader>o :!open %:p:h<CR><CR>

" Switch between the last two files
nnoremap <leader><leader> <c-^>

" Quick macros
noremap <S-Q> @q

" Reload .vimrc
noremap <silent> <leader>V :source ~/.vimrc<CR>:filetype detect<CR>:exe ":echo 'vimrc reloaded'"<CR>


" --------------------------------------------------------
" Indentation
" --------------------------------------------------------

set autoindent
set smartindent
set smarttab
set shiftwidth=4                " Normal mode indentation commands use 4 spaces
set softtabstop=4               " Insert mode tab and backspace use 4 spaces
set tabstop=4                   " Actual tabs occupy 4 characters
set expandtab                   " Expand tabs to spaces

filetype plugin on
filetype indent on

set list
set listchars=tab:▸\ ,trail:▫   " Show trailing whitespace

" TODO: remove once mvim catches up to 7.4.338
if has('gui_running')
    set nowrap
else
    set breakindent             " Smart line wraps
endif

nnoremap <Tab> >>_
nnoremap <S-Tab> <<_
inoremap <S-Tab> <C-d>
vnoremap <Tab> >gv
vnoremap <S-Tab> <gv

" Align selection on character, i.e. `=` or `:`)
noremap <leader>; :Align

" TODO: set tabs based on filetype detection
function! Tab2()
    set shiftwidth=2
    set softtabstop=2
    set tabstop=2
endfunction
function! Tab4()
    set shiftwidth=4
    set softtabstop=4
    set tabstop=4
endfunction
command! Tab2 :call Tab2()
command! Tab4 :call Tab4()

" ---------------------------------------------------------
" JavaScript
" ---------------------------------------------------------

" Use jQuery syntax highlighting
autocmd BufRead,BufNewFile *.js set ft=javascript syntax=jquery
" Uses 2 spaces for tabs in js and json files
autocmd BufRead,BufNewFile *.js,*.json set shiftwidth=2 tabstop=2 softtabstop=2
" Swig uses Django syntax
autocmd BufRead,BufNewFile *.swig set filetype=htmldjango


" --------------------------------------------------------
" Markdown
" --------------------------------------------------------

" Use GitHub Markdown (jtratner/vim-flavored-markdown)
augroup markdown
    au!
    au BufNewFile,BufRead *.md,*.markdown setlocal filetype=ghmarkdown spell
augroup END

" Open current file with Marked 2
nnoremap <leader>M :!marked %:p<CR><CR>


" ---------------------------------------------------------
" Motion / moving text
" ---------------------------------------------------------

" CamelCase Motion
map w <Plug>CamelCaseMotion_w
map b <Plug>CamelCaseMotion_b
map e <Plug>CamelCaseMotion_e
omap iw <Plug>CamelCaseMotion_iw
xmap iw <Plug>CamelCaseMotion_iw
omap ib <Plug>CamelCaseMotion_ib
xmap ib <Plug>CamelCaseMotion_ib
omap ie <Plug>CamelCaseMotion_ie
xmap ie <Plug>CamelCaseMotion_ie

" Move text blokcs up/down
vnoremap <C-J> :m '>+1<CR>gv=gv
vnoremap <C-K> :m '<-2<CR>gv=gv

" Exit insert mode when trying to move up/down
inoremap jj <ESC>
inoremap kk <ESC>


" --------------------------------------------------------
" NERD tree
" --------------------------------------------------------

let NERDTreeDirArrows = 1
let NERDTreeMinimalUI = 1
let g:NERDSpaceDelims=1
let g:NERDTreeShowHidden=2
let g:NERDTreeIgnore=['^\.DS_Store$', '^\.git$']
let g:NERDTreeWinSize = 30

nnoremap <leader>d :NERDTreeToggle<CR>
nnoremap <leader>f :NERDTreeFind<CR>


" --------------------------------------------------------
" Ruby
" --------------------------------------------------------

" spacing for yaml
autocmd BufRead,BufNewFile *.fdoc,*.sls,*.yml set shiftwidth=2 tabstop=2 softtabstop=2
" fdocs and salt states are yaml
autocmd BufRead,BufNewFile *.fdoc,*.sls set filetype=yaml


" --------------------------------------------------------
" Scrolling
" --------------------------------------------------------

set scrolloff=8                 " Scroll 8 lines away from top/bottom
set sidescrolloff=15            " Scroll 15 chards from side
set sidescroll=1                " Keep the cursor on the screen


" --------------------------------------------------------
" Search
" --------------------------------------------------------

set incsearch                   " Find the next match as we type the search
set hlsearch                    " Highlight search results
set viminfo='100,f1             " Save up to 100 marks, enable capital marks
set ignorecase                  " Ignore case when searching...
set smartcase                   " ...unless we type a capital

" clear search results
nnoremap <silent> <leader>/ :let @/ = ""<CR>


" --------------------------------------------------------
" Swap, Backup, && Undo
" --------------------------------------------------------

set noswapfile
set backupcopy=yes              " Enable backup (see :help crontab)
set backupdir=~/tmp//,~//       " Set backup directory

if has('persistent_undo')
    silent !mkdir ~/.vim/undo > /dev/null 2>&1
    set undodir=~/.vim/undo//,~/tmp//,~//
    set undofile
endif


" --------------------------------------------------------
" Syntastic
" --------------------------------------------------------

let g:syntastic_check_on_open=0
let g:syntastic_python_checkers=["flake8"]


" --------------------------------------------------------
" Tagbar
" --------------------------------------------------------

" Open Tagbar
nnoremap <leader>] :TagbarToggle<CR>


" --------------------------------------------------------
" TMUX
" --------------------------------------------------------

" Support mouse resizing in TMUX
set mouse=a
if exists('$TMUX')
    set ttymouse=xterm2
endif

" Fix Cursor in TMUX
if exists('$TMUX')
    let &t_SI="\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=1\x7\<Esc>\\"
    let &t_EI="\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=0\x7\<Esc>\\"
else
    let &t_SI="\<Esc>]50;CursorShape=1\x7"
    let &t_EI="\<Esc>]50;CursorShape=0\x7"
endif


" --------------------------------------------------------
" Undotree
" --------------------------------------------------------

let g:undotree_WindowLayout=3
let g:undotree_SplitWidth=40

nnoremap <leader>u :UndotreeToggle<CR>


" --------------------------------------------------------
" Whitespace
" --------------------------------------------------------

nnoremap <leader><space> :call whitespace#strip_trailing()<CR>
vnoremap <leader><space> :s/\s\+$//e<CR>


" --------------------------------------------------------
" WordPress
" --------------------------------------------------------

function! EnableWordPress()
    let g:syntastic_php_phpcs_args='--report=csv --standard=WordPress'
    set noexpandtab
    set listchars=tab:\ \ ,trail:▫   " don't show tabs
endfunction
command! WordPress :call EnableWordPress()

