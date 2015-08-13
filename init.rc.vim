"---------------------------------------------------------------------------
" Initialize:
"

function! s:clone_github_rep(url, path)
      execute printf('!git clone %s://github.com/'.a:url,
            \ (exists('$http_proxy') ? 'https' : 'git'))
            \ a:path
endfunction

" Use English interface.
if IsWindows()
  " For Windows.
  language message en
else
  " For Linux.
  language message C
endif

" Use ',' instead of '\'.
" It is not mapped with respect well unless I set it before setting for plug in.
" Use <Leader> in global plugin.
let g:mapleader = ','
" Use <LocalLeader> in filetype plugin.
let g:maplocalleader = 'm'

" Release keymappings for plug-in.
nnoremap ;  <Nop>
xnoremap ;  <Nop>
nnoremap m  <Nop>
xnoremap m  <Nop>
nnoremap ,  <Nop>
xnoremap ,  <Nop>

" Smart space mapping.
" Notice: when starting other <Space> mappings in noremap, disappeared [Space].
nmap  <Space>   [Space]
xmap  <Space>   [Space]
nnoremap  [Space]   <Nop>
xnoremap  [Space]   <Nop>

nmap <C-@>  [Shell]
cmap <C-@>  [Shell]
nnoremap [Shell] <Nop>
cnoremap [Shell] <Nop>

nmap <C-t>  [Toggle]
nnoremap [Toggle] <Nop>

nnoremap    [Window]   <Nop>
nmap    <C-w> [Window]

if IsWindows()
  " Exchange path separator.
  set shellslash
endif

let $CACHE = expand('~/.cache')

if !isdirectory(expand($CACHE))
  call mkdir(expand($CACHE), 'p')
endif

" Set augroup.
augroup MyAutoCmd
  autocmd!
augroup END

let s:neobundle_dir = expand('$CACHE/neobundle')

if has('vim_starting') "{{{
  " Set runtimepath.
  if IsWindows()
    let &runtimepath = join([
          \ expand('~/.vim'),
          \ expand('$VIM/runtime'),
          \ expand('~/.vim/after')], ',')
  endif

  " Load neobundle.
  if isdirectory('neobundle.vim')
    set runtimepath^=neobundle.vim
  elseif finddir('neobundle.vim', '.;') != ''
    execute 'set runtimepath^=' . finddir('neobundle.vim', '.;')
  elseif &runtimepath !~ '/neobundle.vim'
    if !isdirectory(s:neobundle_dir.'/neobundle.vim')
	call s:clone_github_rep('Shougo/neobundle.vim.git', s:neobundle_dir.'/neobundle.vim')
    endif

    execute 'set runtimepath^=' . s:neobundle_dir.'/neobundle.vim'
  endif
endif
"}}}

let g:neobundle#default_options = {}
" let g:neobundle#default_options._ = { 'verbose' : 1, 'focus' : 1 }

"---------------------------------------------------------------------------
" Disable default plugins

" Disable menu.vim
if has('gui_running')
  set guioptions=Mc
endif

" Disable GetLatestVimPlugin.vim
if !&verbose
  let g:loaded_getscriptPlugin = 1
endif

let g:loaded_netrwPlugin = 1
let g:loaded_matchparen = 1
let g:loaded_2html_plugin = 1
let g:loaded_vimballPlugin = 1
