" Use Vim settings, rather then Vi settings
" (much better!). This must be first, because
" it changes other options as a side effect.
set nocompatible

if !has('gui')                                  " Make arrow and other keys work
    set term=$TERM
endif
filetype plugin indent on                       " Automatically detect file types.
syntax on                                       " Syntax highlighting
set history=1000                                " Store lots of :cmdline history (default is 20)
set showcmd                                     " Show incomplete cmds down the bottom
set showmode                                    " Show current mode down the bottom
set gcr=a:blinkon0                              " Disable cursor blink
set visualbell                                  " No sounds
set autoread                                    " Reload files changed outside vim
set mouse=a                                     " Automatically enable mouse usage
set mousehide                                   " Hide the mouse cursor while typing

scriptencoding utf-8

" This makes vim act like all other editors,
" buffers can exist in the background without
" being in a window.
" http://items.sjbach.com/319/configuring-vim-right
set hidden

"set autowrite                                   " Automatically write a file when leaving a modified buffer
set shortmess+=filmnrxoOtT                      " Abbrev. of messages (avoids 'hit enter')
set viewoptions=folds,options,cursor,unix,slash " Better Unix / Windows compatibility
"set virtualedit=onemore                         " Allow for cursor beyond last character
set virtualedit+=block                          " allow the cursor to go anywhere in visual block mode.
set spell                                       " Spell checking on

" <leader> is a key that allows you to have
" your own "namespace" of keybindings.
let mapleader = ','

" Instead of reverting the cursor to the last
" position in the buffer, we set it to the first
" line when editing a git commit message
au FileType gitcommit au! BufEnter COMMIT_EDITMSG call setpos('.', [0, 1, 1, 0])

" Persist undo history across sessions, by
" storing in file.
silent !mkdir ~/.vim/backups > /dev/null 2>&1
set undodir=~/.vim/backups
set undofile

" We have VCS -- we don't need this stuff.
set nobackup                                    " We have vcs, we don't need backups.
set nowritebackup                               " We have vcs, we don't need backups.
set noswapfile                                  " They're just annoying. Who likes them?

" Better search
set ignorecase                                  " case insensitive search
set smartcase                                   " If there are uppercase letters, become case-sensitive.
set incsearch                                   " live incremental searching
set showmatch                                   " live match highlighting
set hlsearch                                    " highlight matches
set gdefault                                    " use the `g` flag by default.

" Indentation
set tabstop=4
set tabpagemax=15                               " Only show 15 tabs
set showmode                                    " Display tset tabstop=4
set shiftwidth=4
set softtabstop=4
set expandtab                                   " use spaces instead of tabs.
set smarttab                                    " let's tab key insert 'tab stops', and bksp deletes tabs.
set shiftround                                  " tab / shifting moves to closest tabstop.
set autoindent                                  " Match indents on new lines.
set smartindent                                 " Intellegently dedent / indent new lines based on rules.he current mode

set cursorline                                  " Highlight current line
highlight clear SignColumn                      " SignColumn should match background for things like vim-gitgutter
highlight clear LineNr                          " Current line number row will have same background color in relative mode.

set nowrap                                      " Don't wrap lines
set linebreak                                   " Wrap lines at convenient points
set backspace=indent,eol,start                  " Backspace for dummies
set linespace=0                                 " No extra spaces between rows
set nu                                          " Line numbers on
set showmatch                                   " Show matching brackets/parenthesis
set winminheight=0                              " Windows can be 0 line high
set whichwrap=b,s,h,l,<,>,[,]                   " Backspace and cursor keys wrap too

set list
" set listchars=tab:›\ ,trail:•,extends:#,nbsp:. " Highlight problematic whitespace
set list listchars=tab:\ \ ,trail:·            " Display tabs and trailing spaces visually

" Completion
set wildmenu                                    " Show list instead of just completing
set wildmode=list:longest,full                  " Command <Tab> completion, list matches, then longest common part, then all.
set wildmode=list:longest
set wildignore=*.o,*.obj,*~                     " stuff to ignore when tab completing
set wildignore+=*vim/backups*
set wildignore+=*sass-cache*
set wildignore+=*DS_Store*
set wildignore+=vendor/rails/**
set wildignore+=vendor/cache/**
set wildignore+=*.gem
set wildignore+=log/**
set wildignore+=tmp/**
set wildignore+=*.png,*.jpg,*.gif

" Status Line
if has('statusline')
    set laststatus=2

    " Broken down into easily includeable segments
    set statusline=%<%f\                     " Filename
    set statusline+=%w%h%m%r                 " Options
    set statusline+=%{fugitive#statusline()} " Git Hotness
    set statusline+=\ [%{&ff}/%Y]            " Filetype
    set statusline+=\ [%{getcwd()}]          " Current dir
    set statusline+=%=%-14.(%l,%c%V%)\ %p%%  " Right aligned file nav info
endif

" Folds
set foldmethod=indent                       " fold based on indent
set foldnestmax=3                           " deepest fold is 3 levels
set nofoldenable                            " dont fold by default

" Scrolling
set scrolloff=8                             "Start scrolling when we're 8 lines away from margins
set sidescrolloff=15
set sidescroll=1
set scrolljump=5                            " Lines to scroll when cursor leaves screen

" Custom Settings
so ~/.vim/settings.vim

" Vundle
" This loads all the plugins specified in ~/.vim/vundles.vim
" Use Vundle plugin to manage all other plugins

if filereadable(expand("~/.vim/vundles.vim"))
  source ~/.vim/vundles.vim
endif

" Shortcuts
nnoremap <silent> <Leader>+ :exe "resize " . (winheight(0) * 3/2)<CR>
nnoremap <silent> <Leader>- :exe "resize " . (winheight(0) * 2/3)<CR>
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

" Remove trailing whitspaces on buffer write
autocmd BufWritePre *.py :%s/\s\+$//e

"set background=dark                             " Assume a dark background
colorscheme molokai
