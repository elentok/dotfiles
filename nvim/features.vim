" vim: foldmethod=marker

" Tab: Cd to buffer root {{{1

noremap <Leader>tcd :TabCdToBufRoot<cr>

command! TabCdToBufRoot call TabCdToBufRoot()

function! BufGetRoot()
  return systemlist("git-root '" . expand("%") . "'")[0]
endfunction

function! TabCdToBufRoot()
  let root = BufGetRoot()
  exec "tcd " . root
  echomsg "Changed tab directory to: " . root
endfunction

" Automatic formatting (prettier) {{{1
let g:autoformat_filetypes = [
      \ 'json', 'javascript', 'css', 'scss', 'typescript', 'typescript.tsx',
      \ 'java', 'markdown', 'yaml']

func! AutoFormat()
  if index(g:autoformat_filetypes, &filetype) != -1
    call CocAction('format')
  endif
endfunc

augroup Elentok_Neoformat
  autocmd!
  autocmd BufWritePre * call AutoFormat()
augroup END

" Copy over SSH {{{1

" These functions will run on the ssh server (not the client).
" On the client you need to start the clipboard listening server:
"
"   while (true); do nc -l 7777 | pbcopy; done
"
" Or:
"
"   daemon start clipboard clipboard-server

func! CopyThroughSSH() range
  normal gv"sy
  call system("nc -q0 localhost 7777", @s)
endfunc

vnoremap <Leader>ys :call CopyThroughSSH()<cr>



" Git {{{1

command! Gca Gcommit --amend

" Go To Project {{{1
function! Proj(dir)
  tabe
  exec "tcd " . a:dir
endfunction

command! -complete=dir -nargs=+ Proj call Proj("<args>")

command! FZFProj call fzf#run({
      \ "source": "list-projects",
      \ "options": "--prompt 'Project> '",
      \ "sink": 'Proj'})

noremap <Leader>gp :FZFProj<cr>

" Automatically set working directory {{{1
function! TermSetWorkDir(dir)
  let b:working_dir = a:dir
  exec 'cd ' . b:working_dir
endfunction

function! SetBufferWorkingDirectory()
  if exists('b:working_dir') && b:working_dir != ''
    if exists('g:debug_autocd')
      echomsg 'AutoCD (cached): ' . b:working_dir
    endif
    exec 'cd ' . b:working_dir
    return
  endif

  if &buftype ==# 'terminal'
    return
  end

  if match(bufname(''), '^coc:.*') >= 0
    return
  end

  if !exists('b:working_dir')
    let b:working_dir = FindWorkingDirectory()
  endif

  if exists('g:debug_autocd')
    echomsg 'AutoCD: ' . b:working_dir
  endif

  exec 'cd ' . b:working_dir
endfunction

function! FindWorkingDirectory()
  let buffer_dir = expand('%:p:h')

  " remove '.git/*' suffix (git rev-parse doesn't work well inside the .git/ dir)
  let buffer_dir = substitute(buffer_dir, '\v/?\.git($|/.*$)', '', '')

  exec 'lcd ' . buffer_dir

  let git_dir = system('git rev-parse --show-toplevel')
  let is_git_dir = empty(matchstr(git_dir, '^fatal:.*'))
  if is_git_dir
    return git_dir
  endif

  return getcwd()
endfunction

augroup Elentok_AutoWorkingDirectory
  autocmd!
  autocmd BufRead * call SetBufferWorkingDirectory()
  autocmd WinEnter * call SetBufferWorkingDirectory()
augroup END

" Redraw when gaining focus {{{1

if exists('#FocusGained')
  augroup Elentok_AutoRedraw
    autocmd!
    autocmd FocusGained * redraw!
  augroup END
endif

" Color Picker {{{1
" Plugin: 'KabbAmine/vCoolor.vim'
let g:vcoolor_lowercase = 1
let g:vcoolor_disable_mappings = 1

noremap ,cp :VCoolor<cr>

" FZF Floating Window {{{1

if exists('*nvim_create_buf')
  let $FZF_DEFAULT_OPTS='--layout=reverse'
  let g:fzf_layout = { 'window': 'call FloatingFZF()' }

  function! FloatingFZF()
    let buf = nvim_create_buf(v:false, v:true)
    call setbufvar(buf, '&signcolumn', 'no')

    let height = &lines / 2
    let width = float2nr(&columns - (&columns * 2 / 4))
    let col = float2nr((&columns - width) / 2)

    let opts = {
          \ 'relative': 'editor',
          \ 'row': &lines / 5,
          \ 'col': col,
          \ 'width': width,
          \ 'height': height
          \ }

    call nvim_open_win(buf, v:true, opts)
  endfunction
endif
