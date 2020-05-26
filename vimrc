"--------------------------------------------------------------------------
" VIM settings from these blogposts and examples
" https://dougblack.io/words/a-good-vimrc.html
" https://github.com/JJGO/dotfiles/blob/master/vim/.vimrc
" https://github.com/changemewtf/no_plugins
"--------------------------------------------------------------------------

" no need to support legacy vi nuances
set nocompatible

" enable plugins
filetype plugin on

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

" set visual cue for the max width I like my text files
" and the wrap for 'gq' command
set colorcolumn=76
set textwidth=76

" tabs are always spaces and 4 spaces per
set tabstop=4
set softtabstop=4
set expandtab

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
let mapleader = ","

" toggle between buffers
nnoremap <leader><leader> <c-^>

" plugin shortcuts
nnoremap <leader>tn :call ToggleNumber()<CR>
nnoremap <leader>nt :NERDTreeToggle<CR>
nnoremap <leader>gg :GitGutterToggle<CR>
nnoremap <leader>gd :ALEGoToDefinition<CR>
nnoremap <leader>fr :ALEFindReferences<CR>

" close NERDTree when opening a file
let g:NERDTreeQuitOnOpen = 1

" set ALE linters
let g:ale_linters = { 'python': ['pyls', 'flake8', 'mypy', 'pylint']}

" load all plugins then their helptags
packloadall
silent! helptags ALL
