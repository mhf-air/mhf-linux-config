" vim-notes
" in command-line mode
" % current filename, %:p current full filename

" =============================== Basic ====================================

" neccesary setup
set nocompatible
syntax on
set nobackup
set noswapfile
set clipboard=unnamedplus

set term=xterm-256color
set background=dark
au BufEnter * if &filetype == "" | setlocal ft=conf | endif

" set noerrorbells visualbell t_vb=
" autocmd TabEnter * set visualbell t_vb=

" some command-line mode bindings, use ,: to enter : in command-line
cnoremap : w<space>!
cnoremap ,: :
let $BASH_ENV="~/.bash_aliases"

" some leader bindings
let mapleader=","
nnoremap <leader>l gt
nnoremap <leader>h gT
nnoremap <leader>x :tabclose<cr>
nnoremap <leader>w :w<cr>
nnoremap <leader>q :tabfirst<cr>:tabonly<cr><c-z>

nnoremap <leader>t :YcmCompleter GoTo<cr>
" nnoremap <c-g> :YcmCompleter GoTo<cr>
" nnoremap <c-h> <c-o>
" nnoremap <c-l> <c-i>

" cross display
" au BufEnter * setlocal cursorline cursorcolumn
au VimEnter,WinEnter,BufWinEnter * setlocal cursorline cursorcolumn
au WinLeave * setlocal nocursorline nocursorcolumn
hi Cursorline cterm=NONE ctermbg=235
hi Cursorcolumn cterm=NONE ctermbg=235
au FileType tagbar setlocal nocursorline nocursorcolumn

"status line
set laststatus=2
set statusline=
set statusline+=%1*\ %<\ %F
set statusline+=%1*\ %m%r 
" set statusline+=%1*\ %50(\ %)   "padding    %1*\  is a group for hi User1 cterm=102
" set statusline+=%2*\ %10{getcwd()}
set statusline+=%=                                "separator between left and right
set statusline+=%1*\ %-20((%P)%L\ \ %5l,%-3c%)

" status line and vertical border
set fillchars+=vert:\  "there must be a trailling blank at the end
hi User1 ctermfg=102 ctermbg=235
hi User2 ctermfg=166 ctermbg=235
hi VertSplit ctermfg=235
hi StatusLine ctermfg=235
hi StatusLine ctermbg=235
hi StatusLineNC ctermfg=235
hi StatusLineNC ctermbg=235

" sign column
hi SignColumn ctermbg=235

" tab line
hi TabLineFill ctermfg=235
hi TabLine cterm=bold ctermbg=235 ctermfg=30
hi TabLineSel ctermfg=28

" visual mode
hi Visual ctermbg=166

" pop-up menu
hi Pmenu ctermbg=235 ctermfg=173
hi PmenuSel ctermbg=237 ctermfg=173
hi PmenuSbar ctermbg=235
hi PmenuThumb ctermbg=237

" change cursor color in different modes
let &t_SI="\<Esc>]12;green\x7"
let &t_EI="\<Esc>]12;purple\x7"

" line number
set number
set numberwidth=4
set ruler

" tab
set smarttab
set expandtab
set tabstop=2
set softtabstop=2
set shiftwidth=2

" indent
set smartindent
set autoindent
set backspace=indent,eol,start
set showcmd
set showmode
set showmatch

" search
set incsearch
set hlsearch
nnoremap <space> :nohlsearch<cr>
" nnoremap <leader>cp :TagbarClose<cr>:set nonumber<cr>
" nnoremap <leader>nm :TagbarOpen<cr>:set number<cr>
set ignorecase
set smartcase
set isk+=-

" wrap
set wrap
set wrapmargin=0
set linebreak
set nolist
set textwidth=0

" misc
set confirm
set cmdheight=1

" encoding
set encoding=utf-8
set fileencoding=utf-8
set fileencodings=ucs-bom,utf-8
set scrolloff=3

" bind <esc> to hl in Insert mode and Visual
inoremap hl <esc>
vnoremap hl <esc>

" to move in long lines
nnoremap j  gj
nnoremap k  gk

" change bindings for moving between windows
nnoremap J  <C-w>j
nnoremap K  <C-w>k
nnoremap H  <C-w>h
nnoremap L  <C-w>l

" =============================== Optional ====================================

" colorscheme ron
" hi Pmenu ctermbg=235 ctermfg=173
" hi Pmenu ctermbg=235 ctermfg=37

" cabbrev ! w<space>!
" nnoremap <leader>q :wqa<cr>

