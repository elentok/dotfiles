function Shift_JsObjToTestEach()
  s/\v^(\s*)'?([^:']+)'?:\s*'?([^']+)'?,?$/\1${'\2'} | ${'\3'}/
endfunction
