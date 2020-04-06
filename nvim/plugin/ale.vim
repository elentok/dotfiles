let g:ale_fix_on_save = 1
let g:ale_linters = {
      \ 'typescript': ['eslint', 'tsserver']
      \ }

let g:ale_fixers = {
      \ 'typescript': ['eslint']}

set omnifunc=ale#completion#OmniFunc

nnoremap gd :ALEGoToDefinition<cr>
nnoremap K :ALEHover<cr>