" set colorcolumn=85

" python
" au FileType python setlocal tabstop=4

" fold
" set foldmethod=indent

" unmap <esc> for adapting to hl
" inoremap <esc> <nop>
" vnoremap <esc> <nop>

" =============================== Vundle ====================================

filetype off
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

Plugin 'VundleVim/Vundle.vim'
" Plugin 'valloric/YouCompleteMe'
" Plugin 'w0rp/ale'
Plugin 'scrooloose/nerdtree'
Plugin 'jistr/vim-nerdtree-tabs'
Plugin 'scrooloose/nerdcommenter'
Plugin 'ctrlpvim/ctrlp.vim'
Plugin 'majutsushi/tagbar'
Plugin 'kshenoy/vim-signature'
Plugin 'mileszs/ack.vim'

" Plugin 'Yggdroot/indentLine'
" Plugin 'xolox/vim-easytags'
" Plugin 'xolox/vim-misc'

Plugin 'fatih/vim-go'
Plugin 'rust-lang/rust.vim'
Plugin 'udalov/kotlin-vim'
Plugin 'wavded/vim-stylus'
Plugin 'leafgarland/typescript-vim'
Plugin 'mhf-air/vim-pug'
Plugin 'mhf-air/vim-vue'
" Plugin 'digitaltoad/vim-pug'
" Plugin 'posva/vim-vue'

call vundle#end()
filetype on

" =============================== Plugin ====================================

filetype plugin on

" rust
let g:rustfmt_autosave=1
let g:rustfmt_fail_silently=1
" let g:ycm_rust_src_path="/home/mhf/.multirust/toolchains/stable-x86_64-unknown-linux-gnu/lib/rustlib/src/rust/src"

" nerdtree
let NERDTreeWinPos=1
" let NERDTreeCaseSensitiveSort=1
let NERDTreeSortOrder=['\/$', '^\l', '*', '\.swp$',  '\.bak$', '\~$']
" nerdtree-tabs
map <leader>n <plug>NERDTreeTabsToggle<cr>

" nerdcommenter
let g:NERDSpaceDelims=1
let g:NERDCommentEmptyLines=1
let g:NERDTrimTrailingWhitespace=1
" let g:NERDCompactSexyComs=1

" ctrlp
let g:ctrlp_map='<leader>p'
let g:ctrlp_cmd='CtrlP'
let g:ctrlp_use_caching=1
" let g:ctrlp_by_filename = 1
let g:ctrlp_clear_cache_on_exit=1
let g:ctrlp_prompt_mappings = {
  \ 'PrtSelectMove("j")':   ['<s-tab>'],
  \ 'PrtSelectMove("k")':   ['<tab>'],
  \ 'AcceptSelection("t")': ['<cr>'],
  \ 'PrtClearCache()':      ['<F5>'],
  \ 'AcceptSelection("e")': ['<2-LeftMouse>'],
  \ 'ToggleFocus()':        ['<c-j>'],
  \ 'PrtExpandDir()':       ['<c-k>'],
  \ }
let g:ctrlp_custom_ignore = {
  \'dir':'\v[\/](node_modules|platforms|plugins|target)$',
  \}
" let g:ctrlp_user_command="fzf -e -f ''"
" let g:ctrlp_user_command="find %s -type f"

" vim-go
let g:go_highlight_functions=1
let g:go_highlight_methods=1
let g:go_highlight_structs=1
let g:go_highlight_interfaces=1
let g:go_highlight_operators=1
let g:go_highlight_build_constrants=1
let g:go_gocode_unimported_packages=1
let g:go_fmt_command='goimports'
" let g:go_fmt_autosave=0

" auto-pairs
let g:AutoPairsCenterLine=0

" autoformat
" let g:formatters_go = ['goimports']
" let g:autoformat_verbosemode=1
" au BufWrite *.go :Autoformat

" tagbar
let g:tagbar_left=1
let g:tagbar_width=30
let g:tagbar_iconchars=['▸', '▾']
" au FileType go nested :TagbarOpen
au FileType go,rust,java nested call ResizeTagbar()
au VimResized *.go,*.rs call ResizeTagbar()
let g:tagbar_type_rust = {
   \ 'ctagstype' : 'rust',
   \ 'kinds' : [
       \'T:type',
       \'f:function',
       \'g:enum',
       \'s:struct',
       \'m:module',
       \'c:const',
       \'t:trait',
       \'i:impl',
   \]
\}
let g:tagbar_type_javascript = {
   \ 'ctagstype' : 'javascript',
   \ 'kinds' : [
       \'a:const',
       \'b:let',
       \'d:var',
       \'e:function',
       \'h:class',
   \],
   \ 'sro' : '.',
   	\ 'kind2scope' : {
   		\ 't' : 'ctype',
   		\ 'n' : 'ntype'
   	\ },
   	\ 'scope2kind' : {
   		\ 'ctype' : 't',
   		\ 'ntype' : 'n'
   	\ },
\}

