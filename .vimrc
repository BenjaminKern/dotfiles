set encoding=UTF-8
set termguicolors
silent function! WINDOWS()
    return  (has('win32') || has('win64'))
endfunction

if WINDOWS()
call plug#begin('C:/Other/cache/vim-plugins')
else
call plug#begin('~/.vim/plugged')
end
Plug 'junegunn/fzf'
Plug 'junegunn/fzf.vim'
Plug 'tpope/vim-commentary'

Plug 'neoclide/coc.nvim', {'do': 'yarn install --frozen-lockfile'}
" Plug 'neoclide/coc.nvim', {'tag': '*', 'do': 'yarn install'}
Plug 'morhetz/gruvbox'

Plug 'ryanoasis/vim-devicons'

Plug 'scrooloose/nerdtree'

Plug 'easymotion/vim-easymotion'
Plug 'itchyny/lightline.vim'

Plug 'mhinz/vim-startify'
Plug 'honza/vim-snippets'

call plug#end()

if has('gui_running')
    set guifont=InconsolataForPowerline_NF:h11
    set guioptions-=m  "remove menu bar
    set guioptions-=T  "remove toolbar
    set guioptions-=r  "remove right-hand scroll bar
    set guioptions-=L  "remove left-hand scroll bar
    set guioptions-=e  "terminal tablines
endif

" if hidden not set, TextEdit might fail.
set hidden

" Better display for messagesset cmdheight=2

" Smaller updatetime for CursorHold & CursorHoldI
set updatetime=300

" don't give |ins-completion-menu| messages.
set shortmess+=c
"
" always show signcolumns
set signcolumn=yes

if WINDOWS()
    set undodir=C:/Other/cache/vim-undo
else
    set undodir=~/.vim/undo-dir
end
set undofile

let leader = ','
let mapleader = ','
set grepprg=rg\ --vimgrep
set smartcase
set hlsearch
set incsearch
set lazyredraw
set magic

set noerrorbells
set novisualbell
set t_vb=
set timeoutlen=500

set background=dark
colorscheme gruvbox

set nobackup
set nowritebackup
set noswapfile

set bs=2

" Use spaces instead of tabs
set expandtab
" set noexpandtab

" Be smart when using tabs ;)
set smarttab

" 1 tab == 4 spaces
set shiftwidth=4
set tabstop=4

" Linebreak on 79 characters
set linebreak
set textwidth=80
" Column 80 color indicator
" set colorcolumn=80

set autoindent
set smartindent
set wrap "Wrap lines


map 0 ^
map j gj
map k gk
imap ii <Esc>
nmap <cr> :w!<cr>

map <leader>d :NERDTreeToggle<CR>

" let g:ycm_error_symbol = ''
" let g:ycm_warning_symbol = ''

map ww <Plug>(easymotion-w)
map bb <Plug>(easymotion-b)

let g:WebDevIconsUnicodeDecorateFileNodesExtensionSymbols = {}
let g:WebDevIconsUnicodeDecorateFileNodesExtensionSymbols['cs'] = ''
let g:WebDevIconsUnicodeDecorateFileNodesExtensionSymbols['csproj'] = ''
let g:WebDevIconsUnicodeDecorateFileNodesExtensionSymbols['cmd'] = ''

noremap <leader>f :Files<CR>
noremap <leader>g :Rg<CR>
nnoremap <silent><leader>rg :Rg <C-R><C-W><CR>

noremap <expr><Plug>(StopHL) execute('nohlsearch')[-1]
noremap! <expr><Plug>(StopHL) execute('nohlsearch')[-1]

fu! HlSearch()
    let s:pos = match(getline('.'), @/, col('.') - 1) + 1
    if s:pos != col('.')
        call StopHL()
    endif
endfu

fu! StopHL()
    if !v:hlsearch || mode() isnot 'n'
        return
    else
        sil call feedkeys("\<Plug>(StopHL)", 'm')
    endif
endfu

