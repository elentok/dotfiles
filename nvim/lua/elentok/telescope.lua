local actions = require('telescope/actions')
local util = require('elentok/util')
require('telescope').setup {
  defaults = {
    file_sorter = require('telescope.sorters').get_fzy_sorter,
    file_ignore_patterns = {
      "node_modules/.*",
      "scuba_goldens/.*",
    },
    mappings = {
      i = {
        ["<C-q>"] = actions.send_to_qflist
      }
    }
  },
  extensions = {
    fzy_native = {
        override_generic_sorter = false,
        override_file_sorter = true,
    }
  }
}

require('telescope').load_extension('fzy_native')

local nnoremap = util.create_map_func('n')

nnoremap('<c-p>', 'require("telescope.builtin").find_files{}')
nnoremap('<Leader>b', 'require("telescope.builtin").buffers{}')
nnoremap('<Leader>gt', 'require("telescope.builtin").tags{}')
nnoremap('<Leader>gh', 'require("telescope.builtin").help_tags{}')
nnoremap('<Leader>fe', 'require("telescope.builtin").file_browser{ cwd = vim.fn.expand("%:p:h") }')

nnoremap('<Leader>ff', 'require("telescope.builtin").grep_string{ search = vim.fn.input("Grep for?") }')
nnoremap('<Leader>fw', 'require("telescope.builtin").grep_string{ search = vim.fn.expand("<cword>") }')

nnoremap('gO', 'require("telescope.builtin").lsp_document_symbols{ symbols = {"function", "method", "interface", "class"} }')
nnoremap('gR', 'require("telescope.builtin").lsp_references()')
