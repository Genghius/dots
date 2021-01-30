call plug#begin('~/.vim/plugged')
Plug 'mg979/vim-visual-multi', {'branch': 'master'}
Plug 'morhetz/gruvbox'
Plug 'mbbill/undotree'
if has ('vim')
	Plug 'vbe0201/vimdiscord'
endif
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'ap/vim-css-color'
Plug 'junegunn/goyo.vim'

call plug#end()
execute pathogen#infect()
colorscheme gruvbox
set background=dark
"set nocompatible		" use vim defaults instead of vi
set encoding=utf-8		" always encode in utf
autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o " dissables autocommenting
filetype plugin indent on
syntax on

if has("patch-8.1.1564")
	" Recently vim can merge signcolumn and number column into one
	set signcolumn=number
else
	set signcolumn=yes
endif

set updatetime=300
set cmdheight=2
set nowrap
set noerrorbells
set smartindent
set noswapfile
set nobackup
set undodir=~/.vim/undodir
set undofile
set incsearch
"set autoindent
set colorcolumn=160
highlight ColorColumn ctermbg=0 guibg=lightgrey
set number relativenumber							" Show line numbers
"set completeopt=longest,menuone		" Autocompletion options
"set complete=.,w,b,u,t,i,d			" autocomplete options (:help 'complete')
set hidden							" hide when switching buffers, don't unload
set laststatus=2					" always show status line
"set mouse=a							" enable mouse in all modes
"set noshowmode						" don't show mode, since I'm already using airline
set showbreak="+++ "				" String to show with wrap lines
set showcmd							" show command on last line of screen
set showmatch						" show bracket matches
"set spelllang=en					" spell
"set spellfile=~/.vim/spell/es.utf-8.add
set textwidth=0						" don't break lines after some maximum width
set ttyfast							" increase chars sent to screen for redrawing
if has('vim')
	set ttyscroll=3					    " limit lines to scroll to speed up display
endif
set title							" use filename in window title
set wildmenu						" enhanced cmd line completion
set wildchar=<TAB>					" key for line completion
set splitright						" Split new buffer at right
set scrolloff=20					" Keeps you 20 lines form the bottom. Let's you see more

execute "set <xUp>=\e[1;*A"
execute "set <xDown>=\e[1;*B"
execute "set <xRight>=\e[1;*C"
execute "set <xLeft>=\e[1;*D"

nnoremap tn :tabnew<Space>
nnoremap tk :tabnext<CR>
nnoremap tj :tabprev<CR>
nnoremap <F6> :wincmd v<bar> :Ex <bar> :vertical resize 30<CR>
nnoremap <F4> :UndotreeToggle<CR>
map ; <esc>A;<esc><CR>
map <leader>q <esc>ysiw"
map <leader>m <esc>:!make<CR>
map <leader>z <esc>:Goyo<CR>
autocmd FileType python map <buffer> <F5> :w<CR>:exec '!clear && time python' shellescape(@%, 1)<CR>
autocmd FileType c map <buffer> <F5> :w<CR>:exec '!clear && time tcc -run' shellescape(@%, 1)<CR>
autocmd FileType c map <buffer> <F7> :w<CR>:exec '!clear && gcc -g -Wall ' shellescape(@%, 1) ' && gdb -q a.out && rm a.out'<CR>
autocmd FileType lisp map <buffer> <F5> :w<CR>:exec '!clear && time clisp' shellescape(@%, 1)<CR>
autocmd FileType go map <buffer> <F5> :w<CR>:exec '!clear && time go run' shellescape(@%, 1)<CR>
autocmd FileType javascript map <buffer> <F5> :w<CR>:exec '!clear && time node' shellescape(@%, 1)<CR>
autocmd FileType sh map <buffer> <F5> :w<CR>:exec '!clear && time sh' shellescape(@%, 1)<CR>
autocmd FileType tex map <buffer> <F5> :w<CR>:exec '!clear && latexmk -pdf' shellescape(@%, 1) ' && latexmk -c'<CR>
autocmd FileType tex map <buffer> <F7> :w<CR>:exec '!clear && latexmk -pdf' shellescape(@%, 1) ' && latexmk -c && zathura *.pdf'<CR>

let &t_SI .= "\<Esc>[?2004h"
let &t_EI .= "\<Esc>[?2004l"
let g:ale_lint_on_text_changed = 'never'
let g:ale_lint_on_enter = 0

inoremap <special> <expr> <Esc>[200~ XTermPasteBegin()

function! XTermPasteBegin()
  set pastetoggle=<Esc>[201~
  set paste
  return ""
endfunction

" use <tab> for trigger completion and navigate to the next complete item
function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~ '\s'
endfunction

"inoremap <silent><expr> <Tab>
"      \ pumvisible() ? "\<C-n>" :
"      \ <SID>check_back_space() ? "\<Tab>" :
"      \ coc#refresh()

inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
inoremap <silent><expr> <cr> pumvisible() ? coc#_select_confirm()
                              \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"
