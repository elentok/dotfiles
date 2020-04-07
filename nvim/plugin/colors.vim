if (has("termguicolors"))
  set termguicolors
endif

if !exists('g:gui_oni')
  set background=dark
  silent! colorscheme tender

  hi Folded guibg=#524458

  let g:elentok_colors_initialized = 1
endif
