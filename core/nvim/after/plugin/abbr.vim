iabbr doctype5 <!DOCTYPE html>
iabbr date@ <c-r>=strftime("%Y-%m-%d")<cr>
iabbr time@ <c-r>=strftime("%H:%M:%S")<cr>
iabbr now@ <c-r>=strftime("%A, %B %d, %H:%M")<cr>
iabbr log@ <c-r>=v:lua.require('elentok/lib/treesitter').get_logger_line()<cr><left><left>,

cabbr Gca Gcommit --amend
cabbr Gam Gcommit --amend
