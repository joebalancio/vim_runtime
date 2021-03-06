source $HOME/.vim/vimrc-deps

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Local .vimrc
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
if filereadable(glob("~/.vimrc.local")) 
  source ~/.vimrc.local
endif

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => General
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Sets how many lines of history VIM has to remember
set history=700

" Enable filetype plugin
filetype plugin indent on

" Enable modeline
set modeline
set modelines=3

" Set to auto read when a file is changed from the outside
set autoread

" With a map leader it's possible to do extra key combinations
" like <leader>w saves the current file
let mapleader = ","
let g:mapleader = ","

" Fast saving
nmap <leader>w :w!<cr>

" Fast editing of the .vimrc
map <leader>rc :e! ~/.vimrc<cr>

set wildignore+=*/.git/*
set wildignore+=*/.hg/*

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => VIM user interface
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Set 7 lines to the curors - when moving vertical..
set so=7

set wildmenu "Turn on WiLd menu

set ruler "Always show current position

set cmdheight=2 "The commandbar height

set hid "Change buffer - without saving

" Set backspace config
set backspace=eol,start,indent
set whichwrap+=<,>,h,l

set ignorecase "Ignore case when searching
set smartcase

set hlsearch "Highlight search things

" set incsearch "Make search act like search in modern browsers
set nolazyredraw "Don't redraw while executing macros

set magic "Set magic on, for regular expressions

set showmatch "Show matching bracets when text indicator is over them
set mat=2 "How many tenths of a second to blink

" No sound on errors
set noerrorbells
set novisualbell
set t_vb=

set timeoutlen=1000 ttimeoutlen=0

" Based on gitgutter's recommendation
set updatetime=250
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Colors and Fonts
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
syntax enable "Enable syntax hl
if has('nvim') 
  set termguicolors
  " let $NVIM_TUI_ENABLE_TRUE_COLOR=1
endif

set t_Co=256
set background=dark
colorscheme base16-pop
set number

set encoding=utf8
try
    lang en_US
catch
endtry

set fileformats=unix,dos,mac "Default file types
set guifont=Source\ Code\ Pro\ for\ Powerline:h11

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Files, backups and undo
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Turn backup off, since most stuff is in SVN, git anyway...
set nobackup
set nowb
set noswapfile

"Persistent undo
try
  set undodir=~/.vim/undodir
  set undofile
catch
endtry



"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Text, tab and indent related
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set expandtab
set shiftwidth=2
set tabstop=2
set smarttab

set wrap "Wrap lines
set linebreak
set list
set textwidth=0
let &showbreak = '> '

set listchars=trail:·,eol:$,tab:➪\ 

set ai "Auto indent
set si "Smart indet

set showtabline=0

" Show a line at 100 characters to assist with wrapping
set colorcolumn=100

" remove trailing spaces from c, cpp, java, php, js
autocmd FileType c,cpp,java,php,javascript,coffee,less,html,scala autocmd BufWritePre <buffer> :%s/\s\+$//e

" Autoformat
"autocmd FileType javascript autocmd BufWritePre <buffer> Autoformat

autocmd FileType html,javascript set shiftwidth=4
autocmd FileType html,javascript set tabstop=4
autocmd FileType css,scss set shiftwidth=2
autocmd FileType css,scss set tabstop=2

autocmd FileType php set shiftwidth=4
autocmd FileType php set tabstop=4

autocmd BufNewFile,BufReadPost *.md set filetype=markdown
autocmd BufNewFile,BufRead *.fmt set filetype=html

" Yank to system clipboard
"vnoremap <silent> <leader>y :call VisualSelection('yank')<CR>
"vnoremap <silent> <leader>y :'<,'>w !pbcopy<CR><CR>
vnoremap <silent> <leader>y :w !pbcopy<CR><CR>

""""""""""""""""""""""""""""""
" => Visual mode related
""""""""""""""""""""""""""""""
" NOTICE: Really useful!

"  In visual mode when you press * or # to search for the current selection
vnoremap <silent> * :call VisualSelection('f')<CR>
vnoremap <silent> # :call VisualSelection('b')<CR>

" When you press gv you vimgrep after the selected text
vnoremap <silent> gv :call VisualSelection('gv')<CR>

" Some useful keys for vimgrep
map <leader>g :vimgrep // **/*.<left><left><left><left><left><left><left>
map <leader><space> :vimgrep // <C-R>%<C-A><right><right><right><right><right><right><right><right><right>

