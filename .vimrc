" no need to support legacy vi nuances
set nocompatible

" show line numbering
set number relativenumber

" set visual cue for the max width I like my text files
" and the wrap for 'gq' command
set colorcolumn=76
set textwidth=76

" automatically detect file types (built-in plugin)
filetype plugin on

" lets have syntax coloring
syntax enable

" search down into subfolders
set path+=**

" display all matching files option
set wildmenu
