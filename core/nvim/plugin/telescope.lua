local telescope = require "telescope"
local actions = require "telescope/actions"
local map = require "elentok/map"

telescope.setup {
  defaults = {
    -- file_sorter = require('telescope.sorters').get_fzy_sorter,
    file_ignore_patterns = {"node_modules/.*", "scuba_goldens/.*"},
    mappings = {i = {["<C-q>"] = actions.send_to_qflist + actions.open_qflist}}
  },
  extensions = {
    fzf = {
      fuzzy = true,
      override_generic_sorter = true,
      override_file_sorter = true,
      case_mode = "smart_case"
    }
  }
}

telescope.load_extension("aerial")
telescope.load_extension("fzf")
telescope.load_extension("file_browser")

local function call_telescope(expr)
  return map.lua("require(\"telescope.builtin\")." .. expr)
end

map.normal("<c-p>", call_telescope("find_files{}"))
map.normal("<Leader>b", call_telescope("buffers{}"))
map.normal("<Leader>gt", call_telescope("tags{}"))
map.normal("<Leader>gg", call_telescope("git_status{}"))
map.normal("<Leader>gh", call_telescope("help_tags{}"))
map.normal("<Leader>gm", call_telescope("oldfiles{ previewer = false}"))
map.normal("<Leader>fe", ":Telescope file_browser path=%:p:h<cr>")
-- call_telescope("file_browser{ cwd = vim.fn.expand(\"%:p:h\") }"))
-- map.normal("gs", call_telescope(
--                "lsp_document_symbols{ symbols = {\"function\", \"method\", \"interface\", \"class\"} }"))
map.normal("gr", call_telescope("lsp_references()"))
map.normal("``", "<cmd>Telescope aerial<cr>")
map.normal("gs", "<cmd>Telescope aerial<cr>")
map.normal("gb", map.lua("require(\"elentok/telescope\").buf_tags_picker()"))
