"---------------------------------------------------------------------------
" neosnippet.vim
"

imap <silent><C-l>    <Plug>(neosnippet_expand_or_jump)
smap <silent><C-l>     <Plug>(neosnippet_expand_or_jump)
xmap <silent>L     <Plug>(neosnippet_start_unite_snippet_target)
imap <silent><C-j>     <Plug>(neosnippet_jump)
smap <silent><C-j>     <Plug>(neosnippet_jump)
" imap <silent>G     <Plug>(neosnippet_expand)
" imap <silent>S     <Plug>(neosnippet_start_unite_snippet)
xmap <silent>o     <Plug>(neosnippet_register_oneshot_snippet)
xmap <silent>U     <Plug>(neosnippet_expand_target)

" let g:neosnippet#enable_snipmate_compatibility = 1

" let g:snippets_dir = '~/.vim/snippets/,~/.vim/bundle/snipmate/snippets/'
let g:neosnippet#snippets_directory = '~/.vim/snippets'
