"--------------------------------------------------------------------------
" VIM settings from these blogposts and examples
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
Plug 'morhetz/gruvbox'
Plug 'airblade/vim-gitgutter'       " show changed lines
Plug 'tpope/vim-fugitive'           " add direct git access
Plug 'vim-airline/vim-airline'      " use enhanced status line
Plug 'vim-airline/vim-airline-themes'
if executable('fzf')
    Plug 'junegunn/fzf'                 " add a great fuzzy file finder
    Plug 'junegunn/fzf.vim'
    nnoremap <C-p> :Files<CR>
else
    Plug 'ctrlpvim/ctrlp.vim'           " add a solid fuzzy file finder
endif
Plug 'mileszs/ack.vim'              " add better grep & quickfix
Plug 'mbbill/undotree'              " see undo history & branches
Plug 'christoomey/vim-tmux-navigator' " add smart pane switching VIM & tmux
" extend VIM moves
Plug 'tpope/vim-capslock'           " add software caps lock
Plug 'tpope/vim-commentary'         " comment stuff out fast
Plug 'tpope/vim-surround'           " wrangle surrounding parens & more
Plug 'godlygeek/tabular'            " align columns of text (req by tidytable)
if isdirectory(expand('~/workspace/vim-tidytable'))
    " use dev version when present
    Plug '~/workspace/vim-tidytable'
else
    Plug 'genebarker/vim-tidytable' " align markdown tables fast
endif
Plug 'vim-scripts/argtextobj.vim'   " change & delete arguments fast
Plug 'michaeljsmith/vim-indent-object' " change & delete indented text fast
Plug 'tommcdo/vim-exchange'         " swap vim selections fast
Plug 'tpope/vim-repeat'             " add repeat support to extended moves
" support writing
Plug 'bullets-vim/bullets.vim'      " better bullet handling
Plug 'preservim/vim-pencil'         " better wrapping for writing
if isdirectory(expand('~/workspace/vim-journal'))
    " use dev version when present
    Plug '~/workspace/vim-journal'
else
    Plug 'genebarker/vim-journal'   " navigate markdown references fast
endif
" extend programming support
Plug 'dense-analysis/ale'           " add linting and LSP support
Plug 'junegunn/vader.vim'           " add vimscript testing support
Plug 'vim-test/vim-test'            " add fast testing support
if has('python3')
    Plug 'madox2/vim-ai'            " add AI support
endif

call plug#end()

" show vim-pencil mode in status line
let g:airline_section_x = '%{PencilMode()}'

" turn on vim-pencil for text files
augroup pencil
    autocmd!
    autocmd FileType markdown,text call pencil#init()
    " set default formatoptions
    autocmd FileType markdown,text setlocal formatoptions=jcqln1t
augroup END

" enable folding for markdown files
let g:markdown_folding = 1
autocmd FileType markdown,text setlocal foldlevel=99

" set programming pref's (that diff from defaults)
autocmd FileType java setlocal foldmethod=syntax
autocmd FileType java setlocal foldlevel=99
autocmd FileType java setlocal tabstop=2 softtabstop=2 shiftwidth=2 expandtab
autocmd FileType python setlocal foldmethod=indent
autocmd FileType python setlocal foldlevel=99

" flip-on highlight Java class-like names in vimrc
let g:java_highlight_java_lang_ids = 1
let g:java_highlight_functions = "style"
let g:java_highlight_signature = 1
let g:java_highlight_generics = 1
let g:java_space_errors = 1

" configure ALE plugin
let g:ale_linters = {
\   'python' : ['pylsp', 'pylint'],
\   'java' : ['eclipselsp', 'checkstyle'],
\}
let g:ale_fixers = {
\   'python' : ['black', 'isort'],
\   'java' : ['google_java_format'],
\}
let g:ale_lint_on_text_changed = 'always'
let g:ale_lint_on_save = 1
let g:ale_fix_on_save = 1
let g:ale_completion_enabled = 1

let g:ale_java_eclipselsp_path = expand('~/bin/jdt-language-server')
let g:ale_java_checkstyle_executable = expand('~/bin/checkstyle')
let g:ale_java_checkstyle_config = 'checkstyle.xml'
let g:ale_java_google_java_format_executable = expand('~/bin/google-java-format')

" configure Journal plugin
let g:journal_ref_key = 'a'

" use nice split window when running tests
let g:test#strategy = "vimterminal"

" force use of maven for testing java files
function! EnableOnlyMavenTest()
    if &filetype == 'java'
        let g:test#enabled_runners = ['java#maventest']
    endif
endfunction
autocmd FileType java call EnableOnlyMavenTest()

" configure vim-ai plugin to:
" - not delete the chat buffer (let me manage it)
" - break lines automatically
" - use markdown
" - use my fav text width
" - use witty personality
let s:aria_chat_prompt =<< trim END
>>> system

