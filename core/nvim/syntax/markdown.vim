syntax match TodoTask '\[ \].*$' contains=TodoContext containedin=markdownCodeBlock
syntax match TodoDone '\[x\].*$' contains=TodoContext containedin=markdownCodeBlock
syntax match TodoWaiting '\[waiting\].*$' contains=TodoContext containedin=markdownCodeBlock
syntax match TodoInprogress '\[inprogress\].*$' contains=TodoContext containedin=markdownCodeBlock
syntax match TodoContext '@[^ ]*' contained
highlight default link TodoDone Comment
highlight default link TodoWaiting WarningMsg
highlight default link TodoInprogress CommandMode
highlight default link TodoContext Statement
