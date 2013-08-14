" Use any VIM-specific features
" This goes first because it sets quite a few options
set nocompatible
"set cpoptions=ce " take out most VI-compatible options



" ========== NeoBundle Init ==========

if has('vim_starting')
	set runtimepath+=~/.vim/bundle/neobundle.vim/
endif

call neobundle#rc(expand('~/.vim/bundle/'))

NeoBundleFetch 'Shougo/neobundle.vim'

NeoBundle 'altercation/vim-colors-solarized'
NeoBundle 'bitc/vim-hdevtools'
NeoBundle 'bling/vim-airline'
NeoBundle 'digitaltoad/vim-jade'
NeoBundle 'editorconfig/editorconfig-vim'
NeoBundle 'groenewege/vim-less'
NeoBundle 'jakobwesthoff/argumentrewrap'
NeoBundle 'jnurmine/Zenburn'
NeoBundle 'kien/ctrlp.vim'
NeoBundle 'majutsushi/tagbar'
NeoBundle 'marijnh/tern_for_vim'
NeoBundle 'michaeljsmith/vim-indent-object'
NeoBundle 'pangloss/vim-javascript'
NeoBundle 'Raimondi/delimitMate'
NeoBundle 'rbgrouleff/bclose.vim'
NeoBundle 'scrooloose/nerdcommenter'
NeoBundle 'scrooloose/nerdtree'
NeoBundle 'scrooloose/syntastic'
NeoBundle 'sjl/gundo.vim'
NeoBundle 'tpope/vim-abolish'
NeoBundle 'tpope/vim-fugitive'
NeoBundle 'tpope/vim-markdown'
NeoBundle 'tpope/vim-surround'
NeoBundle 'ujihisa/neco-ghc'
NeoBundle 'Valloric/YouCompleteMe'
NeoBundle 'vim-scripts/argtextobj.vim'
NeoBundle 'vim-scripts/bufexplorer.zip'
NeoBundle 'vim-scripts/sh.vim'
NeoBundle 'zship/CamelCaseMotion'
NeoBundle 'zship/vim-easymotion'
NeoBundle 'zship/vim-java-annotation-indent'
NeoBundle 'zship/vim-pasta'
NeoBundle 'zship/vim-rsi'

NeoBundleCheck



" ========== Syntax ==========

filetype on            " enable filetype detection
filetype indent on     " enable filetype-specific indenting
filetype plugin on     " enable filetype-specific plugins
syntax enable          " syntax coloring on



" ========== General ==========

let mapleader = ","         " <Leader> key
set history=100             " command-mode commands saved (default 20)
set nowrap                  " wrap only on actual breaks
set textwidth=0             " do not insert line breaks as I type
set number                  " show line numbers
set showcmd                 " show the current command in the lower right corner
set showmode                " show the current mode at lower-left corner
set lazyredraw              " don't update the display while executing macros
set hidden                  " buffers can exist in the background
set diffopt=vertical        " diff mode should split vertically
set nofoldenable            " disable folding

set laststatus=2            " Always show status line for each window
set noshowmode              " Hide default mode text (vim-airline handles this)
set statusline=%F%m%r%h%w\ (%{&ff}){%Y}\ [%l/%L,%v][%p%%]

runtime macros/matchit.vim  " better % matching



" ========== Indentation ==========

set backspace=2
set smarttab
set autoindent
set smartindent

set listchars=tab:»-,trail:·,nbsp:·  " pretty tabs, trailing spaces
set list                             " show these invisible characters by default

" use editorconfig plugin, but first apply my own settings in case there is no
" .editorconfig file. called from an autocommand (below)
function! IndentationSettings()
	if (&ft == 'haskell')
		set expandtab
		set tabstop=2
		set softtabstop=2
		set shiftwidth=2
	else
		set noexpandtab
		set tabstop=4
		set softtabstop=4
		set shiftwidth=4
	endif

	EditorConfigReload
endfunction



" ========== Searching ==========

set ignorecase          " ignore cAsE in searches
set smartcase           " search in all lowercase, mixed case will be match too
set wrapscan            " searches wrap around the file
set incsearch           " find the next match as you type



" ========== Swap files ==========

silent execute '!mkdir "'.$HOME.'/.vim-backup"'
set backupdir=$HOME/.vim-backup//
set directory=$HOME/.vim-backup//



" ========== Look-and-feel ==========

if has("gui_gtk2")
	set guifont=Consolas\ for\ Powerline\ 11
