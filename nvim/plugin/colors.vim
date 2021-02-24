if (has("termguicolors"))
  set termguicolors
endif

if !exists('g:gui_oni')
  set background=dark
  let g:embark_terminal_italics = 1
  silent! colorscheme embark
  hi Folded guibg=black
endif
