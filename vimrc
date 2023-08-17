"--------------------------------------------------------------------------
" VIM settings from these blogposts and examples
" https://dougblack.io/words/a-good-vimrc.html
" https://github.com/JJGO/dotfiles/blob/master/vim/.vimrc
" https://github.com/changemewtf/no_plugins
" https://thoughtbot.com/blog/opt-in-project-specific-vim-spell-checking-and-word-completion
"--------------------------------------------------------------------------

" no need to support legacy vi nuances
set nocompatible

" install vim-plug if not found
if empty(glob('~/.vim/autoload/plug.vim'))
    silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
      \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
endif

" run PlugInstall if there are missing plugins
autocmd VimEnter * if len(filter(values(g:plugs), '!isdirectory(v:val.dir)'))
  \| PlugInstall --sync | source ~/.vimrc
\| endif

" load plugins using vim-plug
call plug#begin('~/.vim/plugged')

" enhance GUI
Plug 'tpope/vim-sensible'           " initialize VIM with better defaults
Plug 'joshdick/onedark.vim'         " use onedark theme
Plug 'airblade/vim-gitgutter'       " show changed lines
Plug 'vim-airline/vim-airline'      " use enhanced status line
Plug 'scrooloose/nerdtree'          " add a file explorer
Plug 'ctrlpvim/ctrlp.vim'           " add a fuzzy file finder
" extend VIM moves
Plug 'tpope/vim-capslock'           " add software caps lock
Plug 'tpope/vim-commentary'         " comment stuff out fast
Plug 'tpope/vim-surround'           " wrangle surrounding parens & more
Plug 'vim-scripts/argtextobj.vim'   " change & delete arguments fast
Plug 'tommcdo/vim-exchange'         " swap vim selections fast
Plug 'junegunn/vim-easy-align'      " helper to vertically align text
" support writing
Plug 'junegunn/goyo.vim'            " add distraction-free writing mode
Plug 'junegunn/limelight.vim'       " highlight focus area
Plug 'preservim/vim-pencil'         " better wrapping for writing
" extend language support
if v:version >= 800
    Plug 'dense-analysis/ale'       " linting and LSP support
endif
Plug 'aliou/bats.vim'               " grok BATS test files

call plug#end()

" reserve ctrl-a for tmux
map <C-a> <Nop>

" don't use plugin's key mappings
let g:gitgutter_map_keys = 0

" use goyo & limelight together
autocmd! User GoyoEnter Limelight
autocmd! User GoyoLeave Limelight!

" show vim-pencil mode in status line
let g:airline_section_x = '%{PencilMode()}'

" turn on vim-pencil for text files
augroup pencil
    autocmd!
    autocmd FileType markdown,mkd call pencil#init()
    autocmd FileType text         call pencil#init()
augroup END

" configure ALE plugin
let g:ale_linters = { 'python' : ['pylsp'] }
let g:ale_fixers = { 'python': ['black'] }
let g:ale_fix_on_save = 1
let g:ale_completion_enabled = 1

" no swap files, use undo files instead
set noswapfile
set undodir=~/.vim/undodir
if !isdirectory(&undodir)
    call mkdir(&undodir, "p")
endif
set undofile

" use system clipboard for copy & paste
set clipboard=unnamed

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
set listchars=tab:>-,trail:~,eol:$

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

" use one space between sentences
set nojoinspaces

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
syntax enable

" with a great color scheme
let g:limelight_conceal_ctermfg = 'DarkGray' " needed to support this scheme
colorscheme onedark

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

" enable searching as you type and highlight the matches
set incsearch
set hlsearch

" allow buffer to be hidden
set hidden

" search down into subfolders
set path+=**

" include markdown files in file search
set suffixesadd=.md

" display all matching files option
set wildmenu

" setup leader shortcuts
let mapleader = " "

" clear current search highlighting
nnoremap <CR> :noh<CR>

" buffer shortcuts
nnoremap <Tab> :bn<CR>
nnoremap <S-Tab> :bp<CR>
nnoremap <leader>b :ls<CR>:b<Space>

" window shortcuts
nnoremap <leader>h :wincmd h<CR>
nnoremap <leader>j :wincmd j<CR>
nnoremap <leader>k :wincmd k<CR>
nnoremap <leader>l :wincmd l<CR>

" reload VIM config
nnoremap <leader>rc :source $MYVIMRC<CR>

" plugin shortcuts
nnoremap <leader>tn :call ToggleNumber()<CR>
nnoremap <leader>tp :TogglePencil<CR>
nnoremap <leader>ts :setlocal spell!<CR>
nnoremap <leader>nt :NERDTreeToggle<CR>
nnoremap <leader>gg :GitGutterToggle<CR>
nnoremap <leader>tw :set list!<CR>

function! AlignMarkdownTable()
    normal! {jj
    silent! s/\s\{2,}/ /g
    silent! s/\-\{2,}/-/g
    execute "normal vip:EasyAlign *|\<CR>"
    normal! {jj
    silent! s/\s/-/g
    silent! s/\-|\-/ | /g
    normal! $
endfunc
nnoremap <leader>at :call AlignMarkdownTable()<CR>

" notes shortcuts
function! NewNote()
    let l:z_timestamp = strftime("%Y-%m-%d-%H%M")
    execute "e " . l:z_timestamp . '.md'
    call append(0, l:z_timestamp . ' ')
    normal! k$
    startinsert!
endfunc
function! NextNoteReference()
    call search('\[\[\w', 'e')
endfunc

nnoremap <leader>sc :! ~/zbox/zzcards.sh<CR>
nnoremap <leader>st :! ~/zbox/zztags.sh<CR>
nnoremap <leader>sT :! ~/zbox/zztopics.sh<CR>
nnoremap <leader>nn :call NewNote()<CR>
nnoremap <leader>nr :call NextNoteReference()<CR>

" testing shortcuts
function! TestThisFile()
    if(&filetype ==# 'python')
        write
        !pytest %
    elseif(&filetype ==# 'bats')
        write
        !%
    endif
endfunc

nnoremap <leader>pt :!pytest %<CR>
nnoremap <leader>pT :!pytest<CR>
nnoremap <leader>tt :call TestThisFile()<CR>

" close NERDTree when opening a file
let g:NERDTreeQuitOnOpen = 1

" load all plugins then their helptags
if has('packloadall')
    packloadall
endif
silent! helptags ALL