" When you press <leader>r you can search and replace the selected text
vnoremap <silent> <leader>r :call VisualSelection('replace')<CR>

"
" From an idea by Michael Naumann
"
function! CmdLine(str)
    exe "menu Foo.Bar :" . a:str
    emenu Foo.Bar
    unmenu Foo
endfunction

function! VisualSelection(direction) range
    let l:saved_reg = @"
    execute "normal! vgvy"

    let l:pattern = escape(@", '\\/.*$^~[]')
    let l:pattern = substitute(l:pattern, "\n$", "", "")

    if a:direction == 'b'
        execute "normal ?" . l:pattern . "^M"
    elseif a:direction == 'gv'
        call CmdLine("vimgrep " . '/'. l:pattern . '/' . ' **/*.')
    elseif a:direction == 'replace'
        call CmdLine("%s" . '/'. l:pattern . '/')
    elseif a:direction == 'f'
        execute "normal /" . l:pattern . "^M"
    elseif a:direction == 'search_files'
        call CmdLine("Ack " . @")
    elseif a:direction == 'yank'
        call CmdLine("w !pbcopy<CR>")
    endif

    let @/ = l:pattern
    let @" = l:saved_reg
endfunction


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Command mode related
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Smart mappings on the command line
cno $h e ~/
cno $d c <C-\>eCurrentFileDir("e")<cr>
cno $j e ./
cno $c e <C-\>eCurrentFileDir("e")<cr>

" $q is super useful when browsing on the command line
cno $q <C-\>eDeleteTillSlash()<cr>

func! Cwd()
  let cwd = getcwd()
  return "e " . cwd
endfunc

func! DeleteTillSlash()
  let g:cmd = getcmdline()
    let g:cmd_edited = substitute(g:cmd, "\\(.*\[/\]\\).*", "\\1", "")
  if g:cmd == g:cmd_edited
      let g:cmd_edited = substitute(g:cmd, "\\(.*\[/\]\\).*/", "\\1", "")
  endif
  return g:cmd_edited
endfunc

func! CurrentFileDir(cmd)
  return a:cmd . " " . expand("%:p:h") . "/"
endfunc


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Moving around, tabs and buffers
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"Useful when moving accross long lines
"map j gj
"map k gk

" Map space to / (search) and c-space to ? (backgwards search)
"map <space> /
"map <c-space> ?
map <silent> <leader><cr> :noh<cr>

" Smart way to move btw. windows
map <C-j> <C-W>j
map <C-k> <C-W>k
map <C-h> <C-W>h
map <C-l> <C-W>l

" Temporary workaround for: https://github.com/neovim/neovim/issues/2048
if has("nvim")
  map <BS> <C-W>h
endif

"" Close the current buffer
map <leader>bd :Bclose<cr>

" Close all the buffers
map <leader>ba :1,300 bd!<cr>

" Use the arrows to something usefull
map <right> :bn<cr>
map <left> :bp<cr>

" Tab configuration
map <leader>tn :tabnew! %<cr>
map <leader>te :tabedit
map <leader>tc :tabclose<cr>
map <leader>tm :tabmove
map <C-Left> :tabprevious<CR>
map <C-Right> :tabnext<CR>
nnoremap <silent> <A-Left> :execute 'silent! tabmove ' . (tabpagenr()-2)<CR>
nnoremap <silent> <A-Right> :execute 'silent! tabmove ' . tabpagenr()<CR>

" When pressing <leader>cd switch to the directory of the open buffer
map <leader>cd :cd %:p:h<cr>


command! Bclose call <SID>BufcloseCloseIt()
function! <SID>BufcloseCloseIt()
   let l:currentBufNum = bufnr("%")
   let l:alternateBufNum = bufnr("#")

   if buflisted(l:alternateBufNum)
     buffer #
   else
     bnext
   endif

   if bufnr("%") == l:currentBufNum
     new
   endif

   if buflisted(l:currentBufNum)
     execute("bdelete! ".l:currentBufNum)
   endif
endfunction

" Specify the behavior when switching between buffers
set switchbuf=useopen

" Return to last edit position (You want this!) *N*
"autocmd BufReadPost *
"     \ if line("'\"") > 0 && line("'\"") <= line("$") |
"     \   exe "normal! g`\"" |
"     \ endif


"Remeber open buffers on close
"set viminfo^=%

" http://stackoverflow.com/questions/1534835/how-do-i-close-all-buffers-that-arent-shown-in-a-window-in-vim
function! DeleteInactiveBufs()
    "From tabpagebuflist() help, get a list of all buffers in all tabs
    let tablist = []
    for i in range(tabpagenr('$'))
        call extend(tablist, tabpagebuflist(i + 1))
    endfor

    "Below originally inspired by Hara Krishna Dara and Keith Roberts
    "http://tech.groups.yahoo.com/group/vim/message/56425
    let nWipeouts = 0
    for i in range(1, bufnr('$'))
        if bufexists(i) && !getbufvar(i,"&mod") && index(tablist, i) == -1
        "bufno exists AND isn't modified AND isn't in the list of buffers open in windows and tabs
            silent exec 'bwipeout' i
            let nWipeouts = nWipeouts + 1
        endif
    endfor
    echomsg nWipeouts . ' buffer(s) wiped out'
endfunction
command! Bdi :call DeleteInactiveBufs()

""""""""""""""""""""""""""""""
" => Statusline
""""""""""""""""""""""""""""""
" Always hide the statusline
set laststatus=2

"Git branch
function! GitBranch()
    try
        let branch = system("git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* //'")
    catch
        return ''
    endtry

    if branch != ''
        return '   Git Branch: ' . substitute(branch, '\n', '', 'g')
    en

    return ''
endfunction

function! CurDir()
    return substitute(getcwd(), '/Users/amir/', "~/", "g")
endfunction

function! HasPaste()
    if &paste
        return 'PASTE MODE  '
    en
    return ''
endfunction

" Format the statusline
set statusline=\ %{HasPaste()}%F%m%r%h\ %w\ \ CWD:\ %r%{CurDir()}%h\ \ \ Line:\ %l/%L%{GitBranch()}

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Editing mappings
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"Remap VIM 0
map 0 ^

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Omni complete functions
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
autocmd FileType css set omnifunc=csscomplete#CompleteCSS

""""""""""""""""""""""""""""""
" => JavaScript section
"""""""""""""""""""""""""""""""
au FileType javascript call JavaScriptFold()
" au FileType javascript setl fen
" au FileType javascript setl nocindent

function! JavaScriptFold()
    " setl foldlevelstart=1
    syn region foldBraces start=/{/ end=/}/ transparent fold
    " syn region foldBraces start=/{/ end=/}/ transparent fold keepend extend
    setl foldmethod=syntax
    setl foldlevel=99

    " function! FoldText()
        " return substitute(getline(v:foldstart), '{.*', '{...}', '')
    " endfunction
    " setl foldtext=FoldText()
endfunction

" au FileType javascript setl nofoldenable

""""""""""""""""""""""""""""""
" => Vim grep
""""""""""""""""""""""""""""""
let Grep_Skip_Dirs = 'RCS CVS SCCS .svn .git .hg generated'
set grepprg=/bin/grep\ -nH

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => MISC
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Remove the Windows ^M - when the encodings gets messed up
noremap <Leader>m mmHmt:%s/<C-V><cr>//ge<cr>'tzt'm

map <leader>pp :setlocal paste!<cr>

map <leader>bb :cd ..<cr>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => PHP
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
au FileType php compiler php
set tags=tags;/,~/.vim/mytags/pear/tags

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => CtrlP
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:ctrlp_open_multi = 'hr'
let g:ctrlp_custom_ignore = {
  \ 'dir': '\v[\/](node_modules|components|bower_components|vms)|(\.(git|hg|svn))$'
  \ }
let g:ctrlp_max_files = 0
let g:ctrlp_max_depth = 40
let g:ctrlp_clear_cache_on_exit = 0
" let g:ctrlp_lazy_update = 250
let g:ctrlp_open_multiple_files = 'vjr'
let g:ctrlp_working_path_mode = 'ra'

nmap ff :CtrlPMixed<cr>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => QuickFix / Location List
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
map <leader>n :cnext<cr>
map <leader>p :cprev<cr>
map <leader>nn :clast<cr>
map <leader>pp :cfirst<cr>

map <leader>j :lnext<cr>
map <leader>k :lprev<cr>
map <leader>jj :llast<cr>
map <leader>kk :lfirst<cr>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => NERD Tree
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
map <leader>\ :NERDTreeToggle<cr>
map <leader>] :NERDTreeFind<cr>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Source Local VIMRC
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:localvimrc_ask = 0

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Mouse
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set mouse=a
if !has('nvim')
  set ttymouse=xterm2
endif

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => tmux
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Fast editing of the .tmux.conf
map <leader>t :e! ~/.tmux.conf<cr>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => vim-airline
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:airline_powerline_fonts = 1
let g:airline_theme = 'badwolf'
let g:airline_inactive_collapse = 0
let g:airline#extensions#default#section_truncate_width = {
    \ 'b': 100,
    \ 'x': 120,
    \ 'y': 120,
    \ 'z': 100,
    \ 'warning': 80,
    \ }

let g:airline#extensions#whitespace#enabled = 0

let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#show_close_button = 0
let g:airline#extensions#tabline#show_splits = 0

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Ack
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
vnoremap <silent> <leader>s :call VisualSelection('search_files')<CR>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Vim Git Gutter
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:gitgutter_max_signs=1000

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => NERD Commenter
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Add spaces after comment delimiters by default
let g:NERDSpaceDelims = 1

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => neovim / terminal
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
if has('nvim') 
	tnoremap <C-h> <C-\><C-n><C-w>h
	tnoremap <C-j> <C-\><C-n><C-w>j
	tnoremap <C-k> <C-\><C-n><C-w>k
	tnoremap <C-l> <C-\><C-n><C-w>l
endif

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => UltiSnips
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Don't use <Tab> for auto completion
let g:UltiSnipsExpandTrigger="<C-j>"
autocmd FileType javascript UltiSnipsAddFiletypes javascript-node
autocmd FileType javascript UltiSnipsAddFiletypes javascript.node
autocmd FileType javascript UltiSnipsAddFiletypes javascript.es6
let g:UltiSnipsEditSplit = "context"
let g:UltiSnipsSnippetsDir = "~/.vim/UltiSnips"
inoremap <expr><TAB>  pumvisible() ? "\<C-n>" : "\<TAB>"

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Neomake
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
autocmd! BufWritePost,BufReadPost * Neomake

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => SuperTab
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Use <Tab> for all auto completion
autocmd FileType javascript let g:SuperTabDefaultCompletionType = "<c-x><c-o>"

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => deoplete.nvim
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:deoplete#enable_at_startup = 1
let g:deoplete#enable_smart_case = 1
let g:deoplete#omni#functions = {}
let g:deoplete#omni#functions.javascript = [
  \ 'tern#Complete',
  \ 'jspc#omni'
\]
set completeopt=longest,menuone
let g:deoplete#sources = {}
let g:deoplete#sources['javascript'] = ['file', 'ultisnips', 'ternjs']
let g:deoplete#sources['javascript.jsx'] = ['file', 'ultisnips', 'ternjs']
let g:deoplete#file#enable_buffer_path = 1
let g:tern#command = ['tern']
let g:tern#arguments = ['--persistent']
