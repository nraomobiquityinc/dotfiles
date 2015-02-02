"-------------------------------------------------------------------------------
" Before using this VIMRC, install Pathogen if you don't have it:
" mkdir -p ~/.vim/autoload ~/.vim/bundle && curl -LSso ~/.vim/autoload/pathogen.vim https://tpo.pe/pathogen.vim
"-------------------------------------------------------------------------------
set nocompatible              " be iMproved, required
filetype off                  " required

"-------------------------------------------------------------------------------
" User Interface
"-------------------------------------------------------------------------------
set background=dark
colorscheme badwolf

let mapleader = ","
set autochdir "current directory changes to that of file being edited
set nowrap guioptions+=b "always show bottom scrollbar
set nu "show line numbers
set backspace=eol,start,indent "backspace always works like one
set ic "ignore case
set smartcase
set hls "highlight search term
set nofoldenable
set incsearch
set ai "Auto indent
set si "Smart indent

" Press Space to clear the current search highlights
nnoremap <silent><Space> :nohlsearch<CR>

" Turn on the WiLd menu
set wildmenu

" Ignore compiled files
set wildignore=*.o,*~,*.pyc

" Don't redraw while executing macros (good performance config)
set lazyredraw

" For regular expressions turn magic on
set magic

" Use tabs for autocomplete
function! Tab_Or_Complete()
  if col('.')>1 && strpart( getline('.'), col('.')-2, 3 ) =~ '^\w'
    return "\<C-N>"
  else
    return "\<Tab>"
  endif
endfunction
:inoremap <Tab> <C-R>=Tab_Or_Complete()<CR>

"-------------------------------------------------------------------------------
" Navigation
"-------------------------------------------------------------------------------
" Treat long lines as break lines (useful when moving around in them)
map j gj
map k gk

"open split windows to the right and above
set nosplitbelow
set splitright

