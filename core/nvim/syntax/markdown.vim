syntax match TodoTask '\[ \].*$' contains=TodoContext
syntax match TodoDone '\[x\].*$' contains=TodoContext
syntax match TodoWaiting '\[waiting\].*$' contains=TodoContext
syntax match TodoInprogress '\[inprogress\].*$' contains=TodoContext
syntax match TodoContext '@[^ ]*' contained
highlight default link TodoDone Comment
highlight default link TodoWaiting WarningMsg
highlight default link TodoInprogress Directory
highlight default link TodoContext Statement
