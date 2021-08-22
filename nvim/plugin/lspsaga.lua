local saga = require("lspsaga")
local map = require("elentok/map")

saga.init_lsp_saga()

map.normal("gh", ":Lspsaga lsp_finder<cr>")
map.normal("ca", ":Lspsaga code_action<cr>")
map.visual("ca", ":<c-u>Lspsaga code_action<cr>")
map.normal("K", ":Lspsaga hover_doc<cr>")
map.normal("gss", ":Lspsaga signature_help<cr>")
map.normal("<Leader>rn", ":Lspsaga rename<cr>")
map.normal("<space>e", ":Lspsaga show_line_diagnostics<cr>")
map.normal("]d", ":Lspsaga  diagnostic_jump_next<cr>")
map.normal("[d", ":Lspsaga  diagnostic_jump_prev<cr>")

-- scroll down hover doc or scroll in definition preview
map.normal("<c-f>",
           map.lua([[require('lspsaga.action').smart_scroll_with_saga(1)]]))
-- scroll up hover doc
map.normal("<c-b>",
           map.lua([[require('lspsaga.action').smart_scroll_with_saga(-1)]]))