elseif has("x11")
	set guifont=Consolas\ for\ Powerline\ 11
elseif has("gui_win32")
	set guifont=Consolas\ 11
elseif has("gui_macvim")
	set guifont=Consolas\ for\ Powerline:h12
endif

if &term =~ '^xterm'
	" force 256 colors in terminal
	set t_Co=256

	" change cursor shape in gnome-terminal
	" http://vim.wikia.com/wiki/Change_cursor_shape_in_different_modes
	au InsertEnter * silent execute "!gconftool-2 --type string --set /apps/gnome-terminal/profiles/Default/cursor_shape ibeam"
	au InsertLeave * silent execute "!gconftool-2 --type string --set /apps/gnome-terminal/profiles/Default/cursor_shape block"
	au VimLeave * silent execute "!gconftool-2 --type string --set /apps/gnome-terminal/profiles/Default/cursor_shape block"
endif

set background=light
let g:solarized_visibility="low"
colorscheme solarized
hi SignColumn guibg=#eee8d5
hi Error guibg=#eee8d5
hi Todo guibg=#eee8d5
hi SignColumn guibg=#eee8d5


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



" ========== Cursor/scrolling ==========

set scrolloff=8       " cursor stays within n lines N-S
set sidescrolloff=8   " cursor stays within n lines E-W
set virtualedit=all   " cursor can be over areas with no characters



" ========== Autocommands ==========

augroup personal-autocommands
	autocmd! *

	" Automatically cd into the directory that the file is in
	autocmd BufEnter * execute "chdir ".escape(expand("%:p:h"), ' ')

	" Indentation settings from .editorconfig or explicitly-defined
	autocmd BufNewFile,BufReadPost * call IndentationSettings()

	" less css
	autocmd BufRead,BufNewFile *.less set ft=less

	" more php extensions
	autocmd BufNewFile,BufRead *.module set filetype=php
	autocmd BufNewFile,BufRead *.inc set filetype=php
	autocmd BufNewFile,BufRead *.install set filetype=php

	" This is annoying as hell. There are a handful of options which are being
	" overridden *somewhere*. :verbose set ... doesn't give anything.
	autocmd BufNewFile,BufRead * set textwidth=0
	autocmd BufNewFile,BufRead * set list
	autocmd BufEnter,BufRead *.hs setlocal omnifunc=necoghc#omnifunc
augroup END



" ========== Key Mappings ==========

set iminsert=1  " enable :lmap for easier insert/command/search/replace mappings
set imsearch=-1 " use value of iminsert for searching

if has("gui_macvim")
	" Enable <M-...> keybindings in Mac
	set macmeta
endif


" Window movement/editing
nnoremap <Leader>wj <C-w>j
nnoremap <Leader>wk <C-w>k
nnoremap <Leader>wl <C-w>l
nnoremap <Leader>wh <C-w>h
nnoremap <Leader>wc <C-w>c
nnoremap <Leader>wx <C-w>x
nnoremap <Leader>wv <C-w>v
nnoremap <Leader>ws <C-w>s
nnoremap <Leader>wr <C-w>r
nnoremap <Leader>wz <C-w>z
nnoremap <Leader>wu <C-w>5<
nnoremap <Leader>wi <C-w>5>

" space toggles folds
nnoremap <silent> <Space> @=(foldlevel('.')?'za':'l')<CR>

" toggle search highlighting
nnoremap <silent> <A-y> :set hlsearch! hlsearch?<CR>

" inserting lines without going into insert mode
" only for regular buffers; keep <CR> working for quickfix/nerdtree
nnoremap <expr> <S-Enter> (&l:buftype == '') ? "O\<Esc>" : "\<CR>"
nnoremap <expr> <CR> (&l:buftype == '') ? "o\<Esc>" : "\<CR>"

" escape's too far away; let's use jj
inoremap jj <Esc>

