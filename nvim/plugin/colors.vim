if (has("termguicolors"))
  set termguicolors
endif

if !exists('g:gui_oni')
  set background=dark
  let g:embark_terminal_italics = 1
  silent! colorscheme embark
  hi Folded guibg=black
  hi StatusLine guibg=#126888
  hi StatusLineNC guibg=#003455
  hi VertSplit guifg=#126888
endif