" ycm
set completeopt -=preview
set completeopt=longest,menu
let g:ycm_collect_identifiers_from_comments_and_strings=1
let g:ycm_goto_buffer_command='new-or-existing-tab'
let g:ycm_python_binary_path='python3'
let g:ycm_global_ycm_extra_conf='~/c/.ycm_extra_conf.py'

" ale
" let g:ale_sign_column_always = 1
" let g:ale_set_highlights = 0
let g:ale_set_loclist = 0
hi ALEErrorSign ctermbg=235 ctermfg=red
hi ALEWarningSign ctermbg=235 ctermfg=190
let g:ale_lint_on_text_changed = "never"
let g:ale_linters = {
\   "go":["go build", "gometalinter"],
\   "kotlin":[],
\}
let ale_go_gometalinter_options="
\ --disable=golint
\ --disable=errcheck
\"
let ale_python_pylint_executable="python $(which pylint3)"
let ale_python_pylint_options="
\ -d bad-indentation
\ -d no-self-argument
\ -d invalid-name
\ -d missing-docstring
\ -d too-few-public-methods
\"

" ============================ Language Specific ==============================

" go
augroup go
  autocmd!
  au FileType go nnoremap <leader>r :w !go run %<cr>
  au FileType go setlocal expandtab
augroup END

" kotlin
augroup kotlin
  autocmd!
  au BufRead *.kt nnoremap <leader>r :w !kotlinc % -include-runtime -d /tmp/kt.jar && java -jar /tmp/kt.jar<cr>
  au BufWritePre *.kt call Format("kt")
  au BufRead *.kt setlocal expandtab
  au BufRead *.kt setlocal ts=4 sw=4 sts=4
augroup END

" rust
augroup rust
  autocmd!
  au FileType rust nnoremap <leader>r :w !cargo check -q && cargo run<cr>
  au FileType rust setlocal expandtab
  au FileType rust setlocal ts=2 sw=2 sts=2
augroup END

" lisp
augroup lisp
  autocmd!
  au BufRead *.lisp nnoremap <leader>r :w !sbcl --script %<cr>
  " au BufRead *.el set noautoindent
  " au BufRead *.el nnoremap <leader>r :w !~/.util/el-to-lisp < % \| sbcl --script<cr>
  " au BufRead *.el call RegisterGlobals()
  " au BufWritePre *.el call IndentEl()
augroup END

" sh
augroup sh
  autocmd!
  au BufRead *.sh nnoremap <leader>r :w !bash %<cr>
augroup END

" node.js
augroup node
  autocmd!
  au BufRead *.js nnoremap <leader>r :w !node %<cr>
  au BufWritePre *.js call Format("js")
  au BufRead *.js setlocal expandtab
augroup END

" html
augroup html
  autocmd!
  au BufWritePre *.html call Format("html")
augroup END

" css
augroup css
  autocmd!
  au BufWritePre *.css call Format("css")
augroup END

" vue
augroup vue
  autocmd!
  " au BufWritePre *.vue call Format("vue")
  au BufRead,BufWritePost *.vue syntax sync fromstart
  " au FileType vue noremap <buffer> <leader>w :%!vue-formatter<cr>:w<cr>
  au BufRead *.vue call OpenVueVsp()
  au FileType vue nnoremap <leader>t :call TurnToVue()<cr>
augroup END

" c
augroup c
  autocmd!
  au BufRead *.c nnoremap <leader>r :w !gcc % -o /tmp/c-compiled-random-string && /tmp/c-compiled-random-string<cr>
  au BufRead *.c setlocal expandtab
  au BufWritePre *.c call Format("c")
augroup END

" python
augroup python
  autocmd!
  au BufRead *.py nnoremap <leader>r :w !python3 %<cr>
  au FileType python setlocal expandtab
  au FileType python setlocal ts=2 sw=2 sts=2
  " au FileType python setlocal ts=4 sw=4 sts=4
  au BufWritePre *.py call Format("py")
