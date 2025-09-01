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
Plug 'sjl/badwolf'                  " use favorite colorschemes
Plug 'nanotech/jellybeans.vim'
Plug 'NLKNguyen/papercolor-theme'
Plug 'junegunn/seoul256.vim'
Plug 'airblade/vim-gitgutter'       " show changed lines
Plug 'tpope/vim-fugitive'           " add direct git access
Plug 'vim-airline/vim-airline'      " use enhanced status line
Plug 'vim-airline/vim-airline-themes'
Plug 'scrooloose/nerdtree'          " add a file explorer
Plug 'ctrlpvim/ctrlp.vim'           " add a fuzzy file finder
Plug 'mileszs/ack.vim'              " add better grep & quickfix
Plug 'mbbill/undotree'              " see undo history & branches
Plug 'christoomey/vim-tmux-navigator' " add smart pane switching VIM & tmux
" extend VIM moves
Plug 'tpope/vim-capslock'           " add software caps lock
Plug 'tpope/vim-commentary'         " comment stuff out fast
Plug 'tpope/vim-surround'           " wrangle surrounding parens & more
Plug 'godlygeek/tabular'            " align columns of text
Plug 'genebarker/vim-tidytable'     " align markdown pipe tables fast
Plug 'vim-scripts/argtextobj.vim'   " change & delete arguments fast
Plug 'michaeljsmith/vim-indent-object' " change & delete indented text fast
Plug 'tommcdo/vim-exchange'         " swap vim selections fast
Plug 'tpope/vim-repeat'             " add repeat support to extended moves
" support writing
Plug 'preservim/vim-pencil'         " better wrapping for writing
" extend programming support
if v:version >= 800
    Plug 'dense-analysis/ale'       " add linting and LSP support
endif
Plug 'junegunn/vader.vim'           " add vimscript testing support
Plug 'vim-test/vim-test'            " add fast testing support
if has('python3')
    Plug 'madox2/vim-ai'            " add AI support
endif

call plug#end()

" don't use gitgutter's key mappings
let g:gitgutter_map_keys = 0

" show vim-pencil mode in status line
let g:airline_section_x = '%{PencilMode()}'

" turn on vim-pencil for text files
augroup pencil
    autocmd!
    autocmd FileType markdown,text call pencil#init()
augroup END

" enable markdown folding and default to all open
let g:markdown_folding = 1
autocmd FileType markdown,text setlocal foldlevel=99

" configure ALE plugin
let g:ale_linters = { 'python' : ['pylsp'] }
let g:ale_fixers = { 'python': ['black'] }
let g:ale_fix_on_save = 1
let g:ale_completion_enabled = 1

" use nice split window when running tests
let test#strategy = "vimterminal"

" configure vim-ai plugin to:
" - not delete the chat buffer (let me manage it)
" - break lines automatically
" - use markdown
" - use my fav text width
let g:vim_ai_chat = {
\   'ui' : {
\       'paste_mode': 0,
\       'scratch_buffer_keep_open' : 1,
\   },
\}
let g:vim_ai_chat_markdown = 1
autocmd FileType aichat setlocal textwidth=76

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

" turn on hard wrapping for text files
autocmd FileType text,markdown,mkd setlocal textwidth=76

" function to toggle text width to enable / disable hard wrapping
function! ToggleHardWrap()
    if(&l:textwidth == 0)
        setlocal textwidth=76
        echom "setlocal textwidth=76 (hard wrap ON)"
    else
        setlocal textwidth=0
        echom "setlocal textwidth=0 (hard wrap OFF)"
    endif
endfunc

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

" select favorite colorschemes
" (and their customizations)
let g:my_themes = ['badwolf', 'jellybeans', 'PaperColor', 'seoul256']
let g:current_theme_index = 0
let g:seoul256_background = 234

" apply customization on scheme change
function! CustomizeScheme()
    if g:colors_name ==# 'badwolf'
        hi! link SpellBad ErrorMsg
        hi! link SpellRare WarningMsg
        hi! link SpellLocal SignColumn
    endif
endfunction
autocmd ColorScheme * call CustomizeScheme()

" make sure syntax highlighting reset
" on scheme change
function! DeepChangeScheme(scheme)
    hi clear
    syntax reset
    execute 'colorscheme ' . a:scheme
endfunction

" set initial colorscheme
if $TERM ==# 'xterm-256color' || $TERM ==# 'tmux-256color' || $TERM ==# 'alacritty'
    if $TERM_PROGRAM !=# 'Apple_Terminal'
        set termguicolors
    endif
    set background=dark
    colorscheme badwolf
