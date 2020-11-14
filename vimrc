"--------------------------------------------------------------------------
" VIM settings from these blogposts and examples
" https://dougblack.io/words/a-good-vimrc.html
" https://github.com/JJGO/dotfiles/blob/master/vim/.vimrc
" https://github.com/changemewtf/no_plugins
" https://thoughtbot.com/blog/opt-in-project-specific-vim-spell-checking-and-word-completion
"--------------------------------------------------------------------------

" no need to support legacy vi nuances
set nocompatible

" load plugins using vim-plug
call plug#begin('~/.vim/plugged')

" enhance GUI
Plug 'tpope/vim-sensible'           " initialize VIM with better defaults
Plug 'tomasr/molokai'               " use molokai colorscheme
Plug 'airblade/vim-gitgutter'       " show changed lines
Plug 'dense-analysis/ale'           " add a linting engine
Plug 'vim-airline/vim-airline'      " use enhanced status line
Plug 'scrooloose/nerdtree'          " add a file explorer
" extend VIM moves
Plug 'tpope/vim-commentary'         " comment stuff out fast
Plug 'tpope/vim-surround'           " wrangle surrounding parens & more
" extend syntax support
Plug 'aliou/bats.vim'               " BATS test files

call plug#end()

" load filetype-specific plugin files
filetype plugin on

" no swap files, use undo files instead
set noswapfile
set undodir=~/.vim/undodir
set undofile

" show line numbering
set number relativenumber

" function to toggle between regular / relative numbering
function! ToggleNumber()
    if(&relativenumber == 1)
        set norelativenumber
        set number
    else
        set relativenumber
    endif
endfunc

" show tabs and non-breakable spaces
set listchars=tab:>>,space:.,eol:$

" turn spell check on for text files and git messages
autocmd BufRead,BufNewFile *.md set filetype=markdown
autocmd BufRead,BufNewFile *.txt set filetype=text
autocmd FileType markdown setlocal spell
autocmd FileType gitcommit setlocal spell
autocmd FileType text setlocal spell

" use US english dictionary
set spelllang=en_us

" use project dictionary if available
if filereadable("spellfile.utf-8.add")
    " initialize if necessary
    if !filereadable("spellfile.utf-8.add.spl")
        mkspell spellfile.utf-8.add
    endif
    set spellfile=spellfile.utf-8.add
endif

" autocomplete with dictionary words when spell check on
set complete+=kspell

" set visual cue for the max width I like my text files
" and the wrap for 'gq' command
set colorcolumn=76
set textwidth=76

" show one line per line
set nowrap

" tabs are always spaces and 4 spaces per
set tabstop=4
set softtabstop=4
set shiftwidth=4
set expandtab

" guess indent level
set smartindent

" highlight current line
set cursorline

" always show status line at the bottom
set laststatus=2

" show command as it's keyed on status line
set showcmd

" lets have syntax coloring
" with molokai color scheme
syntax enable
colorscheme molokai
let g:molokai_original = 1

" open new split pane on right/bottom
" (feels more natural)
set splitright
set splitbelow

" make sure can backspace behaves more reasonably
" (i.e. allow before insertion point set with 'i')
set backspace=indent,eol,start

" don't enter Ex mode on 'Q'
nmap Q <Nop>

" enable mouse support
set mouse+=a

" when lowercase used do case-insensitive search
" (if it contains any capital letters, case-sensitive)
set ignorecase
set smartcase

" enable searching as you type
set incsearch

" allow buffer to be hidden
set hidden

" search down into subfolders
set path+=**

" display all matching files option
set wildmenu

" add custom commands
command! CTags !ctags -R .

" setup leader shortcuts
let mapleader = " "

" toggle between buffers
nnoremap <leader><leader> <c-^>

" window shortcuts
nnoremap <leader>h :wincmd h<CR>
nnoremap <leader>j :wincmd j<CR>
nnoremap <leader>k :wincmd k<CR>
nnoremap <leader>l :wincmd l<CR>

" plugin shortcuts
nnoremap <leader>tn :call ToggleNumber()<CR>
nnoremap <leader>ts :setlocal spell!<CR>
nnoremap <leader>nt :NERDTreeToggle<CR>
nnoremap <leader>gg :GitGutterToggle<CR>
nnoremap <leader>ta :ALEToggle<CR>
nnoremap <leader>gd :ALEGoToDefinition<CR>
nnoremap <leader>fr :ALEFindReferences<CR>
nnoremap <leader>tw :set list!<CR>

" testing shortcuts
function! TestThisFile()
    if(&filetype ==# 'python')
        !pytest %
    elseif(&filetype ==# 'bats')
        !%
    endif
endfunc

nnoremap <leader>pt :!pytest %<CR>
nnoremap <leader>pT :!pytest<CR>
nnoremap <leader>tt :call TestThisFile()<CR>

" close NERDTree when opening a file
let g:NERDTreeQuitOnOpen = 1

" set ALE linters
let g:ale_linters = { 'python': ['pyls', 'flake8', 'mypy', 'pylint']}

" load all plugins then their helptags
if has('packloadall')
    packloadall
endif
silent! helptags ALL
