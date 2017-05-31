syn region myFold start="{" end="}" transparent fold keepend extend
set foldtext=getline(v:foldstart)
set foldmethod=syntax
