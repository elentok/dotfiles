let test#python#pyunit#file_pattern = '\v_test.py$'
let test#python#pyunit#executable = 'python3 -m unittest'
let test#strategy = 'neovim'

" disable jedi-vim's completion in favor of deoplete-jedi
let g:jedi#completions_enabled = 0
