syntax match TodoDone '✔.*$'
syntax match TodoWaiting '(waiting).*$'
syntax match TodoInprogress '(inprogress).*$'
highlight default link TodoDone Comment
highlight default link TodoWaiting WarningMsg
highlight default link TodoInprogress Directory
