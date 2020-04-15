" no need to support legacy vi nuances
set nocompatible

" show line numbering
set number relativenumber

" set visual cue for the max width I like my text files
" and the wrap for 'gq' command
set colorcolumn=76
set textwidth=76

" lets have syntax coloring
syntax enable

" enable better file navigation (built-in plugin)
filetype plugin on

" search down into subfolders
set path+=**

" display all matching files option
set wildmenu