augroup END

" ===============================  tagbar  ====================================
" resize tagbar according to main window's size
function ResizeTagbar()
  " debug
  " echom winwidth(0).":".winwidth(1)
  if winwidth(0) < 100
    execute "TagbarClose"
  else
    execute "TagbarOpen"
  endif
endfunction

" ===============================  vue comment  ===============================
let g:ft = ''
function! NERDCommenter_before()
  if &ft == 'vue'
    let g:ft = 'vue'
    let stack = synstack(line('.'), col('.'))
    if len(stack) > 0
      let syn = synIDattr((stack)[0], 'name')
      if len(syn) > 0
        exe 'setf ' . substitute(tolower(syn), '^vue_', '', '')
      endif
    endif
  endif
endfunction
function! NERDCommenter_after()
  if g:ft == 'vue'
    setf vue
    let g:ft = ''
  endif
endfunction

" let g:vue_disable_pre_processors=1

function OpenVueVsp()
  if winnr("$") > 1
    return
  endif
  execute "vsp"
  execute "silent! normal! \<C-W>l/<style\rztj\<C-W>h"
endfunction

function! TurnToVue()
  if winnr("$") != 2
    return
  endif
  let w = expand("<cword>")
  let l:curw = winnr()
  if l:curw == 1
    execute "normal! \<C-W>l/<style\r"
  else
    execute "normal! \<C-W>h/<template\r"
  endif
  call search(w)
endfunction

" ======================   toggle max split window   ==========================
nnoremap <leader>z :call ToggleMaxWindows()<cr>
" now only supports 2 windows, and I don't think it's necessary to support
" more windows
function! ToggleMaxWindows()
  if exists("t:maximize_session")
    execute "vsp"
    execute "normal! \<C-W>l"
    call winrestview(t:maximize_session)
    execute "normal! \<C-W>h"
    if t:curw == 2
      execute "normal! \<C-W>L"
    endif
    unlet t:maximize_session
    unlet t:curw
  else
    if winnr("$") != 2
      return
    endif
    let t:curw = winnr()
    if t:curw == 1
      execute "normal! \<C-W>l"
      let t:maximize_session = winsaveview()
      execute "normal! \<C-W>h"
    else
      execute "normal! \<C-W>h"
      let t:maximize_session = winsaveview()
      execute "normal! \<C-W>l"
    endif
    only
  endif
endfunction

" ===============================    fmt   ====================================
function Format(arg)

  if a:arg == "js"
    let l:cmd = "js-beautify -r -n -s 2 -m 2 -k -b collapse,preserve-inline"
  elseif a:arg == "py"
    let l:cmd = "yapf -i -p --style='{
                  \ based_on_style: chromium,
                  \ blank_line_before_nested_class_or_def=False,
                  \ blank_lines_around_top_level_definition=1,
                \ }'"
  elseif a:arg == "c"
    let l:cmd = "clang-format -i -style='chromium'"
  elseif a:arg == "vue"
    let l:cmd = "mhf-vue-format"
  elseif a:arg == "kt"
    let l:cmd = "ktlint -F"
  elseif a:arg == "html"
    let l:cmd = "js-beautify --html -r -n -s 2 -m 2"
  elseif a:arg == "css"
    let l:cmd = "js-beautify --css -r -n -s 2"
  elseif a:arg == "go"
    let l:cmd = "goimports -w"
  endif

  let l:curw = winsaveview()

  " Write current unsaved buffer to a temp file
  let l:tmpname = tempname()
  call writefile(getline(1, '$'), l:tmpname)
  call system(l:cmd ." ". l:tmpname)

  try | silent undojoin | catch | endtry

  " Replace current file with temp file, then reload buffer
  let old_fileformat = &fileformat
  if exists("*getfperm")
    " save old file permissions
    let original_fperm = getfperm(expand('%'))
  endif
  call rename(l:tmpname, expand('%'))
  " restore old file permissions
  if exists("*setfperm") && original_fperm != ''
    call setfperm(expand('%'), original_fperm)
  endif
  silent edit!
  let &fileformat = old_fileformat
  let &syntax = &syntax

  call winrestview(l:curw)

endfunction

" ================================= fold ======================================
" augroup remember_folds
  " autocmd!
  " autocmd BufWritePost *
    " \   if expand('%') != '' && &buftype !~ 'nofile'
    " \|      mkview
    " \|  endif
    " autocmd BufRead *
    " \   if expand('%') != '' && &buftype !~ 'nofile'
    " \|      silent loadview
    " \|  endif
