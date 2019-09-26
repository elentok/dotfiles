if (has("termguicolors"))
  set termguicolors
endif

if !exists('g:gui_oni')
  set background=dark
  let g:one_allow_italics = 1
  " silent! colorscheme one
  " silent! call one#highlight('Folded', '555555', '111111', '')
  " silent! call one#highlight('VertSplit', '', '5c6370', 'none')
  " silent! call one#highlight('StatusLine', '000000', '696c77', '')
  silent! colorscheme challenger_deep

  hi Folded guibg=#524458

  let g:elentok_colors_initialized = 1
endif
