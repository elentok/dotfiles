local util = require("elentok/util")
local map = require("elentok/map")
local saga = util.safe_require("lspsaga")

if saga == nil then
  return
end

saga.init_lsp_saga({code_action_prompt = {enable = false}})

map.normal("gh", ":Lspsaga lsp_finder<cr>")
map.normal("<Leader>ca", ":Lspsaga code_action<cr>")
map.visual("<Leader>ca", ":<c-u>Lspsaga code_action<cr>")
map.normal("K", ":Lspsaga hover_doc<cr>")
map.normal("gS", ":Lspsaga signature_help<cr>")
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