augroup SearchHighlight
au!
    au CursorMoved * call HlSearch()
    au InsertEnter * call StopHL()
    " Return to last edit position when opening files (You want this!)
    au BufReadPost *
         \ if line("'\"") > 0 && line("'\"") <= line("$") |
         \   exe "normal! g`\"" |
         \ endif
augroup end

let g:startify_change_to_dir = 0
let g:startify_change_to_vcs_root = 1

let NERDTreeHijackNetrw = 0
set guicursor+=a:blinkon0 "disable cursor blinking

" Make <tab> used for trigger completion, completion confirm, snippet expand and jump
" inoremap <silent><expr> <TAB>
"       \ pumvisible() ? coc#_select_confirm() :
"       \ coc#expandableOrJumpable() ? coc#rpc#request('doKeymap', ['snippets-expand-jump','']) :
"       \ <SID>check_back_space() ? "\<TAB>" :
"       \ coc#refresh()
" Use tab for trigger completion with characters ahead and navigate.
" Use command ':verbose imap <tab>' to make sure tab is not mapped by other plugin.
" let g:coc_snippet_next = '<tab>'
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction


" Use <c-space> for trigger completion.
inoremap <silent><expr> <c-space> coc#refresh()

" Use <cr> for confirm completion, `<C-g>u` means break undo chain at current position.
" Coc only does snippet and additional edit on confirm.
inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"

" Use `[c` and `]c` for navigate diagnostics
nmap <silent> [c <Plug>(coc-diagnostic-prev)
nmap <silent> ]c <Plug>(coc-diagnostic-next)

" Remap keys for gotos
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Use K for show documentation in preview window
nnoremap <silent> K :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if &filetype == 'vim'
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction

" Highlight symbol under cursor on CursorHold
autocmd CursorHold * silent call CocActionAsync('highlight')

" Remap for rename current word
nmap <leader>rn <Plug>(coc-rename)

" Remap for format selected region
" vmap <leader>f  <Plug>(coc-format-selected)
" nmap <leader>f  <Plug>(coc-format-selected)

augroup mygroup
  autocmd!
  " Setup formatexpr specified filetype(s).
  autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
  " Update signature help on jump placeholder
  autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup end

" Remap for do codeAction of selected region, ex: `<leader>aap` for current paragraph
vmap <leader>a  <Plug>(coc-codeaction-selected)
nmap <leader>a  <Plug>(coc-codeaction-selected)

" Remap for do codeAction of current line
nmap <leader>ac  <Plug>(coc-codeaction)
" Fix autofix problem of current line
nmap <leader>qf  <Plug>(coc-fix-current)

" Use `:Format` for format current buffer
command! -nargs=0 Format :call CocAction('format')

" Use `:Fold` for fold current buffer
" command! -nargs=? Fold :call     CocAction('fold', <f-args>)

" Show all diagnostics
nnoremap <silent><leader>a  :<C-u>CocList diagnostics<cr>
" Find symbol of current document
nnoremap <silent><leader>o  :<C-u>CocList outline<cr>
" Do default action for next item.
nnoremap <silent><space>j  :<C-u>CocNext<CR>
" Do default action for previous item.
nnoremap <silent><space>k  :<C-u>CocPrev<CR>
" Resume latest coc list
nnoremap <silent><space>p  :<C-u>CocListResume<CR>

augroup DefaultSettings
    au BufNewFile,BufRead *.xaml,*.fcr,*.arxml set filetype=xml
    au BufNewFile,BufRead *.c,*.h set noexpandtab
    au FileType json syntax match Comment +\/\/.\+$+
augroup END

let g:lightline = {
      \ 'colorscheme': 'gruvbox',
      \ 'active': {
      \   'left': [ [ 'mode', 'paste' ],
      \             [ 'cocstatus', 'readonly', 'filename', 'modified' ] ]
      \ },
      \ 'component_function': {
      \   'cocstatus': 'coc#status'
      \ },
      \ }

tnoremap <Esc> <C-\><C-n>
" To simulate |i_CTRL-R| in terminal-mode: >
tnoremap <expr> <C-R> '<C-\><C-N>"'.nr2char(getchar()).'pi'
