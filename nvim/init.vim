" vim: foldmethod=marker

let start=reltime()

let $root=expand("<sfile>:p:h")

" OS-Specific {{{1

function! IdentifyOS()
  if system('uname -s') == "Darwin\n"
    return 'mac'
  elseif has('win32')
    return 'windows'
  else
    return 'linux'
  end
endfunc

function! GetPythonVersion()
  if has('python') && !exists('g:python_version')
    let g:python_version = pyeval("sys.version.split(' ')[0].replace('.', '')")
  end
  return g:python_version
endfunc

let g:os = IdentifyOS()

if g:os == 'windows'
  let $temp_dir=$TEMP . '\\vim'
  let $vimrc=expand('<sfile>:p')
  let $vimfiles=expand('<sfile>:p:h')
  let $delimiter='\\'
  let $defaultfont="Consolas:h12:cANSI"
  let $alternatefont="Courier_New:h12:cHEBREW"
  set grepprg="findstr /nI"
  let $opener='start'
  " PowerShell doesn't work well with fzf:
  "set shell=powershell shellquote=( shellpipe=\| shellredir=> shellxquote=
  "set shellcmdflag=-NoLogo\ -NoProfile\ -ExecutionPolicy\ RemoteSigned\ -Command
else
  let $temp_dir='/tmp/vim-' . $USER
  if has('nvim')
    let $vimrc=expand('~/.config/nvim/init.vim')
    let $vimfiles=expand('~/.config/nvim')
  else
    let $vimrc=expand('~/.vimrc')
    let $vimfiles=expand('~/.vim')
  endif
  let $delimiter = '/'
  let $defaultfont='Monaco\ for\ Powerline:h13'
  let $alternatefont='Ubuntu\ Mono\ 13'

  if g:os == 'mac'
    " the 'wildignorecase' option is not available for windows
    set wildignorecase
  end
  
  if file_readable('/usr/local/bin/ctags')
    let g:ctags='/usr/local/bin/ctags'
  else
    let g:ctags='ctags'
  end

  let $opener='open'
  if g:os == 'linux'
    let $opener='/usr/bin/xdg-open'
  end

endif

exec "set guifont=" . $defaultfont

if getftype($temp_dir) != 'dir'
  exec 'silent !mkdir ' . $temp_dir
endif

" }}}1

if isdirectory(expand("~/.dotlocal/nvim"))
  let &runtimepath.=',~/.dotlocal/nvim'
endif

" options: 'coc', 'langclient' or 'native'
let g:lsp_mode='coc'

source $vimfiles/plugs.vim
source $vimfiles/settings.vim
source $vimfiles/functions.vim
source $vimfiles/keys.vim
source $vimfiles/autocmds.vim

if file_readable(expand("~/.vimstate"))
  source ~/.vimstate
endif

let g:vimrc_time=float2nr(str2float(reltimestr(reltime(start))) * 1000)
