" no need to support legacy vi nuances
set nocompatible

" show line numbering
set number relativenumber

" set visual cue for the max width I like my text files
" and the wrap for 'gq' command
set colorcolumn=76
set textwidth=76

" always show status line at the bottom
set laststatus=2

" show command as it's keyed on status line 
set showcmd

" automatically detect file types (built-in plugin)
filetype plugin on

" lets have syntax coloring
syntax enable

" make sure can backspace behaves more reasonably
" (i.e. allow before insertion point set with 'i')
set backspace=indent,eol,start

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
