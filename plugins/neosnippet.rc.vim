"---------------------------------------------------------------------------
" neosnippet.vim
"

smap <silent><C-l>     <Plug>(neosnippet_expand_or_jump)
xmap <silent>L     <Plug>(neosnippet_start_unite_snippet_target)
xmap <silent>o     <Plug>(neosnippet_register_oneshot_snippet)

" SuperTab like snippets' behavior.
imap <expr><TAB> neosnippet#expandable_or_jumpable() ?
\ "\<Plug>(neosnippet_expand_or_jump)"
\: pumvisible() ? "\<C-n>" : "\<TAB>"
smap <expr><TAB> neosnippet#expandable_or_jumpable() ?
\ "\<Plug>(neosnippet_expand_or_jump)"
\: "\<TAB>"
" " <TAB>: expand

" let g:neosnippet#enable_snipmate_compatibility = 1

" let g:snippets_dir = '~/.vim/snippets/,~/.vim/bundle/snipmate/snippets/'
let g:neosnippet#snippets_directory = '~/.vim/snippets'