" clipboard paste/copy
"inoremap <C-v> <Esc>"+gp`[v`]=`]a
inoremap <C-v> <Esc>"+gpa
vnoremap <C-c> "+y

" swap ; and :  Convenient. Also activate lmaps when entering command mode
nnoremap ; :<C-^>
nnoremap : ;
vnoremap ; :<C-^>

" Easier movement commands
inoremap <expr> <c-j> pumvisible() ? "\<C-n>" : "\<Down>"
inoremap <expr> <c-k> pumvisible() ? "\<C-p>" : "\<Up>"
inoremap <c-h> <Left>
inoremap <c-l> <Right>
cnoremap <c-j> <Down>
cnoremap <c-k> <Up>
cnoremap <c-h> <Left>
cnoremap <c-l> <Right>
nnoremap <c-j> 20jzz
nnoremap <c-k> 20kzz
nnoremap <c-h> 30h
nnoremap <c-l> 30l
vnoremap <c-j> 20j
vnoremap <c-k> 20k
vnoremap <c-h> 30h
vnoremap <c-l> 30l

" Pinky stretchers. Use lmap to affect all of: insert, command, replace, search
lnoremap <A-a> `
lnoremap <A-z> ~
lnoremap <A-f> +
lmap <A-u> {
lmap <A-i> }
lmap <A-o> (
lmap <A-p> )
lmap <A-Bslash> \|
lmap <A-j> <
lmap <A-k> >
lnoremap <A-;> =
lnoremap <A-l> !
lmap <A-'> "
lmap <A-n> <-
lmap <A-m> [
lmap <A-,> ]
lnoremap <A-q> !
lnoremap <A-w> @
lnoremap <A-e> #
lnoremap <A-r> $
lnoremap <A-t> %
lnoremap <A-y> -
lnoremap <A-h> _
lnoremap <A-g> +
lnoremap <A-.> ->
lnoremap <A-/> =>
" Prevent entering non-breaking space instead of space. Only works on mac.
lnoremap <A-Space> <Space>

