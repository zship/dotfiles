" Use any VIM-specific features
" This goes first because it sets quite a few options
set nocompatible
"set cpoptions=ce " take out most VI-compatible options



" ========== Pathogen Init ==========
" Use the pathogen plugin to manage all other plugins

runtime bundle/pathogen/autoload/pathogen.vim
call pathogen#infect()



" ========== General ==========

let mapleader = ","         " <Leader> key
set history=100             " command-mode commands saved (default 20)
set nowrap                  " wrap only on actual breaks
set textwidth=0             " do not insert line breaks as I type
set number                  " show line numbers
set showcmd                 " Show the current command in the lower right corner
set showmode                " Show the current mode at lower-left corner
set lazyredraw              " Don't update the display while executing macros
set hidden                  " buffers can exist in the background
set diffopt=vertical        " Diff mode should split vertically

set laststatus=2            " Always show status line for each window
set statusline=%F%m%r%h%w\ (%{&ff}){%Y}\ [%l/%L,%v][%p%%]

runtime macros/matchit.vim  " better % matching



" ========== Indentation ==========

set noexpandtab
set smarttab
set backspace=2
set tabstop=4
set softtabstop=4
set shiftwidth=4
set autoindent
set smartindent

set listchars=tab:»-,trail:·,nbsp:·  " pretty tabs, trailing spaces
set list                             " show these invisible characters by default



" ========== Searching ==========

set ignorecase          " ignore cAsE in searches
set smartcase           " search in all lowercase, mixed case will be match too
set wrapscan            " searches wrap around the file
set incsearch           " find the next match as you type



" ========== Swap files ==========

set backupdir=$HOME/.vim/backup/
set directory=$HOME/.vim/backup/



" ========== Syntax ==========

filetype on            " Enable filetype detection
filetype indent on     " Enable filetype-specific indenting
filetype plugin on     " Enable filetype-specific plugins
syntax enable          " syntax coloring on



" ========== Look-and-feel ==========

set gfn=Consolas\ 11

if &term =~ '^xterm'
	" force 256 colors in terminal
	set t_Co=256

	" change cursor shape in gnome-terminal
	" http://vim.wikia.com/wiki/Change_cursor_shape_in_different_modes
	au InsertEnter * silent execute "!gconftool-2 --type string --set /apps/gnome-terminal/profiles/Default/cursor_shape ibeam"
	au InsertLeave * silent execute "!gconftool-2 --type string --set /apps/gnome-terminal/profiles/Default/cursor_shape block"
	au VimLeave * silent execute "!gconftool-2 --type string --set /apps/gnome-terminal/profiles/Default/cursor_shape block"
endif

let g:zenburn_old_Visual=1
colorscheme zenburn

" Zenburn customizations
" lighter line number bg
hi LineNr guibg=#333
hi SignColumn guibg=#333
" for signs to match signcolumn; errors stand out more anyhow
hi Error guibg=#333
" un-bold current line number
hi CursorLineNr gui=none term=none
" old directory
hi Directory ctermfg=188 guifg=#dcdccc
" old listchar
hi SpecialKey ctermfg=240 guibg=NONE guifg=#5c5c5c


" Bare-bones gui options (why clutter it up?)
set guioptions-=m   " no menubar
set guioptions-=T   " no toolbar
set guioptions-=r   " no right-hand scrollbar
set guioptions-=l   " no left-hand scrollbar
set guioptions-=L   " no left-hand scrollbar for vertically-split windows
set guioptions+=c   " make dialogs console dialogs instead of popups

set cursorcolumn    " highlight current col
set cursorline      " highlight current line

set winaltkeys=no   " alt key never hits the window manager



" ========== Completion ==========

set completeopt=menuone,menu,longest,preview
set wildmode=longest,list,full   " bash-like completion
set wildmenu

" pressing up or down actually replaces the text being evaluated
" inoremap <expr> <Esc> pumvisible() ? "\<C-e>" : "\<Esc>"
" inoremap <expr> <CR>  pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
inoremap <expr> <c-j> pumvisible() ? "\<C-n>" : "\<Down>"
inoremap <expr> <c-k> pumvisible() ? "\<C-p>" : "\<Up>"





" ========== Cursor/scrolling ==========

