augroup Elentok_FileTypes
  autocmd!
  autocmd FileType go setlocal ts=4 sw=4 softtabstop=4 noexpandtab nolist
  autocmd Filetype python setlocal ts=4 softtabstop=4 shiftwidth=4
  autocmd FileType gitcommit,hgcommit,markdown setlocal spell spellcapcheck=
  autocmd FileType gitcommit,hgcommit setlocal comments=fb:-,fb:* textwidth=80
  autocmd FileType vim setlocal nobomb
augroup END