" inner-command remaps to correspond to how I map [(" above
nnoremap di<A-'> di"
nnoremap di<A-u> di{
nnoremap di<A-i> di{
nnoremap di<A-o> di(
nnoremap di<A-p> di(
nnoremap di<A-m> di[
nnoremap di<A-,> di[
nnoremap ci<A-'> ci"
nnoremap ci<A-u> ci{
nnoremap ci<A-i> ci{
nnoremap ci<A-o> ci(
nnoremap ci<A-p> ci(
nnoremap ci<A-m> ci[
nnoremap ci<A-,> ci[
vnoremap a<A-'> a"
vnoremap a<A-u> a{
vnoremap a<A-i> a{
vnoremap a<A-o> a(
vnoremap a<A-p> a(
vnoremap a<A-m> a[
vnoremap a<A-,> a[
vnoremap i<A-'> i"
vnoremap i<A-u> i{
vnoremap i<A-i> i{
vnoremap i<A-o> i(
vnoremap i<A-p> i(
vnoremap i<A-m> i[
vnoremap i<A-,> i[

nnoremap <A-z> ~

" indentation command remaps
vnoremap <A-;> =
nnoremap <A-;> ==
vnoremap <A-,> <
nnoremap <A-,> <<
vnoremap <A-.> >
nnoremap <A-.> >>

" Fake keypad
" keypad with AltGr (custom ~/.xmodmap file)
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


" split/join arguments
nnoremap <Leader>sa :call argumentrewrap#RewrapArguments()<CR>
nnoremap <Leader>ja vi(kV:s/,*$//g<CR>gvk:normal $a,<CR>va(J%<Right>x

nnoremap <Leader>co :copen<CR>

" easier filetype switching (for NERD Commenter, mostly)
nnoremap <Leader>th :set filetype=html<CR>
nnoremap <Leader>tp :set filetype=php<CR>
nnoremap <Leader>tj :set filetype=javascript<CR>
nnoremap <Leader>tc :set filetype=css<CR>
nnoremap <Leader>tt :filetype detect<CR>

" save files as root
cmap w!! w !sudo tee % > /dev/null

" edit/source this file
nnoremap <Leader>ev :e ~/.vimrc<CR>
nnoremap <Leader>sv :source ~/.vimrc<CR>



" ========== Plugin Settings ==========


" ---------- vim-easymotion ----------

let g:EasyMotion_mapping_w = '<A-l>'
let g:EasyMotion_mapping_b = '<A-h>'
let g:EasyMotion_mapping_j = '<A-j>'
let g:EasyMotion_mapping_k = '<A-k>'


" ---------- nerdtree ----------

nnoremap <silent> <A-a> :NERDTreeToggle<CR><C-w>=

" Let me use C-j and C-k the same way I do in normal buffers
let NERDTreeMapJumpNextSibling = "<A-u>"
let NERDTreeMapJumpPrevSibling = "<A-i>"


" ---------- bclose ----------

cnoremap bd Bclose


" ---------- bufexplorer ----------

nnoremap <silent> <A-s> :BufExplorer<CR>


" ---------- camelcasemotion ----------

map <silent> w <Plug>CamelCaseMotion_w
map <silent> b <Plug>CamelCaseMotion_b
map <silent> e <Plug>CamelCaseMotion_e
sunmap w
sunmap b
sunmap e
omap <silent> iw <Plug>CamelCaseMotion_iw
xmap <silent> iw <Plug>CamelCaseMotion_iw
omap <silent> ib <Plug>CamelCaseMotion_ib
xmap <silent> ib <Plug>CamelCaseMotion_ib
omap <silent> ie <Plug>CamelCaseMotion_ie
xmap <silent> ie <Plug>CamelCaseMotion_ie


" ---------- clang_complete ----------

"let g:clang_complete_auto = 0
let g:clang_use_library = 1
let g:clang_library_path = "/usr/local/lib"


" ---------- gundo ------------

nnoremap <C-u> :GundoToggle<CR>


" ---------- YouCompleteMe -----------

" Pulled/modified from supertab
function! ShouldComplete()
	let line = getline('.')
	let cnum = col('.')

	let pre = cnum >= 2 ? line[:cnum - 2] : ''
	let noCompleteAfter = ['^', '\s']
	let complAfterType = type(noCompleteAfter)
	for pattern in noCompleteAfter
		if pre =~ pattern . '$'
			return 0
		endif
	endfor
	return 1
endfunction

inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : ShouldComplete() ? "\<C-x>\<C-o>\<C-p>" : "\<Tab>"
let g:ycm_key_list_select_completion = []
let g:ycm_key_list_previous_completion = []
let g:ycm_min_num_of_chars_for_completion = 2
let g:ycm_add_preview_to_completeopt = 1
let g:ycm_autoclose_preview_window_after_insertion = 1
let g:ycm_semantic_triggers =  {
  \   'c' : ['->', '.'],
  \   'objc' : ['->', '.'],
  \   'ocaml' : ['.', '#'],
  \   'cpp,objcpp' : ['->', '.', '::'],
  \   'perl' : ['->'],
  \   'php' : ['->', '::'],
  \   'cs,java,d,vim,ruby,python,perl6,scala,vb,elixir,go' : ['.'],
  \   'lua' : ['.', ':'],
  \   'erlang' : [':'],
  \ }
"let g:ycm_autoclose_preview_window_after_completion = 1


" ---------- neco-ghc -----------

let g:necoghc_enable_detailed_browse = 1


" ---------- syntastic ----------

let g:syntastic_mode_map = {
	\'mode': 'active',
	\'active_filetypes': [],
	\'passive_filetypes': ['java', 'html']
\}

let g:syntastic_javascript_checkers=['jshint']
let g:syntastic_haskell_checkers=['ghc-mod']
let g:syntastic_check_on_open = 1


" ---------- tagbar ------------

nnoremap <silent> <A-d> :TagbarToggle<CR>
let g:tagbar_autofocus = 1
let g:tagbar_sort = 0


" ---------- vim-markdown ----------

" highlight javascript in code blocks
let g:markdown_fenced_languages = ['js=javascript']


" ---------- vim-airline ----------

let g:airline_powerline_fonts = 1
let g:airline_detect_whitespace = 0
let g:airline_theme='solarized'


" ---------- vim-pasta ----------

let g:pasta_disabled_filetypes = ['nerdtree']


" ---------- eclim ----------

let g:EclimHome = '/home/zach/.eclipse/org.eclipse.platform_3.6.1_793567567/plugins/org.eclim_1.6.3'
let g:EclimEclipseHome = '/home/zach/.eclipse/org.eclipse.platform_3.6.1_793567567'
let g:EclimHtmlValidate = 0
let g:EclimXmlValidate = 0
let g:EclimJavaSearchMapping = 0
let g:EclimJavascriptValidate = 0

"Damn it!  This is why I keep getting private static final Log logger =
"LogFactory.getLog([classname]) in every single file! This 'feature' can burn
"in hell!
let g:EclimLoggingDisabled = 1
let g:EclimJavascriptLintEnabled = 0
let g:EclimValidateSortResults = 'severity'

" Ant shortcuts
nnoremap <Leader>ax :Ant xmlc<CR><CR>
nnoremap <Leader>ac :Ant clean<CR><CR>
nnoremap <Leader>ab :Ant build<CR><CR>
nnoremap <Leader>ad :Ant deploy<CR><CR>
nnoremap <Leader>ar :Ant reload<CR><CR>

" Eclim shortcuts
nnoremap <Leader>pr :ProjectRefresh<CR>