set scrolloff=8       " cursor stays within n lines N-S
set sidescrolloff=8   " cursor stays within n lines E-W
set virtualedit=all   " cursor can be over areas with no characters




" ========== Autocommands ==========

if !exists("autocommands_loaded")
	let autocommands_loaded = 1

	" Automatically cd into the directory that the file is in
	autocmd BufEnter * execute "chdir ".escape(expand("%:p:h"), ' ')

	" less css
	autocmd BufRead,BufNewFile *.less set ft=less

	" Haml - generate html after every save
	"autocmd BufWritePost *.haml execute "silent! !/usr/local/haml/bin/haml " . expand("%") . " " . expand("%:r") . ".html"

	" CSS: I like to indent things differently than VIM assumes
	"au BufEnter *.css set nocindent
	"au BufLeave *.css set cindent

	" more php extensions
	au BufNewFile,BufRead *.module set filetype=php
	au BufNewFile,BufRead *.inc set filetype=php
	au BufNewFile,BufRead *.install set filetype=php

	" This is annoying as hell. There are a handful of options which are being
	" overridden *somewhere*. :verbose set ... doesn't give anything.
	au BufNewFile,BufRead * set textwidth=0
	au BufNewFile,BufRead * set list

	" validate html on save (syntastic is used, I think)
	"au BufWritePost *.html Validate
endif





" ========== Key Mappings ==========

set iminsert=1  " Enable :lmap for easier insert/command/search/replace mappings
set imsearch=-1 " Use value of iminsert for searching


" Windows
nnoremap <Leader>wj <c-w>j
nnoremap <Leader>wk <c-w>k
nnoremap <Leader>wl <c-w>l
nnoremap <Leader>wh <c-w>h
nnoremap <Leader>wc <c-w>c
nnoremap <Leader>wx <c-w>x
nnoremap <Leader>wv <c-w>v
nnoremap <Leader>ws <c-w>s
nnoremap <Leader>wr <c-w>r
nnoremap <Leader>wz <c-w>z
nnoremap <Leader>wu <c-w>5<
nnoremap <Leader>wi <c-w>5>

" Space toggles folds
nnoremap <silent> <Space> @=(foldlevel('.')?'za':'l')<CR>

" Toggle search highlighting
nnoremap <silent> <A-y> :set hlsearch! hlsearch?<CR>

" Inserting lines without going into insert mode
" only for regular buffers; keep <CR> working for quickfix/nerdtree
nnoremap <expr> <S-Enter> (&l:buftype == '') ? "O\<Esc>" : "\<CR>"
nnoremap <expr> <CR> (&l:buftype == '') ? "o\<Esc>" : "\<CR>"

" Escape's too far away; let's use jj
inoremap jj <Esc>

"clipboard paste/copy
inoremap <C-V> <Esc>"+gpa
vnoremap <C-c> "+y

" Visual-mode text pasting without filling the default register
vnoremap r "_dP

" I don't need spaces inserted when joining lines
"vnoremap J gJ

" Swap ; and :  Convenient. Also activate lmaps when entering command mode
nnoremap ; :<C-^>
nnoremap : ;
vnoremap ; :<C-^>

" Easier movement commands
" insert mode j and k are covered under Completion section
inoremap <c-h> <Left>
inoremap <c-l> <Right>
cnoremap <c-j> <Down>
cnoremap <c-k> <Up>
cnoremap <c-h> <Left>
cnoremap <c-l> <Right>
"nnoremap <c-j> <c-d>
"nnoremap <c-k> <c-u>
nnoremap <c-j> 20jzz
nnoremap <c-k> 20kzz
nnoremap <c-h> 30h
nnoremap <c-l> 30l
vnoremap <c-j> 20j
vnoremap <c-k> 20k
vnoremap <c-h> 30h
vnoremap <c-l> 30l


" Pinky stretchers. Use lmap to affect all of: insert, command, replace, search
lnoremap <A-a> ~
lmap <A-u> {
lmap <A-i> }
lmap <A-o> (
lmap <A-p> )
lmap <A-Bslash> \|
lmap <A-j> <
lmap <A-k> >
lnoremap <A-;> =
lnoremap <A-l> _
lmap <A-'> "
lmap <A-m> [
lmap <A-,> ]
lnoremap <A-t> %
lnoremap <A-y> -
lnoremap <A-h> -
lnoremap <A-g> +
lnoremap <A-r> $
lnoremap <A-e> #
lnoremap <A-w> @
lnoremap <A-q> !
lnoremap <A-.> ->
lnoremap <A-/> =>