else
    " for limited terminals
    colorscheme desert
endif

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
let mapleader = "-"

" clear current search highlighting
nnoremap <CR> :noh<CR>

" buffer shortcuts
nnoremap <Tab> :bn<CR>
nnoremap <S-Tab> :bp<CR>
nnoremap <leader>b :ls<CR>:b<Space>
" keep only the current buffer open
command! BOnly execute '%bd|e#|bd#'

" reload VIM config
nnoremap <leader>rc :source $MYVIMRC<CR>

" plugin shortcuts
nnoremap <leader>ac :AIChat<CR>
nnoremap <leader>at :TidyMarkdownTable<CR>
nnoremap <leader>th :call ToggleHardWrap()<CR>
nnoremap <leader>tp :TogglePencil<CR>
nnoremap <leader>ts :setlocal spell!<CR>
nnoremap <leader>ut :UndotreeToggle<CR>
nnoremap <leader>nt :NERDTreeToggle<CR>
nnoremap <leader>tw :set list!<CR>

" programming shortcuts
nnoremap gd :ALEGoToDefinition<CR>
nnoremap gR :ALERename<CR>
nnoremap <leader>ne :ALENextWrap<CR>
nnoremap <leader>fr :ALEFindReferences<CR>
nnoremap <leader>tt :w \| :TestFile<CR>
nnoremap <leader>ta :w \| :TestSuite<CR>

" look & feel shortcuts
function! GotoNextColorscheme()
  let g:current_theme_index = (g:current_theme_index + 1) % len(g:my_themes)
  let l:theme = g:my_themes[g:current_theme_index]
  call DeepChangeScheme(l:theme)
  redraw | echo ":colorscheme " . g:colors_name
endfunction
command! NextColorscheme call GotoNextColorscheme()
nnoremap <Leader>nc :NextColorscheme<CR>

function! ToggleBackground()
  if &background ==# 'dark'
    set background=light
  else
    set background=dark
  endif
endfunction
nnoremap <Leader>tb :call ToggleBackground()<CR>

" Zettelkasten shortcuts
function! JournalJumpToVerse(ref)
    let l:matches = matchlist(a:ref, '\v([A-Z][a-z]{2}) (\d+):(\d+)')
    if len(l:matches) < 4
        echo "Failed to parse reference: " . a:ref
        return
    endif

    let l:book = l:matches[1]
    let l:chapter = l:matches[2]
    let l:verse = l:matches[3]

    let l:book_lc = tolower(l:book)
    let l:path = 'bible/kjv/' . l:book_lc . '/' . l:chapter . '.md'

    if filereadable(l:path)
        execute 'edit ' . fnameescape(l:path)
        silent! execute '/' . '^\s*' . l:verse . '\.'
        normal! zz
    else
        echo "File not found: " . l:path
    endif
endfunction

function! JournalSmartGotoFile()
    let l:line = getline('.')
    let l:col = col('.') - 1

    " slice the line from cursor to end
    let l:tail = strpart(l:line, l:col)

    " look for valid Bible reference at start of tail
    let l:ref = matchstr(l:tail, '\v^([A-Z][a-z]{2}) (\d+):(\d+)')

    if !empty(l:ref)
        call JournalJumpToVerse(l:ref)
        return
    endif

    " fallback
    execute 'normal! gf'
endfunction

function! JournalJumpNextReference(reverse)
    let l:pattern = '\v((\d?[A-Z][a-zA-Z]{1,2}) \d+:\d+)|(\[\[[^]]+\]\])'
    let l:flags = a:reverse ? 'bWn' : 'Wn'

    " if currently inside a wiki link, skip it when going backwards
    let l:line = getline('.')
    let l:col = col('.')
    if l:line =~ '\[\[[^]]\+\]\]' && l:col > match(l:line, '\[\[') && l:col <= matchend(l:line, '\]\]')
        if a:reverse
            let l:flags = 'bWn'
        endif
    endif

    let [lnum, cnum] = searchpos(l:pattern, l:flags)
    if lnum == 0
        echo "No Bible or wiki link reference found."
        return
    endif

    call cursor(lnum, cnum)
endfunction

nnoremap gf :call JournalSmartGotoFile()<CR>
nnoremap ]r :call JournalJumpNextReference(0)<CR>
nnoremap [r :call JournalJumpNextReference(1)<CR>

" close NERDTree when opening a file
let g:NERDTreeQuitOnOpen = 1

" load all plugins then their helptags
if has('packloadall')
    packloadall
endif
silent! helptags ALL
