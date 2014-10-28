" don't bother with vi compatibility
set nocompatible

" enable syntax highlighting
syntax enable

" install Vundle bundles
if filereadable( expand('~/.vimrc.bundles') )
    source ~/.vimrc.bundles
endif

" ensure ftdetect et al work by including this after the Vundle stuff this is
filetype plugin indent on

set autoindent
set autoread                                                " reload files when changed on disk, i.e. via `git checkout`
set backspace=2                                             " Fix broken backspace in some setups
set backupcopy=yes                                          " enable backup (see :help crontab)
set backupdir=~/tmp//,~//                                   " set backup directory
set clipboard=unnamed                                       " yank and paste with the system clipboard
set colorcolumn=""
set encoding=utf-8
set expandtab                                               " expand tabs to spaces
set hlsearch                                                " highlight search results
set ignorecase                                              " case-insensitive search
set incsearch                                               " search as you type
set laststatus=2                                            " always show statusline
set list                                                    " show trailing whitespace
set listchars=tab:▸\ ,trail:▫
set noswapfile
set number                                                  " show line numbers
set ruler                                                   " show where you are
set scrolloff=3                                             " show context above/below cursorline
set shiftwidth=4                                            " normal mode indentation commands use 4 spaces
set showcmd
set smartcase                                               " case-sensitive search if any caps
set softtabstop=4                                           " insert mode tab and backspace use 4 spaces
set tabstop=4                                               " actual tabs occupy 4 characters
set wildignore=log/**,node_modules/**,target/**,tmp/**,rbc,*.pyc,*.sql
set wildmenu                                                " show a navigable menu for tab completion
set wildmode=longest,list,full

" add smart line wraps to vim
" remove once mvim catches up to 7.4.338
if has('gui_running')
    set nowrap
else
    set breakindent
endif

if has('persistent_undo')
    set undofile                                            " enable persistant undo
    set undodir=~/.vim/undo//,~/tmp//,~//
endif

" spacing for JavaScript
autocmd BufRead,BufNewFile *.js set shiftwidth=2
autocmd BufRead,BufNewFile *.js set tabstop=2
autocmd BufRead,BufNewFile *.json set shiftwidth=2
autocmd BufRead,BufNewFile *.json set tabstop=2

" spacing for yaml
autocmd BufRead,BufNewFile *.yml set shiftwidth=2
autocmd BufRead,BufNewFile *.yml set tabstop=2

" Enable basic mouse behavior such as resizing buffers.
set mouse=a
if exists('$TMUX')                                          " Support resizing in tmux
    set ttymouse=xterm2
endif

" in case you forgot to sudo
cnoremap w!! %!sudo tee > /dev/null %

" plugin settings
let g:ctrlp_match_window='order:ttb,max:20'
let g:NERDSpaceDelims=1
let g:NERDTreeShowHidden=1
let NERDTreeIgnore=['^\.DS_Store$', '^\.git$']
let g:gitgutter_enabled=0
" let g:syntastic_php_phpcs_args='--report=csv --standard=WordPress'

" Use The Silver Searcher https://github.com/ggreer/the_silver_searcher
if executable('ag')
    set grepprg=ag\ --nogroup\ --nocolor                    " Use Ag for Grep
    let g:ctrlp_user_command='ag %s -l --nocolor -g ""'     " Use Ag for CtrlP
endif

" fdoc is yaml
autocmd BufRead,BufNewFile *.fdoc set filetype=yaml
" md is markdown
autocmd BufRead,BufNewFile *.md set filetype=markdown
autocmd BufRead,BufNewFile *.md set spell
" swig is django
autocmd BufRead,BufNewFile *.swig set filetype=htmldjango
" extra rails.vim help
autocmd User Rails silent! Rnavcommand decorator      app/decorators            -glob=**/* -suffix=_decorator.rb
autocmd User Rails silent! Rnavcommand observer       app/observers             -glob=**/* -suffix=_observer.rb
autocmd User Rails silent! Rnavcommand feature        features                  -glob=**/* -suffix=.feature
autocmd User Rails silent! Rnavcommand job            app/jobs                  -glob=**/* -suffix=_job.rb
autocmd User Rails silent! Rnavcommand mediator       app/mediators             -glob=**/* -suffix=_mediator.rb
autocmd User Rails silent! Rnavcommand stepdefinition features/step_definitions -glob=**/* -suffix=_steps.rb
" automatically rebalance windows on vim resize
autocmd VimResized * :wincmd =

" Fix Cursor in TMUX
if exists('$TMUX')
    let &t_SI="\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=1\x7\<Esc>\\"
    let &t_EI="\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=0\x7\<Esc>\\"
else
    let &t_SI="\<Esc>]50;CursorShape=1\x7"
    let &t_EI="\<Esc>]50;CursorShape=0\x7"
endif

" Don't copy the contents of an overwritten selection.
vnoremap p "_dP

" Don't highlight current line
set nocursorline

" Color Settings
if $TERM == "xterm-256color" || $TERM == "screen-256color" || has('gui_running')
    set t_Co=256
endif

if &t_Co == 256
    let base16colorspace=256
    colorscheme base16-default
    if has('gui_running')
        set guioptions=egmrt
        set guifont=Menlo:h14
        set linespace=1
        set background=light
        hi LineNr guibg=#f5f5f5     " match background of light theme
    else
        set background=dark
        hi LineNr ctermbg=00        " match background of dark theme
    endif
endif


" keyboard shortcuts
let mapleader=','
inoremap jj <ESC>
inoremap jk <ESC>

function! ColorColumnToggle()
    if &colorcolumn
        set colorcolumn=""
    else
        set colorcolumn=80,120
    endif
endfunction

noremap <leader>l :Align
nnoremap <leader>a :Ag<space>
nnoremap <leader>b :CtrlPBuffer<CR>
nnoremap <leader>d :NERDTreeToggle<CR>
nnoremap <leader>f :NERDTreeFind<CR>
nnoremap <leader>l :call ColorColumnToggle()<CR>
nnoremap <leader>o :!open %:p:h<CR><CR> " Open current directory in finder
nnoremap <leader>t :CtrlP<CR>
nnoremap <leader>T :CtrlPClearCacheѳѳ<CR>:CtrlP<CR>
nnoremap <leader>] :TagbarToggle<CR>
nnoremap <leader><space> :call whitespace#strip_trailing()<CR>
vnoremap <leader><space> :s/\s\+$//e<CR>
nnoremap <leader>g :GitGutterToggle<CR>
nnoremap <leader>u :NERDTreeClose<CR>:UndotreeToggle<CR>
nnoremap <leader>c <Plug>Kwbd
nnoremap <leader>v ^v$hy           " Copy a whole line, but not linebreaks
nnoremap <leader><leader> <c-^>    " Switch between the last two files
noremap <silent> <leader>V :source ~/.vimrc<CR>:filetype detect<CR>:exe ":echo 'vimrc reloaded'"<CR>

" quickly change windows
noremap <C-H> <C-W>h
noremap <C-J> <C-W>j
noremap <C-K> <C-W>k
noremap <C-L> <C-W>l

" select all text
noremap <C-G> ggVG

" quick macros
noremap <S-Q> @q

" better tabs
nnoremap <Tab> >>_
nnoremap <S-Tab> <<_
inoremap <S-Tab> <C-d>
vnoremap <Tab> >gv
vnoremap <S-Tab> <gv
" will insert tab at beginning of line,
" will use completion if not at beginning
" set wildmode=list:longest,list:full
" function! InsertTabWrapper()
"     let col = col('.') - 1
"     if !col || getline('.')[col - 1] !~ '\k'
"         return "\<tab>"
"     else
"         return "\<c-p>"
"     endif
" endfunction
" inoremap <Tab> <c-r>=InsertTabWrapper()<cr>
" inoremap <S-Tab> <c-n>

" move blokcs up/down
vnoremap <C-J> :m '>+1<CR>gv=gv
vnoremap <C-K> :m '<-2<CR>gv=gv

" empty search results
nnoremap <silent> <leader>/ :let @/ = ""<CR>

" echo PWD in command mode
cnoremap <C-L> <C-R>=expand("%:p:h") . "/"<CR>

" command mode movements
cnoremap <C-A> <Home>
cnoremap <C-B> <Left>
cnoremap <C-F> <Right>
cnoremap <Esc>b <S-Left>
cnoremap <Esc>f <S-Right>
cnoremap <C-K> <C-\>estrpart(getcmdline(), 0, getcmdpos()-1)<CR>

" stop accidentally running CtrlP
nnoremap <C-P> :<C-P>
nnoremap <C-N> :<C-N>