" inner-command remaps to correspond to how I map [(" above
nnoremap di<A-'> di"
nnoremap di<A-o> di(
nnoremap di<A-p> di(
nnoremap di<A-m> di[
nnoremap di<A-,> di[
nnoremap ci<A-'> ci"
nnoremap ci<A-o> ci(
nnoremap ci<A-p> ci(
nnoremap ci<A-m> ci[
nnoremap ci<A-,> ci[
vnoremap i<A-'> i"
vnoremap i<A-o> i(
vnoremap i<A-p> i(
vnoremap i<A-m> i[
vnoremap i<A-,> i[

" indentation command remaps
vnoremap <A-;> =
nnoremap <A-;> ==
vnoremap <A-,> <
nnoremap <A-,> <<
vnoremap <A-.> >
nnoremap <A-.> >>

" keypad with AltGr (custom xmodmap file)
lnoremap ナ 7
lnoremap ニ 8
lnoremap ラ 9
lnoremap マ 4
lnoremap ノ 5
lnoremap リ 6
lnoremap モ 1
lnoremap ネ 2
lnoremap ル 3
lnoremap ホ 0
lnoremap レ +
lnoremap セ -

nnoremap ナ :7<C-^>
nnoremap ニ :8<C-^>
nnoremap ラ :9<C-^>
nnoremap マ :4<C-^>
nnoremap ノ :5<C-^>
nnoremap リ :6<C-^>
nnoremap モ :1<C-^>
nnoremap ネ :2<C-^>
nnoremap ル :3<C-^>
nnoremap ホ :0<C-^>



" Alt-Shift keypad
"inoremap <A-U> 7
"inoremap <A-I> 8
"inoremap <A-O> 9
"inoremap <A-J> 4
"inoremap <A-K> 5
"inoremap <A-L> 6
"inoremap <A-M> 1
"inoremap <A-lt> 2
"inoremap <A->> 3
"inoremap <A-Y> 0
"inoremap <A-H> 0
"inoremap <A-N> 0

"cnoremap <A-;> <CR>zz 
"nnoremap <A-u> :7
"nnoremap <A-i> :8
"nnoremap <A-o> :9
"nnoremap <A-j> :4
"nnoremap <A-k> :5
"nnoremap <A-l> :6
"nnoremap <A-m> :1
"nnoremap <A-,> :2
"nnoremap <A-.> :3
"nnoremap <A-n> :0

" I use a file with my favorite macros.  This mapping makes using that simpler
" Yank the current line to register c, then switch to the previous window and apply
nnoremap <Leader>mm "cyy<c-w>w@c

" Easier filetype switching (for NERD Commenter, mostly)
nnoremap <Leader>th :set filetype=html<CR>
nnoremap <Leader>tp :set filetype=php<CR>
nnoremap <Leader>tj :set filetype=javascript<CR>
nnoremap <Leader>tc :set filetype=css<CR>
nnoremap <Leader>tt :filetype detect<CR>

" Save files as root
cmap w!! w !sudo tee % > /dev/null

" Edit/source this file
nnoremap <Leader>ev :e ~/.vimrc<CR>
nnoremap <Leader>sv :source ~/.vimrc<CR>

" Find out which plugins are misbehaving
" vim --cmd 'let g:sourced_files=[] | autocmd SourcePre * if !empty(g:sourced_files) && stridx(&cpo, "$")==-1 | echomsg "cpo does not contain dollar sign after loading ".g:sourced_files[-1] | set cpo+=$ | endif | let g:sourced_files+=[expand("<amatch>")]'
" vim --cmd 'let g:sourced_files=[] | autocmd SourcePre * if !empty(g:sourced_files) && &tw != 9 | echomsg "potential textwidth overwrite: ".g:sourced_files[-1] | set tw=9 | endif | let g:sourced_files+=[expand("<amatch>")]'
