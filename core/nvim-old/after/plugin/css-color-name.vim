command! -nargs=+ CSScolor call CSScolor("<args>")

noremap <Leader>co0 :CSScolor '<c-r>0'<cr>
noremap <Leader>co* :CSScolor '<c-r>*'<cr>

function! CSScolor(color)
  let format="sass"
  if &filetype == "less"
    let format="less"
  endif
  let css=system("color2css.py " . a:color . " --format " . format)
  let @c=css
  normal "cp
endfunction
