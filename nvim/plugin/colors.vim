if (has("termguicolors"))
  set termguicolors
endif

if !exists('g:gui_oni')
  set background=dark
  let g:afterglow_italic_comments=1
  silent! colorscheme afterglow
  hi Folded guibg=black
endif
