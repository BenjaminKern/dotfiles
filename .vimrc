set encoding=utf-8
scriptencoding utf-8
setglobal fileencoding=utf-8

silent function! OSX()
    return has('macunix')
endfunction
silent function! LINUX()
    return has('unix') && !has('macunix') && !has('win32unix')
endfunction
silent function! WINDOWS()
    return  (has('win32') || has('win64'))
endfunction

if WINDOWS()
    set runtimepath=$HOME/.vim,$VIM/vimfiles,$VIMRUNTIME,$VIM/vimfiles/after,$HOME/.vim/after
    set renderoptions=type:directx,gamma:1.0,contrast:0.5,level:1,geom:1,renmode:4,taamode:1
    set fileformats=dos,unix
end

if OSX()
    set termguicolors
    set termencoding=utf-8
    set fillchars+=stl:\ ,stlnc:\
end

" if &compatible
"   set nocompatible
" endif

set runtimepath+=~/.vim/bundle/repos/github.com/Shougo/dein.vim

call dein#begin(expand('~/.vim/bundle'))

call dein#add('Shougo/dein.vim')
call dein#add('Shougo/vimproc.vim')
call dein#add('Shougo/vimshell.vim')
call dein#add('Shougo/vinarise.vim')
call dein#add('Shougo/neomru.vim')
call dein#add('Shougo/denite.nvim')

" call dein#add('tpope/vim-fugitive')
call dein#add('tpope/vim-commentary')
call dein#add('tpope/vim-dispatch')

call dein#add('airblade/vim-rooter')
call dein#add('airblade/vim-gitgutter')

call dein#add('jreybert/vimagit')

call dein#add('vim-airline/vim-airline')
call dein#add('vim-airline/vim-airline-themes')
call dein#add('easymotion/vim-easymotion')
call dein#add('mhinz/vim-startify')
call dein#add('w0rp/ale')

call dein#add('rhysd/vim-clang-format')

call dein#add('fatih/vim-go')

call dein#add('lifepillar/vim-solarized8')
" call dein#add('nanotech/jellybeans.vim')

" Completer 
" call dein#add('artur-shaik/vim-javacomplete2')

" need this one at some point
" call dein#add('metakirby5/codi.vim')
" call dein#add('google/vim-maktaba')
" call dein#add('google/vim-codefmt')
" call dein#add('google/vim-glaive')

" call dein#add('gregsexton/gitv')
" call dein#add('Shougo/vimfiler.vim')
" call dein#add('Shougo/unite.vim')
" call dein#add('Shougo/neocomplete.vim')
" call dein#add('Shougo/neosnippet.vim')
" call dein#add('Shougo/neoyank.vim')
" call dein#add('vim-jp/vital.vim')
" call dein#add('Shougo/neopairs.vim')
" call dein#add('Shougo/junkfile.vim')
" call dein#add('Shougo/neoinclude.vim')
" call dein#add('tsukkee/unite-tag')
" call dein#add('Shougo/unite-outline')
" call dein#add('Shougo/unite-session')
" call dein#add('vim-scripts/MatlabFilesEdition')
" call dein#add('scrooloose/syntastic')
" call dein#add('int3/vim-extradite')
" call dein#add('Yggdroot/indentLine')
" call dein#add('yjqpro/vim-clang-format')
" call dein#add('jakykong/vim-zim')
" call dein#add('joanrivera/vim-zimwiki-syntax')
call dein#end()

filetype plugin indent on

syntax enable


if WINDOWS()
endif

if has('gui_running')
    set guifont=InconsolataForPowerline_NF:h10:cANSI:qDRAFT
    set guioptions-=m  "remove menu bar
    set guioptions-=T  "remove toolbar
    set guioptions-=r  "remove right-hand scroll bar
    set guioptions-=L  "remove left-hand scroll bar
    set guicursor+=a:blinkon0 "disable cursor blinking
endif

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => General
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Sets how many lines of history VIM has to remember
set history=700

" Set to auto read when a file is changed from the outside
set autoread

let leader = ','
let mapleader = ','

set list
set listchars=tab:›\ ,trail:•,extends:#,nbsp:.

" Set 7 lines to the cursor - when moving vertically using j/k
set scrolloff=7

" Turn on the WiLd menu
set wildmenu

"Always show current position
set ruler

" Height of the command bar
set cmdheight=2

" A buffer becomes hidden when it is abandoned
"set hid
nmap <cr> :w!<cr>

set diffopt+=vertical

" Configure backspace so it acts as it should act
set backspace=eol,start,indent
set whichwrap+=<,>,h,l

" Ignore case when searching
set ignorecase

" When searching try to be smart about cases 
set smartcase

" Highlight search results
set hlsearch

" Makes search act like search in modern browsers
set incsearch

" Don't redraw while executing macros (good performance config)
set lazyredraw

" For regular expressions turn magic on
set magic

" Show matching brackets when text indicator is over them
set showmatch
" How many tenths of a second to blink when matching brackets
set matchtime=2

" No annoying sound on errors
set noerrorbells
set novisualbell
set t_vb=
set timeoutlen=500

set background=dark
colorscheme solarized8_dark
" colorscheme jellybeans
" set background=light
" colorscheme solarized8_light

" Set utf8 as standard encoding and en_US as the standard language
" Turn backup off, since most stuff is in SVN, git et.c anyway...
set nobackup
set nowritebackup
set noswapfile

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Text, tab and indent related
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Use spaces instead of tabs
set expandtab

" Be smart when using tabs ;)
set smarttab

" 1 tab == 4 spaces
set shiftwidth=4
set tabstop=4

" Linebreak on 79 characters
set linebreak
set textwidth=79
" Column 80 color indicator
set colorcolumn=80