You are Aria, a fast, practical assistant embedded in Vim.  
You assist Gene, an experienced solutions architect known for  
building enterprise systems that last.  
Give concise answers wrapped at 76 chars for readability.  
Use markdown and code blocks with syntax highlighting (```python).  
Be practical, warm, and witty—with a spark of fire and mischief.  
When playful, favor clever wordplay or double entendres, never roleplay.  
END
let g:vim_ai_chat = {
\   'ui' : {
\       'paste_mode' : 0,
\       'scratch_buffer_keep_open' : 1,
\   },
\   'options' : {
\       'initial_prompt' : s:aria_chat_prompt,
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

" persist theme selection across sessions
let g:theme_state_file = expand('~/.vim/theme_state')

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

" set text width for auto-wrapping and manual formatting (gq)
autocmd FileType markdown,text setlocal textwidth=76

" use one space between sentences
set nojoinspaces

" show one line per line
set nowrap

" tab defaults are spaces and 4 spaces per
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
" - suffix with ! for light background mode
" - set customizations
let g:my_themes = ['badwolf', 'jellybeans', 'PaperColor', 'PaperColor!', 'gruvbox', 'gruvbox!']
let g:seoul256_background = 234

" restore theme index from previous session
if filereadable(g:theme_state_file)
    let g:current_theme_index = str2nr(readfile(g:theme_state_file)[0])
else
    let g:current_theme_index = 0
endif

" apply customization on scheme change
function! CustomizeScheme()
    if g:colors_name ==# 'badwolf'
        hi! link SpellBad ErrorMsg
        hi! link SpellLocal SignColumn
        hi! link SpellRare WarningMsg
    elseif g:colors_name ==# 'gruvbox'
        hi! link SpellBad GruvboxRed
        hi! link SpellCap GruvboxPurple
        hi! link SpellRare GruvboxBlue
        hi! link SpellLocal GruvboxAqua
    endif
endfunction
autocmd ColorScheme * call CustomizeScheme()

" make sure syntax highlighting reset
" on scheme change
function! DeepChangeScheme(scheme)
    " check for light background marker
    if a:scheme =~# '!$'
        set background=light
        let l:theme_name = substitute(a:scheme, '!$', '', '')
    else
        set background=dark
        let l:theme_name = a:scheme
    endif

    " reset to vim defaults
    hi clear
    if exists('syntax_on')
        syntax reset
    endif

    " clear any lingering colorscheme name
    if exists('g:colors_name')
        unlet g:colors_name
    endif

    execute 'colorscheme ' . l:theme_name
endfunction

" set initial colorscheme
if $TERM ==# 'xterm-256color' || $TERM ==# 'tmux-256color' || $TERM ==# 'alacritty'
    if $TERM_PROGRAM !=# 'Apple_Terminal'
        set termguicolors
    endif
    " apply saved theme if available
    if g:current_theme_index > 0
        call DeepChangeScheme(g:my_themes[g:current_theme_index])
    else
        set background=dark
        colorscheme badwolf
    endif
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
nnoremap <leader><Tab> :ls<CR>:b<Space>
" keep only the current buffer open
command! BOnly execute '%bd|e#|bd#'

" filetree toggle
nnoremap <F2> :Lexplore<CR>

" reload VIM config
nnoremap <leader>rc :source $MYVIMRC<CR>

" quickfix shortcuts
nnoremap ]q :cnext<CR>
nnoremap [q :cprev<CR>

" plugin shortcuts
nnoremap <leader>ac :AIChat<CR>
inoremap <C-g> <Esc>:AIChat<CR>
nnoremap <leader>at :TidyMarkdownTable<CR>
nnoremap <leader>tp :TogglePencil<CR>
nnoremap <leader>ts :setlocal spell!<CR>
nnoremap <leader>tw :set list!<CR>
nnoremap <leader>ut :UndotreeToggle<CR>

" quickly reformat paragraph
nnoremap Q gqap

" toggle auto-formatting on/off
" - important when being deliberate with markdown hard wraps
noremap <silent> <F7> :<C-u>PFormatToggle<cr>
inoremap <silent> <F7> <C-o>:PFormatToggle<cr>

" programming shortcuts
nnoremap <leader>8 :Ack <cword><CR>
nnoremap gd :ALEGoToDefinition<CR>
nnoremap gi :ALEHover<CR>
nnoremap gu :ALEFindReferences -quickfix\| copen<CR>
nnoremap gr :ALERename<CR>
nnoremap ]e :ALENext<CR>
nnoremap [e :ALEPrevious<CR>
nnoremap <leader>tt :w \| :TestFile<CR>
nnoremap <leader>ta :w \| :TestSuite<CR>

" look & feel shortcuts
function! GotoNextColorscheme()
  let g:current_theme_index = (g:current_theme_index + 1) % len(g:my_themes)
  call DeepChangeScheme(g:my_themes[g:current_theme_index])
  " persist theme selection
  call writefile([g:current_theme_index], g:theme_state_file)
  redraw | echo ":colorscheme " . g:colors_name
endfunction
command! NextColorscheme call GotoNextColorscheme()
nnoremap <Leader>cc :NextColorscheme<CR>

" load all plugins then their helptags
if has('packloadall')
    packloadall
endif
silent! helptags ALL
