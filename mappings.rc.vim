"---------------------------------------------------------------------------
" Key-mappings:
"

" Useful save mappings.
nnoremap <silent> <Leader><Leader> :<C-u>update<CR>

" Easily edit .vimrc and .gvimrc "{{{
map <Leader>ev <SID>(edit_vimrc)
noremap <silent> <SID>(edit_vimrc) :<C-u>edit $MYVIMRC<CR>
" Load .gvimrc after .vimrc edited at GVim.
map <Leader>rv <SID>(reload_vimrc)
noremap <silent> <SID>(reload_vimrc) :<C-u>source $MYVIMRC \|
      \ echo "source $MYVIMRC"<CR>
"}}}

" Change current directory.
map <Leader>cd <SID>(change_current_directory)
noremap <silent> <SID>(change_current_directory) :<C-u>call <SID>cd_buffer_dir()<CR>
function! s:cd_buffer_dir() "{{{
  let filetype = getbufvar(bufnr('%'), '&filetype')
  if filetype ==# 'vimfiler'
    let dir = getbufvar(bufnr('%'), 'vimfiler').current_dir
  elseif filetype ==# 'vimshell'
    let dir = getbufvar(bufnr('%'), 'vimshell').save_dir
  else
    let dir = isdirectory(bufname('%')) ?
          \ bufname('%') : fnamemodify(bufname('%'), ':p:h')
  endif

  execute 'lcd' fnameescape(dir)
endfunction"}}}

" Indent
nnoremap > >>
nnoremap < <<
xnoremap > >gv
xnoremap < <gv

if has('clipboard')
  xnoremap <silent> y "*y:let [@+,@"]=[@*,@*]<CR>
endif
"}}}

" Insert mode keymappings: "{{{
" <C-t>: insert tab.
inoremap <C-t>  <C-v><TAB>
" <C-d>: delete char.
inoremap <C-d>  <Del>
" <C-a>: move to head.
inoremap <silent><C-a>  <C-o>^
" Enable undo <C-w> and <C-u>.
inoremap <C-w>  <C-g>u<C-w>
inoremap <C-u>  <C-g>u<C-u>

""" TODO check this
if has('gui_running')
  inoremap <ESC> <ESC>
endif
"}}}

" Command-line mode keymappings:"{{{
" <C-a>, A: move to head.
cnoremap <C-a>          <Home>
" <C-b>: previous char.
cnoremap <C-b>          <Left>
" <C-d>: delete char.
cnoremap <C-d>          <Del>
" <C-e>, E: move to end.
cnoremap <C-e>          <End>
" <C-f>: next char.
cnoremap <C-f>          <Right>
" <C-n>: next history.
cnoremap <C-n>          <Down>
" <C-p>: previous history.
cnoremap <C-p>          <Up>
" <C-k>, K: delete to end.
cnoremap <C-k> <C-\>e getcmdpos() == 1 ?
      \ '' : getcmdline()[:getcmdpos()-2]<CR>
" <C-y>: paste.
cnoremap <C-y>          <C-r>*
"}}}

" Command line buffer."{{{
nnoremap <SID>(command-line-enter) q:
xnoremap <SID>(command-line-enter) q:

nmap ;;  <SID>(command-line-enter)
xmap ;;  <SID>(command-line-enter)

autocmd MyAutoCmd CmdwinEnter * call s:init_cmdwin()
autocmd MyAutoCmd CmdwinLeave * let g:neocomplcache_enable_auto_select = 1

function! s:init_cmdwin()
  let g:neocomplcache_enable_auto_select = 0
  let b:neocomplcache_sources_list = ['vim_complete']

  nnoremap <buffer><silent> q :<C-u>quit<CR>
  nnoremap <buffer><silent> <TAB> :<C-u>quit<CR>
  inoremap <buffer><expr><CR> neocomplete#close_popup()."\<CR>"
  inoremap <buffer><expr><C-h> col('.') == 1 ?
        \ "\<ESC>:quit\<CR>" : neocomplete#cancel_popup()."\<C-h>"
  inoremap <buffer><expr><BS> col('.') == 1 ?
        \ "\<ESC>:quit\<CR>" : neocomplete#cancel_popup()."\<C-h>"

  " Completion.
  inoremap <buffer><expr><TAB>  pumvisible() ?
        \ "\<C-n>" : "\<TAB>"

  " Remove history lines.
  silent execute printf("1,%ddelete _", min([&history - 20, line("$") - 20]))
  call cursor(line('$'), 0)

  startinsert!
endfunction"}}}

" [Toggle] useful commands "{{{

" Toggle relativenumber.
map [Toggle]. <SID>(toggle_relativenumber)
noremap <silent> <SID>(toggle_relativenumber)
      \ :<C-u>call ToggleOption('relativenumber')<CR>
map [Toggle]p <SID>(toggle_pastemode)
noremap <silent> <SID>(toggle_pastemode)
      \ :<C-u>call ToggleOption('paste')<CR>:set mouse=<CR>
" Toggle highlight.
map [Toggle]/ <SID>(toggle_hlsearch)
noremap <silent> <SID>(toggle_hlsearch)
      \ :<C-u>call ToggleOption('hlsearch')<CR>
" Toggle cursorline.
map [Toggle]cl <SID>(toggle_cursorline)
noremap <silent> <SID>(toggle_cursorline)
      \ :<C-u>call ToggleOption('cursorline')<CR>
" Set autoread.
map [Toggle]ar <SID>(toggle_autoread)
noremap <SID>(toggle_autoread)
      \ :<C-u>setlocal autoread<CR>
" Set spell check.
map [Toggle]sp <SID>(toggle_spellcheck)
noremap <SID>(toggle_spellcheck)
      \ :<C-u>call ToggleOption('spell')<CR>
map [Toggle]w <SID>(toggle_wrap)
noremap <SID>(toggle_wrap)
      \ :<C-u>call ToggleOption('wrap')<CR>

" Exchange gj and gk to j and k. "{{{
command! -nargs=? -bar -bang ToggleGJK call s:ToggleGJK()
map [Toggle]gj <SID>(toggle_gj_virtual_move)
noremap <silent> <SID>(toggle_gj_virtual_move) :<C-u>ToggleGJK<CR>
function! s:ToggleGJK()
  if exists('b:enable_mapping_gjk') && b:enable_mapping_gjk
    let b:enable_mapping_gjk = 0
    noremap <buffer> j j
    noremap <buffer> k k
    noremap <buffer> gj gj
    noremap <buffer> gk gk

    xnoremap <buffer> j j
    xnoremap <buffer> k k
    xnoremap <buffer> gj gj
    xnoremap <buffer> gk gk
  else
    let b:enable_mapping_gjk = 1
    noremap <buffer> j gj
    noremap <buffer> k gk
    noremap <buffer> gj j
    noremap <buffer> gk k

    xnoremap <buffer> j gj
    xnoremap <buffer> k gk
    xnoremap <buffer> gj j
    xnoremap <buffer> gk k
  endif
endfunction"}}}
"}}}

" Change tab width. "{{{
" nnoremap <silent> [Space]t2 :<C-u>setl shiftwidth=2 softtabstop=2<CR>
" nnoremap <silent> [Space]t4 :<C-u>setl shiftwidth=4 softtabstop=4<CR>
" nnoremap <silent> [Space]t8 :<C-u>setl shiftwidth=8 softtabstop=8<CR>
"}}}

" Toggle options. "{{{
function! ToggleOption(option_name)
  execute 'setlocal' a:option_name.'!'
  execute 'setlocal' a:option_name.'?'
endfunction  "}}}
" Toggle variables. "{{{
function! ToggleVariable(variable_name)
  if eval(a:variable_name)
    execute 'let' a:variable_name.' = 0'
  else
    execute 'let' a:variable_name.' = 1'
  endif
  echo printf('%s = %s', a:variable_name, eval(a:variable_name))
endfunction  "}}}
"}}}

" [Window]: Windows and buffers(High priority) "{{{
" Cool window motion
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

" The prefix key.
map [Window]s <SID>(split_window_nicely)
noremap <silent> <SID>(split_window_nicely) :<C-u>call <SID>split_nicely()<CR>
map [Window]v <SID>(split_window_verticaly)
noremap <silent> <SID>(split_window_verticaly) :<C-u>vsplit<CR>
map [Window]c <SID>(close_window)
noremap <silent> <SID>(close_window)  :<C-u>call <SID>smart_close()<CR>
map [Window]o <SID>(only_window)
noremap <silent> <SID>(only_window)  :<C-u>only<CR>

nnoremap <silent> q :<C-u>call <SID>smart_close()<CR>

nnoremap <silent> <S-Tab> gt

" Toggle quickfix window.
map [Window]q <SID>(toggle_quickfix_window)
noremap <silent> <SID>(toggle_quickfix_window)
      \ :<C-u>call <SID>toggle_quickfix_window()<CR>
function! s:toggle_quickfix_window()
  let _ = winnr('$')
  cclose
  if _ == winnr('$')
    copen
    setlocal nowrap
    setlocal whichwrap=b,s
  endif
endfunction

function! s:smart_close()
  if winnr('$') != 1
    close
  else
    call s:alternate_buffer()
  endif
endfunction

" Split nicely."{{{
command! SplitNicely call s:split_nicely()
function! s:split_nicely()
  " Split nicely.
  if winwidth(0) > 2 * &winwidth
    vsplit
  else
    split
  endif
  wincmd p
endfunction
"}}}
" Delete current buffer."{{{
" Force delete current buffer.
nnoremap <silent> [Window]D  :<C-u>call <SID>CustomBufferDelete(1)<CR>
function! s:CustomBufferDelete(is_force)
  let current = bufnr('%')

  call s:alternate_buffer()

  if a:is_force
    silent! execute 'bdelete! ' . current
  else
    silent! execute 'bdelete ' . current
  endif
endfunction
"}}}
function! s:alternate_buffer() "{{{
  let listed_buffer_len = len(filter(range(1, bufnr('$')),
        \ 's:buflisted(v:val) && getbufvar(v:val, "&filetype") !=# "unite"'))
  if listed_buffer_len <= 1
    enew
    return
  endif

  let cnt = 0
  let pos = 1
  let current = 0
  while pos <= bufnr('$')
    if s:buflisted(pos)
      if pos == bufnr('%')
        let current = cnt
      endif

      let cnt += 1
    endif

    let pos += 1
  endwhile

  if current > cnt / 2
    bprevious
  else
    bnext
  endif
endfunction"}}}
function! s:buflisted(bufnr) "{{{
  return exists('t:unite_buffer_dictionary') ?
        \ has_key(t:unite_buffer_dictionary, a:bufnr) && buflisted(a:bufnr) :
        \ buflisted(a:bufnr)
endfunction"}}}
"}}}

" Change basic commands "{{{
nnoremap Y y$
nnoremap x "_x
"}}}

" Disable Ex-mode.
nnoremap Q  q

" Jump mark can restore column."{{{
" Useless command.
nnoremap M  m
"}}}

" Smart <C-f>, <C-b>.
nnoremap <silent> <C-f> <C-f>
nnoremap <silent> <C-b> <C-b>

" Like gv, but select the last changed text.
" inoremap gc  `[v`]
" Specify the last changed text as {motion}.
" vnoremap <silent> gc  :<C-u>normal gc<CR>
" onoremap <silent> gc  :<C-u>normal gc<CR>

" Smart }."{{{
nnoremap <silent> } :<C-u>call ForwardParagraph()<CR>
onoremap <silent> } :<C-u>call ForwardParagraph()<CR>
xnoremap <silent> } <Esc>:<C-u>call ForwardParagraph()<CR>mzgv`z
function! ForwardParagraph()
  let cnt = v:count ? v:count : 1
  let i = 0
  while i < cnt
    if !search('^\s*\n.*\S','W')
      normal! G$
      return
    endif
    let i = i + 1
  endwhile
endfunction
"}}}

" Smart home and smart end."{{{
nnoremap <silent> gh  :<C-u>call SmartHome('n')<CR>
nnoremap <silent> gl  :<C-u>call SmartEnd('n')<CR>
xnoremap <silent> gh  <ESC>:<C-u>call SmartHome('v')<CR>
xnoremap <silent> gl  <ESC>:<C-u>call SmartEnd('v')<CR>
" Smart home function"{{{
function! SmartHome(mode)
  let curcol = col('.')

  if &wrap
    normal! g^
  else
    normal! ^
  endif
  if col('.') == curcol
    if &wrap
      normal! g0
    else
      normal! 0
    endif
  endif

  if a:mode == "v"
    normal! msgv`s
  endif

  return ""
endfunction"}}}

" Smart end function"{{{
function! SmartEnd(mode)
  let curcol = col('.')
  let lastcol = a:mode ==# 'i' ? col('$') : col('$') - 1

  " Gravitate towards ending for wrapped lines
  if curcol < lastcol - 1
    call cursor(0, curcol + 1)
  endif

  if curcol < lastcol
    if &wrap
      normal! g$
    else
      normal! $
    endif
  else
    normal! g_
  endif

  " Correct edit mode cursor position, put after current character
  if a:mode == "i"
    call cursor(0, col(".") + 1)
  endif

  if a:mode == "v"
    normal! msgv`s
  endif

  return ""
endfunction "}}}
"}}}

" Select rectangle.
xnoremap r <C-v>
" Select until end of current line in visual mode.
xnoremap v $h

" Paste next line.
nnoremap <silent> gp o<ESC>p^
nnoremap <silent> gP O<ESC>P^
xnoremap <silent> gp o<ESC>p^
xnoremap <silent> gP O<ESC>P^

" Folding."{{{
" If press h on head, fold close.
"nnoremap <expr> h col('.') == 1 && foldlevel(line('.')) > 0 ? 'zc' : 'h'
" If press l on fold, fold open.
nnoremap <expr> l foldclosed(line('.')) != -1 ? 'zo0' : 'l'
" If press h on head, range fold close.
"xnoremap <expr> h col('.') == 1 && foldlevel(line('.')) > 0 ? 'zcgv' : 'h'
" If press l on fold, range fold open.
xnoremap <expr> l foldclosed(line('.')) != -1 ? 'zogv0' : 'l'
"}}}

" Substitute.
xnoremap s :s//g<Left><Left>

" Easy escape."{{{
inoremap jj           <ESC>
" inoremap <expr> j       getline('.')[col('.') - 2] ==# 'j' ? "\<BS>\<ESC>" : 'j'
cnoremap <expr> j       getcmdline()[getcmdpos()-2] ==# 'j' ? "\<BS>\<C-c>" : 'j'
onoremap jj           <ESC>

inoremap j<CR>     j
onoremap j<CR>     j
"}}}

" Execute countable 'n.'.
" EXAMPLE: 3@n
let @n='n.'

" Move to top/center/bottom.
noremap <expr> zz (winline() == (winheight(0)+1)/ 2) ?
      \ 'zt' : (winline() == &scrolloff+1)? 'zb' : 'zz'

" Clear highlight.
nnoremap <ESC><ESC> :nohlsearch<CR>:match<CR>
"}}}

" Improved increment.
nmap <C-a> <SID>(increment)
nmap <C-x> <SID>(decrement)
nnoremap <silent> <SID>(increment)    :AddNumbers 1<CR>
nnoremap <silent> <SID>(decrement)   :AddNumbers -1<CR>
command! -range -nargs=1 AddNumbers
      \ call s:add_numbers((<line2>-<line1>+1) * eval(<args>))
function! s:add_numbers(num)
  let prev_line = getline('.')[: col('.')-1]
  let next_line = getline('.')[col('.') :]
  let prev_num = matchstr(prev_line, '\d\+$')
  if prev_num != ''
    let next_num = matchstr(next_line, '^\d\+')
    let new_line = prev_line[: -len(prev_num)-1] .
          \ printf('%0'.len(prev_num . next_num).'d',
          \    max([0, prev_num . next_num + a:num])) . next_line[len(next_num):]
  else
    let new_line = prev_line . substitute(next_line, '\d\+',
          \ "\\=printf('%0'.len(submatch(0)).'d',
          \         max([0, submatch(0) + a:num]))", '')
  endif

  if getline('.') !=# new_line
    call setline('.', new_line)
  endif
endfunction
