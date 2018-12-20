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
let g:autoformat_filetypes = ['json', 'javascript', 'css', 'scss', 'typescript', 'java', 'markdown']

func! AutoFormat()
  if index(g:autoformat_filetypes, &filetype) != -1
    CocCommand prettier.formatFile
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

" Language Servers {{{1

" Better display for messages
set cmdheight=2

" Smaller updatetime for CursorHold & CursorHoldI
set updatetime=300

inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

" Use <C-x></C-u> to complete custom sources, including emoji, include and words
imap <silent> <C-x><C-u> <Plug>(coc-complete-custom)

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use <c-space> for trigger completion.
inoremap <silent><expr> <c-space> coc#refresh()

" Use <cr> for confirm completion.
inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"

" Use `[c` and `]c` for navigate diagnostics
nmap <silent> [c <Plug>(coc-diagnostic-prev)
nmap <silent> ]c <Plug>(coc-diagnostic-next)

" Remap keys for gotos
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gR <Plug>(coc-references)
nmap <silent> gr <Plug>(coc-rename)
nmap <silent> gA <Plug>(coc-codeaction)

" Use K for show documentation in preview window
nnoremap <silent> K :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if &filetype == 'vim'
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction


augroup Elentok_COC
  autocmd!
  " Highlight symbol under cursor on CursorHold
  autocmd CursorHold * silent call CocActionAsync('highlight')
  " Show signature help while editing
  autocmd CursorHoldI,CursorMovedI * silent! call CocAction('showSignatureHelp')
  " Update signature help on jump placeholder
  autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup END

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
