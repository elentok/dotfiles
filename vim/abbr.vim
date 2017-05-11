iabbr cl console.log ""<left>
iabbr bbm Backbone.Model
iabbr bbv Backbone.View
iabbr bm Backbone.Marionette
iabbr doctype5 <!DOCTYPE html>
iabbr #date <c-r>=strftime("%Y-%m-%d")<cr>
iabbr #time <c-r>=strftime("%H:%M:%S")<cr>

cabbr G Git
cabbr Gps Git push
cabbr Gpl Git pull
cabbr Gap Git add -p
cabbr Gam Gcommit --amend

" When run inside abudoco disable the 'violent' quit commands
if $NVIM_KEEP_ALIVE != ""
  cabbr qa echo ':qa has been disabled'<cr>
  cabbr wqa echo ':wqa has been disabled'<cr>
  cabbr cq echo ':cq has been disabled'<cr>
endif