" augroup END

hi Folded cterm=bold ctermbg=none ctermfg=166
hi FoldColumn cterm=bold ctermbg=235 ctermfg=166
set foldcolumn=1
set foldtext=MyFoldText()
function MyFoldText()
  let line = getline(v:foldstart) . repeat(" ", winwidth(0))
  return line
endfunction

nnoremap zi :call FoldIndent()<cr>
function FoldIndent()
  let curLineNo = line(".")
  let maxLineNo = line("$")
  let curIndent = indent(curLineNo)
  let n = 0

  let i = curLineNo + 1
  while i <= maxLineNo
    if len(getline(i)) > 0
      if curIndent < indent(i)
          let n += 1
      else
        break
      endif
    endif
    let i += 1
  endwhile

  if n > 0
    execute "normal! zf" . n . "\r"
  endif
endfunction

" =============================== .el file ====================================
" indent .el files
function IndentEl()
  let s:totalNumLines = line("$")
  " don't indent when the total number of lines changes
  if s:totalNumLines != len(g:lines_mhf)
    let g:lines_mhf = getline(1, s:totalNumLines)
  else
    let s:lines = getline(1, s:totalNumLines)
    let s:delta = 0
    let s:indentStd = 0
    let s:toBeIndentedList = []

    " iterate over the lines
    for s:i in range(s:totalNumLines)
      let s:newLine = getline(s:i + 1)
      let s:oldLine = g:lines_mhf[s:i]

      " skip blank lines
      if len(s:newLine) == 0
        continue
      endif

      if s:delta != 0
        " get the range that need to be indented
        if IndentNum(s:oldLine) > s:indentStd
          call add(s:toBeIndentedList, s:i + 1)
        endif
      endif

      " get the first line that changes
      if s:oldLine != s:newLine
        " after getting the range, check to see if another line is changed
        " if so, exit from the function
        if s:delta != 0
          return
        endif
        " get the first index where the two lines are different
        let s:oldIndent = IndentNum(s:oldLine)
        let s:newIndent = IndentNum(s:newLine)
        let s:oldPureLine = strpart(s:oldLine, s:oldIndent, len(s:oldLine) - s:oldIndent)
        let s:newPureLine = strpart(s:newLine, s:newIndent, len(s:newLine) - s:newIndent)
        
        " decide whether to indent
        let s:ocn = stridx(s:oldPureLine, s:newPureLine)
        let s:nco = stridx(s:newPureLine, s:oldPureLine)
        let s:ocnIsNco = s:ocn == 0 && s:nco == 0
        if s:ocn != -1 || s:nco != -1
          " if changes are from front of the line
          if s:ocn > 0 || s:nco > 0 || s:ocnIsNco
            let s:delta = UtfLen(s:newLine) - UtfLen(s:oldLine)
            let s:indentStd = s:oldIndent
            " save newLine to g:lines_mhf[]
            let g:lines_mhf[s:i] = s:newLine
            " after get the delta, continue the loop
            continue
          endif
        endif
      endif
    endfor

    " indent the lines
    let s:j = 0
    let s:lenToBeIndentedList = len(s:toBeIndentedList)
    try
      " append the comming change onto the end of the previous change
      " NOTE: Fails if previous change doesn't exist
      undojoin
      while s:j < s:lenToBeIndentedList
        let s:oldLine = g:lines_mhf[s:toBeIndentedList[s:j] - 1]
        let s:oldIndent = IndentNum(s:oldLine)
        let s:oldPureLine = strpart(s:oldLine, s:oldIndent, len(s:oldLine) - s:oldIndent)
        let s:newIndent = s:oldIndent + s:delta
        let s:newLine = repeat(" ", s:newIndent).s:oldPureLine

        call setline(s:toBeIndentedList[s:j], s:newLine)
        let g:lines_mhf[s:toBeIndentedList[s:j] - 1] = s:newLine
        let s:j += 1
      endwhile
    catch
    endtry
  endif

endfunction

" register some global variables for el-indent
function RegisterGlobals()
  let s:totalNumLines = line("$")
  let g:lines_mhf = getline(1, s:totalNumLines)
endfunction

" get indent num of a string
function IndentNum(str)
  if len(a:str) != 0
    for i in range(len(a:str))
      if a:str[i] != " "
        return i
      endif
    endfor
  endif
endfunction

" get length of a utf-8 encoded string
function UtfLen(str)
  return len(a:str)
endfunction