" Configure window splitting
se winminheight=0 "if 0, allows a split window to be minimized till only its statusline shows
if version >= 700
  """ The following two lines:
  """ The first line uses self-destructive mapping to maximize a split window when it is opened
  """ The second line returns i to its normal usage
  au WinEnter    * nmap i :nunmap i<CR><C-W>_
  au WinEnter    * normal i
endif

" Set 7 lines to the cursor - when moving vertically using j/k
set so=5

"-------------------------------------------------------------------------------
" File Handling
"-------------------------------------------------------------------------------
se nobackup "don't create a backup file
se nowb
se noswapfile

"-------------------------------------------------------------------------------
" File Handling - Delete trailing white space on save, useful for Python and CoffeeScript ;)
"-------------------------------------------------------------------------------
func! DeleteTrailingWS()
  exe "normal mz"
  %s/\s\+$//ge
  %s/^\s\+$//ge
  exe "normal `z"
endfunc
autocmd BufWrite * :call DeleteTrailingWS()

"-------------------------------------------------------------------------------
" File Handling - Restore to last location in file
"-------------------------------------------------------------------------------
if has("autocmd") "Open file where you left off
  au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g`\"" | endif
endif

"-------------------------------------------------------------------------------
" File Handling - Syntax highlighting for braces, operators and trailing whitespace
"-------------------------------------------------------------------------------
if has("gui_running")
  if has("autocmd")
    "highlight braces and braces in blue
    au BufReadPost * syn match OpsBraces       /[\[\]{}()<>\.+=\*]/
    au BufReadPost * hi OpsBraces       gui=bold               guifg=#1c7dd3
    au BufReadPost * hi MatchParen      gui=bold guibg=#1c7dd3 guifg=#1a1414
    "highlight trailing whitespace in red
    au BufReadPost * syn match ExtraWhiteSpace /\s\+$/
    au BufReadPost * hi ExtraWhiteSpace          guibg=#dc143c guifg=#dc143c
    "highlight tabs in red
    au BufReadPost * syn match Tabs /\t/
    au BufReadPost * hi Tabs                     guibg=#dc143c guifg=#dc143c
  endif
endif
syntax enable "syntax highlighting

map <D-r> :ReplaceCurWord<CR>
command! -bar ReplaceCurWord call ReplaceCurWord()

"-------------------------------------------------------------------------------
" File Handling - replace word under cursor with a user-prompted value
"-------------------------------------------------------------------------------
function! ReplaceCurWord()
    "make sure an undo will bring us back where we were
    normal ix
    normal x
    let l:winview = winsaveview() "save cursor position
    let wordUnderCursor = expand("<cword>")
    call inputsave()
    let replacement = input('Remplacer avec? ')
    call inputrestore()
    %call ReplaceWord(wordUnderCursor, replacement)
    call winrestview(l:winview) "restore cursor position
endfunction

function! ReplaceWord(to_replace,replacement) range
    for linenum in range(a:firstline, a:lastline)
      let curr_line   = getline(linenum)
      let replacement = substitute(curr_line,join(['\<',a:to_replace,'\>'],''),a:replacement,'g')
      call setline(linenum, replacement)
    endfor
endfunction

"-------------------------------------------------------------------------------
" File Handling - Format Javascript on file save
"-------------------------------------------------------------------------------
" Workaround because vim-jsbeautify doesn't pick up .editorconfig from ~/.vim
" or ~/. on a Mac
let g:config_Beautifier= { 'js': { 'path': '~/.vim/bundle/vim-jsbeautify/plugin/lib/js/lib/beautify.js', 'indent_style': 'space', 'indent_size': '2', 'bin': 'node' }, 'html': { 'brace_style': 'expand', 'preserve_newlines': 'true', 'path': '~/.vim/bundle/vim-jsbeautify/plugin/lib/js/lib/beautify-html.js', 'indent_inner_html': 'true', 'indent_style': 'space', 'indent_size': '2', 'max_char': '78' }, 'css': { 'path': '~/.vim/bundle/vim-jsbeautify/plugin/lib/js/lib/beautify-css.js', 'indent_style': 'space', 'indent_size': '2' } }

fun! FormatJavascript()
    if exists('b:isJsFile')
        :call JsBeautify()
    endif
endfun

autocmd BufWritePre * silent call FormatJavascript()
autocmd FileType javascript let b:isJsFile=1

"-------------------------------------------------------------------------------
" Tab expansions and indenting
"-------------------------------------------------------------------------------
"From Vim Help (I'm using option 2):
"There are four main ways to use tabs in Vim:
" 1. Always keep 'tabstop' at 8, set 'softtabstop' and 'shiftwidth' to 4
"    (or 3 or whatever you prefer) and use 'noexpandtab'.  Then Vim
"    will use a mix of tabs and spaces, but typing <Tab> and <BS> will
"    behave like a tab appears every 4 (or 3) characters.
" 2. Set 'tabstop' and 'shiftwidth' to whatever you prefer and use
"    'expandtab'.  This way you will always insert spaces.  The
"    formatting will never be messed up when 'tabstop' is changed.
" 3. Set 'tabstop' and 'shiftwidth' to whatever you prefer and use a
"    |modeline| to set these values when editing the file again.  Only
"    works when using Vim to edit the file.
" 4. Always set 'tabstop' and 'shiftwidth' to the same value, and
"    'noexpandtab'.  This should then work (for initial indents only)
"    for any tabstop setting that people use.  It might be nice to have
"    tabs after the first non-blank inserted as spaces if you do this
"    though.  Otherwise aligned comments will be wrong when 'tabstop' is
"    changed.
se shiftwidth=2 "number of spaces for indent
se expandtab "replace tab by spaces
se smarttab
se tabstop=2

"-------------------------------------------------------------------------------
" Key Mappings
"-------------------------------------------------------------------------------
map <F1> :NERDTreeToggle<CR>
map <F2> :w!<CR>
map <F3> :wq!<CR>
map <F4> :q!<CR>
map <F5> :e#<CR>
map <F6> <C-W><C-W>
map <F7> <C-W>_
map <F8> "=strftime("%d %B %Y @ %H:%M %Z")<CR>p"<Esc>
map <F9> :w!<CR>:!python %<CR>
map <F10> :InsFuncSnippet<CR>
inoremap <F10> <Esc>:InsFuncSnippet<CR>a

" Move a line of text using ALT+[jk]
map <D-j> mz:m+<cr>`z
map <D-k> mz:m-2<cr>`z
vmap <D-j> :m'>+<cr>`<my`>mzgv`yo`z
vmap <D-k> :m'<-2<cr>`>my`<mzgv`yo`z

" Navigate split windows
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>

"-------------------------------------------------------------------------------
" User Functions
"-------------------------------------------------------------------------------
nnoremap <C-H> :Hexmode<CR>
inoremap <C-H> <Esc>:Hexmode<CR>
vnoremap <C-H> :<C-U>Hexmode<CR>
" ex command for toggling hex mode - define mapping if desired
command! -bar Hexmode call ToggleHex()

" helper function to toggle hex mode
function! ToggleHex()
  " hex mode should be considered a read-only operation
  " save values for modified and read-only for restoration later,
  " and clear the read-only flag for now
  let l:modified=&mod
  let l:oldreadonly=&readonly
  let &readonly=0
  let l:oldmodifiable=&modifiable
  let &modifiable=1
  if !exists("b:editHex") || !b:editHex
    " save old options
    let b:oldft=&ft
    let b:oldbin=&bin
    " set new options
    setlocal binary " make sure it overrides any textwidth, etc.
    let &ft="xxd"
    " set status
    let b:editHex=1
    " switch to hex editor
    %!xxd
  else
    " restore old options
    let &ft=b:oldft
    if !b:oldbin
      setlocal nobinary
    endif
    " set status
    let b:editHex=0
    " return to normal editing
    %!xxd -r
  endif
  " restore values for modified and read only state
  let &mod=l:modified
  let &readonly=l:oldreadonly
  let &modifiable=l:oldmodifiable
endfunction

"function to enter a header snippet above a C/Java function
command! -bar InsFuncSnippet call InsFuncSnippet()
function! InsFuncSnippet()
  "Stores the name of the function. ASSUMES THE USER PLACES THE CURSOR ON THE
  "FUNCTION NAME BEFORE CALLING THIS FUNCTION
  let @a=expand("<cword>")
  "Stores the return value of the function.
  exe "normal " 'e' 2 . 'b'
  let @b=expand("<cword>")
  "Finds the indentation of the line so that the function snippet stays
  "aligned to the code
  exe "normal " '0' 'w'
  "Calculates the number of dashes to insert after '/*'"
  let numDashes=80-(col('.')+1)
  "Stores the '-' character that we can then paste
  let @c="-"

  exe "normal " "O/*\<Esc>" numDashes . '"cp' '$' 'x' 'x'
  exe "normal " "oMethod Name:  \<Esc>" '"ap'
  exe "normal " "oPurpose:      \<Esc>"
  exe "normal " "oParameters:   \<Esc>"
  exe "normal " "oDependencies: None\<Esc>"
  exe "normal " "oReturns:      \<Esc>" '"bp'
  " We subtract 2 from numDashes to counteract the effect of smartindenting
  " which adds ' *' (a space and a *) to the start of the comment line
  exe "normal " "o\<Esc>" (numDashes-2) . '"cp' 'a*/'
endfunction

"-------------------------------------------------------------------------------
" Configure StatusLine
"-------------------------------------------------------------------------------
hi User1 guifg=#ffdad8  guibg=#880c0e
hi User2 guifg=#000000  guibg=#F4905C
hi User3 guifg=#292b00  guibg=#f4f597
hi User4 guifg=#112605  guibg=#aefe7B
hi User5 guifg=#051d00  guibg=#7dcc7d
hi User7 guifg=#ffffff  guibg=#880c0e gui=bold
hi User8 guifg=#ffffff  guibg=#5b7fbb
hi User9 guifg=#ffffff  guibg=#810085
hi User0 guifg=#ffffff  guibg=#094afe

if has("gui_running")
  set statusline=
  set statusline+=%1*\ %<%F%m%r%w\                          "File+path
  set statusline+=%2*\ %y\                                  "FileType
  set statusline+=%4*\ %{&ff}\                              "FileFormat (dos/unix..)
  set statusline+=%8*\ %=\ row:%l/%L\ (%p%%)\               "Rownumber/total (%)
  set statusline+=%9*\ col:%03c\                            "Colnr
  set statusline+=%0*\ \ %P\ \                              "Modified? Readonly? Top/bot.

  se laststatus=2 "always show statusline
  let g:activestatusline=&g:statusline
  if version >= 700
    au WinEnter    * let &l:statusline=g:activestatusline
  endif
else
  set statusline=
  set statusline+=%0*\ %<%F%m%r%w\                          "File+path
  set statusline+=%0*\ %y\                                  "FileType
  set statusline+=%0*\ %{&ff}\                              "FileFormat (dos/unix..)
  set statusline+=%0*\ %=\ row:%l/%L\ (%p%%)\               "Rownumber/total (%)
  set statusline+=%0*\ col:%03c\                            "Colnr
  set statusline+=%0*\ \ %P\ \                              "Modified? Readonly? Top/bot.

  se laststatus=2 "always show statusline
  let g:activestatusline=&g:statusline
  if version >= 700
    au WinEnter    * let &l:statusline=g:activestatusline
  endif
endif

"-------------------------------------------------------------------------------
" Load all plugins in ~/.vim/bundle/
"-------------------------------------------------------------------------------
execute pathogen#infect()

filetype on
filetype plugin on
filetype plugin indent on
