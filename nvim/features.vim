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
let g:neoformat_enabled_javascript = ['prettier']
let g:neoformat_enabled_json = ['prettier']
let g:neoformat_enabled_scss = ['prettier']
let g:neoformat_enabled_css = ['prettier']
let g:neoformat_java_google = {
      \ 'exe': 'google-java-format',
      \ 'args': ['-'],
      \ 'stdin': 1}
let g:neoformat_enabled_java = ['google']

let g:autoformat_filetypes = ['json', 'javascript', 'css', 'scss', 'typescript', 'java']

func! AutoFormat()
  if exists("b:af") && b:af == 0
    return
  endif
  if index(g:autoformat_filetypes, &filetype) != -1
    silent Neoformat
  endif
endfunc

func! AutoFormatToggle()
  if exists("b:af")
    let b:af = !b:af
  else
    let b:af = 0
  end
  echo "AutoFormat: " . (b:af ? "on" : "off")
endfunc

augroup Elentok_Neoformat
  autocmd!
  autocmd BufWritePre * call AutoFormat()
augroup END

nnoremap ,taf :call AutoFormatToggle()<cr>

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

" Use K for show documentation in preview window
nnoremap <silent> K :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if &filetype == 'vim'
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction

" Show signature help while editing
autocmd CursorHoldI,CursorMovedI * silent! call CocAction('showSignatureHelp')

" Go To Project {{{1
function! Proj(dir)
  tabe
  exec "tcd " . a:dir
  FZF
endfunction

command! -complete=dir -nargs=+ Proj call Proj("<args>")

command! FZFProj call fzf#run({
      \ "source": "list-projects",
      \ "options": "--prompt 'Project> '",
      \ "sink": 'Proj'})

noremap <Leader>gp :FZFProj<cr>

" Automatically set working directory {{{1
function! SetBufferWorkingDirectory()
  if !exists('b:working_dir')
    let b:working_dir = FindWorkingDirectory()
  endif

  exec 'lcd ' . b:working_dir
endfunction

function! FindWorkingDirectory()
  lcd %:p:h

  let git_dir = system('git rev-parse --show-toplevel')
  let is_git_dir = empty(matchstr(git_dir, '^fatal:.*'))
  if is_git_dir
    return git_dir
  endif

  return getcwd()
endfunction

augroup Elentok_AutoWorkingDirectory
  autocmd!
  autocmd BufEnter * call SetBufferWorkingDirectory()
augroup END

" Redraw when gaining focus {{{1

if exists('#FocusGained')
  augroup Elentok_AutoRedraw
    autocmd!
    autocmd FocusGained * silent !tput clear | redraw!
  augroup END
endif