set autoindent
set smartindent
set wrap "Wrap lines

set formatoptions-=t
"set fo-=l

set viminfo+=n~/.cache/viminfo

" Treat long lines as break lines (useful when moving around in them)
map j gj
map k gk

imap ii <Esc>


" Specify the behavior when switching between buffers 
try
  set switchbuf=useopen,usetab,newtab
  set showtabline=2
catch
endtry

" Return to last edit position when opening files (You want this!)
" http://vim.wikia.com/wiki/Restore_cursor_to_file_position_in_previous_editing_session
augroup default_stuff
    autocmd BufReadPost *
         \ if line("'\"") > 0 && line("'\"") <= line("$") |
         \   exe "normal! g`\"" |
         \ endif
augroup END

" Always show the status line
set laststatus=2

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Editing mappings
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Remap VIM 0 to first non-blank character
map 0 ^
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Misc
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Remove the Windows ^M - when the encodings gets messed up
noremap <leader>m mmHmt:%s/<C-V><cr>//ge<cr>'tzt'm

" Toggle paste mode on and off
map <leader>pp :setlocal paste!<cr>

set tags& tags-=tags tags+=./tags;

" Look and feel
let g:netrw_liststyle = 3
let g:netrw_banner = 0

" Take around 25% of space
let g:netrw_winsize = 25

" 1 - open files in a new horizontal split
" 2 - open files in a new vertical split
" 3 - open files in a new tab
" 4 - open in previous window
let g:netrw_browse_split = 4

nnoremap <leader>d :<C-u>Lexplore<CR>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Plugin Stuff
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:EasyMotion_smartcase = 1

" Airline tabbar and fonts
let g:airline_powerline_fonts = 1
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#disable_refresh = 1

let g:vinarise_enable_auto_detect = 1

" Denite
nmap <space> [denite]
nnoremap [denite] <nop>

if WINDOWS()
    " Pt command on file_rec source
    call denite#custom#var('file_rec', 'command',
                \ ['pt', '--follow', '--nocolor', '--nogroup', '-g:', ''])

    " Pt command on grep source
    call denite#custom#var('grep', 'command', ['pt'])
    call denite#custom#var('grep', 'default_opts',
                \ ['--nogroup', '--nocolor', '--smart-case'])
    call denite#custom#var('grep', 'recursive_opts', [])
    call denite#custom#var('grep', 'pattern_opt', [])
    call denite#custom#var('grep', 'separator', ['--'])
    call denite#custom#var('grep', 'final_opts', [])
end

" Change mappings.
call denite#custom#map(
            \ 'insert',
            \ '<C-j>',
            \ '<denite:move_to_next_line>',
            \ 'noremap'
            \)

call denite#custom#map(
            \ 'insert',
            \ '<C-k>',
            \ '<denite:move_to_previous_line>',
            \ 'noremap'
            \)

" Change matchers.
call denite#custom#source(
            \ 'file_mru', 'matchers', ['matcher_fuzzy', 'matcher_project_files'])

" Change sorters.
call denite#custom#source(
            \ 'file_rec', 'sorters', ['sorter_sublime'])

call denite#custom#source('file_mru', 'converters', ['converter_relative_word'])

" Define alias
call denite#custom#alias('source', 'file_rec/git', 'file_rec')
call denite#custom#var('file_rec/git', 'command',
            \ ['git', 'ls-files', '-co', '--exclude-standard'])

" Change default prompt
call denite#custom#option('default', 'prompt', '>')

" Change ignore_globs
call denite#custom#filter('matcher_ignore_globs', 'ignore_globs',
            \ [ '.git/', '.ropeproject/', '__pycache__/',
            \   'venv/', 'images/', '*.min.*', 'img/', 'fonts/'])

" Add custom menus
" let s:menus = {}

" let s:menus.zsh = {
" 	\ 'description': 'Edit your import zsh configuration'
" 	\ }
" let s:menus.zsh.file_candidates = [
" 	\ ['zshrc', '~/.config/zsh/.zshrc'],
" 	\ ['zshenv', '~/.zshenv'],
" 	\ ]

" let s:menus.my_commands = {
" 	\ 'description': 'Example commands'
" 	\ }
" let s:menus.my_commands.command_candidates = [
" 	\ ['Split the window', 'vnew'],
" 	\ ['Open zsh menu', 'Denite menu:zsh'],
" 	\ ]

" call denite#custom#var('menu', 'menus', s:menus)

nnoremap <silent> [denite]s :<C-u>Denite -buffer-name=source file_rec/git<cr>

nnoremap <silent> [denite]f :<C-u>Denite -buffer-name=files file_rec<cr>

nnoremap <silent> [denite]r :<C-u>Denite -buffer-name=mru file_mru<cr>

nnoremap <silent> [denite]g :<C-u>Denite -no-quit -buffer-name=grep grep<cr>

" Other: Find merge conflict markers
map <leader>fc /\v^[<\|=>]{7}( .*\|$)<CR>

let g:ale_linters = {
            \ 'go': ['go build'],
            \ 'c': ['clang'],
            \ 'cpp': ['clang']
            \}

let g:ale_c_clang_options = '-std=c99 -Wall'

let g:ale_sign_error = ''
let g:ale_sign_warning = ''
let g:ale_statusline_format = [' %d', ' %d', ' ok']

let g:ale_echo_msg_error_str = ''
let g:ale_echo_msg_warning_str = ''
let g:ale_echo_msg_format = '[%linter%] %s [%severity%]'

call airline#parts#define_function('ALE', 'ALEGetStatusLine')
call airline#parts#define_condition('ALE', 'exists("*ALEGetStatusLine")')
let g:airline_section_error = airline#section#create_right(['ALE'])

let g:rooter_targets = '/,*.js,*.java'
