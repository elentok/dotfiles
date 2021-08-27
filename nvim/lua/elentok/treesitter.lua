local util = require("elentok/util")

local treesitter_configs = util.safe_require("nvim-treesitter.configs")
if not treesitter_configs then
  return
end

require"nvim-treesitter.configs".setup {
  ensure_installed = "maintained",
  ignore_install = {
    "nix", "erlang", "ocamllex", "devicetree", "gdscript", "supercollider",
    "ledger"
  },
  highlight = {enable = true},
  autopairs = {enable = true},
  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = "gnn",
      node_incremental = "grn",
      scope_incremental = "grc",
      node_decremental = "grm"
    }
  },
  -- disable python and typescript indentation until fixed:
  --   https://github.com/nvim-treesitter/nvim-treesitter/issues/1167#issue-853914044
  indent = {enable = true, disable = {"python", "typescript", "javascript"}}
}

util.augroup("Treesitter", [[
  autocmd FileType * setlocal foldmethod=expr foldexpr=nvim_treesitter#foldexpr()
]])
