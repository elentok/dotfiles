" Vim syntax file
" Language:	David's TextFile Style
" Maintainer:	David Elentok

" Please check :help html.vim for some comments and a description of the options

" For version 5.x: Clear all syntax items
" For version 6.x: Quit when a syntax file was already loaded
if !exists("main_syntax")
  if version < 600
    syntax clear
  elseif exists("b:current_syntax")
  finish
endif
  let main_syntax = 'dtxt'
endif

syn case ignore

" syn region rsntx1 start="=>>" end="$"
" hi rsntx1 guifg=yellow

" syn region dNegative start="\[-" end="\]"
" syn region dUnknown start="\[?" end="\]"
" 
" syn region dFold start="^*" end="^*" skip="\\$" transparent fold
" 
" syn region dHeader1 start="^*" skip="\\$" end="$" keepend
" syn region dHeader2 start="^*\*" skip="\\$" end="$" keepend
" syn region dLine2 start="--" skip="\\$" end=" " end="$" keepend
" syn region dBrackets start="\[[^-?]" skip="\\\"" end="\]" end="$"
" syn region dBrackets2 start="([^(]" skip="\\\"" end=")" end="$"
" syn region dBrackets2a start="((" skip="\\\"" end="))" end="$"
" syn region dbrackets3 start="{" skip="\\\"" end="}" end="$"
" syn region dBrackets4 start="<[^<]" skip="\\\"" end=">" end="$"
" syn region dBrackets4a start="<<" skip="\\\"" end=">>" end="$"
" syn region dhttp start="[hf]t\+ps\=://" end=" " end="$"
" syn region dString start="\""  end="\""   end="$"
" syn region dString2 start="`" end="`" end="$"
" syn region dComment start="^%" end="$"
" syn region dCode start="^[ \t]*#" end="$"
" 
" syn region dLink start="^Link[: ]" end="$" keepend
" 
" syn region dHyperlink start="= \$" end="$"
" " hi dHyperlink gui=underline guibg=#333333 guifg=green
" hi dHyperlink gui=underline guibg=black guifg=lightblue
" 
" hi dNegative gui=bold guifg=red
" hi dUnknown gui=bold guifg=magenta
" hi dHeader1 gui=bold guibg=darkblue guifg=yellow ctermfg=yellow
" hi dHeader2 gui=bold guifg=green ctermfg=yellow
" " hi dLine1 gui=bold guifg=yellow ctermfg=yellow
" hi dLine2 gui=bold guifg=green ctermfg=green
" hi dBrackets gui=none guifg=green ctermfg=green
" hi dBrackets2 gui=none guifg=lightyellow ctermfg=green
" hi dBrackets2a gui=none guibg=red guifg=black ctermfg=green
" 
" hi dLink gui=underline guifg=lightblue
" 
" hi dBrackets3 gui=bold guifg=red ctermfg=green
" " hi dBrackets3 gui=bold guibg=red guifg=black ctermfg=green
" 
" hi dBrackets4 gui=none guifg=lightgreen ctermfg=green
" hi dBrackets4a gui=none guifg=lightred ctermfg=green
" 
" hi dhttp gui=underline guifg=lightblue  cterm=underline ctermfg=blue
" hi dString gui=none guifg=lightmagenta  cterm=bold ctermfg=magenta
" hi dString2 gui=bold guifg=red  cterm=bold ctermfg=red
" hi dComment gui=bold guifg=white ctermfg=white
" hi dCode gui=none guifg=cyan ctermfg=green
" 
" 
" syn region dHoliday start="Holiday: " end="$"
" hi dHoliday gui=none guifg=cyan
" 
" syn region dBirthday start="Birthday: " end="$"
" hi dBirthday gui=none guifg=lightblue
" 
" syn region dUniversity start="University: " end="$"
" hi dUniversity gui=none guifg=yellow
" 
" syn region dArmy start="Army: " end="$"
" hi dArmy gui=none guifg=green
" 
" syn region dTest start="Test: " end="$"
" hi dTest gui=underline guifg=red
" 
" syn region dDriving start="Driving: " end="$"
" hi dDriving gui=underline guifg=gray
" 
" syn region dFree start="^.*\*Fre" end="e"
" hi dFree gui=bold guibg=green guifg=black
" 
" syn region dSaturday start="^.*SAT ==" end="$"
" hi dSaturday gui=bold guibg=green guifg=black
" 
" syn region PmWikiH1 start="^![^!]" end="$"
" syn region PmWikiH2 start="^!![^!]" end="$"
" syn region PmWikiH3 start="^!!![^!]" end="$"
" hi PmWikiH1 ctermbg=yellow ctermfg=black
" hi PmWikiH2 ctermbg=blue
" hi PmWikiH3 ctermbg=magenta
" 

set ai nocindent formatoptions+=t
syn case ignore

syn match dtodoPending "\[ \].*"
syn match dtodoComplete "\[v\].*"

syn match dtxtString "\"[^\"]*\""
syn match dtxtUrl "\(http\|ftp\)://[^ ]*"
syn match dtxtUri "\\\\[^ ]*"
syn match dtxtReply ">>.*"

syn match dtxtCurlyBraces "{[^}]*}"
syn match dtxtTriangleBraces "<[^>]*>"
"syn match dtxtSquareBraces "\[[^\]]*\]"

syn match dtxtHeader1 "^\*.*$"
syn match dtxtHeader2 "^  \*.*$"
syn match dtxtHeader3 "^    \*.*$"
syn match dtxtSeparator "====*"
hi def link dtxtHeader1 Function
hi def link dtxtHeader2 Directory
hi def link dtxtHeader3 Directory
hi def link dtxtSeparator Function

syn match dtxtBullet "^ *-"
hi def link dtxtBullet Function

hi def link dtxtString String
hi def link dtxtUrl Underlined
hi def link dtxtUri Underlined
hi def link dtxtReply Identifier

hi def link dtxtCurlyBraces WarningMsg
hi def link dtxtTriangleBraces String
"hi def link dtxtSquareBraces Constant

hi def link dtodoPending WarningMsg
hi def link dtodoComplete Comment

"" todo.txt
"syn match todotxtContext "@[^ ]*"
"syn match todotxtProject "+[^ ]*"

"hi def link todotxtContext Define
"hi def link todotxtProject Include

syn match dtxtCommand "`[^`]*`"
hi def link dtxtCommand Question

syn match dtxtComment "(.*)"
hi def link dtxtComment Comment

