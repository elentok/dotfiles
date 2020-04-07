let g:ale_fix_on_save = 1
let g:ale_sign_error = '✘'
let g:ale_sign_warning = '⚠'
let g:ale_virtualtext_cursor = 1
let g:ale_linters = {
      \ 'typescript': ['eslint', 'tsserver']
      \ }

let g:ale_fixers = {
      \ 'typescript': ['prettier'],
      \ 'scss': ['prettier']
      \ }

set omnifunc=ale#completion#OmniFunc

nnoremap gd :ALEGoToDefinition<cr>
nnoremap K :ALEHover<cr>
