local map = require('elentok/map')

-- Move arguments to the left and right (see "AndrewRadev/sideways.vim")
map.normal(']m', ':SidewaysRight<cr>')
map.normal('[m', ':SidewaysLeft<cr>')

-- Comment/Uncomment via Ctrl-/
map.normal('<c-_>', ':Commentary<cr>')
map.visual('<c-_>', ':Commentary<cr>')
map.insert('<c-_>', '<c-o>:Commentary<cr>')

-- LSP
map.normal('gD', map.lua('vim.lsp.buf.declaration()'))
map.normal('gd', map.lua('vim.lsp.buf.definition()'))
map.normal('K', map.lua('vim.lsp.buf.hover()'))
map.normal('gi', map.lua('vim.lsp.buf.implementation()'))
map.normal('<space>k', map.lua('vim.lsp.buf.signature_help()'))
map.normal('<leader>wa', map.lua('vim.lsp.buf.add_workspace_folder()'))
map.normal('<leader>wr', map.lua('vim.lsp.buf.remove_workspace_folder()'))
map.normal('<leader>wl', map.lua('print(vim.inspect(vim.lsp.buf.list_workspace_folders()))'))
map.normal('gD', map.lua('vim.lsp.buf.type_definition()'))
map.normal('<leader>rn', map.lua('vim.lsp.buf.rename()'))
map.normal('gr', map.lua('vim.lsp.buf.references()'))
map.normal('<space>e', map.lua('vim.lsp.diagnostic.show_line_diagnostics()'))
map.normal('[d', map.lua('vim.lsp.diagnostic.goto_prev()'))
map.normal(']d', map.lua('vim.lsp.diagnostic.goto_next()'))
map.normal('<space>q', map.lua('vim.lsp.diagnostic.set_loclist()'))

-- Telescope
local function call_telescope(expr)
  return map.lua('require("telescope.builtin").' .. expr)
end

map.normal('<c-p>', call_telescope('find_files{}'))
map.normal('<Leader>b', call_telescope('buffers{}'))
map.normal('<Leader>gt', call_telescope('tags{}'))
map.normal('<Leader>gg', call_telescope('git_status{}'))
map.normal('<Leader>gs', map.lua("require('elentok/cindex').goto_symbol()"))
map.normal('<Leader>gh', call_telescope('help_tags{}'))
map.normal('<Leader>gm', call_telescope('oldfiles{ previewer = false}'))
map.normal('<Leader>fe', call_telescope('file_browser{ cwd = vim.fn.expand("%:p:h") }'))

map.normal('<Leader>ff', call_telescope('grep_string{ search = vim.fn.input("Grep for?") }'))
map.normal('<Leader>fw', call_telescope('grep_string{ search = vim.fn.expand("<cword>") }'))

map.normal('gO', call_telescope('lsp_document_symbols{ symbols = {"function", "method", "interface", "class"} }'))
map.normal('gR', call_telescope('lsp_references()'))


-- Misc
map.normal('<Leader>td', ':ToggleDone<cr>')
