return {
  "akinsho/toggleterm.nvim",
  version = "*",
  opts = {
    direction = "float",
    open_mapping = { [[<c-q>]], [[<D-q>]] },
    -- open_mapping = { [[<c-t>]], [[<space>.]] },
    --[[ things you want to change go here]]
    winbar = {
      enabled = false,
      name_formatter = function(term) --  term: Terminal
        return term.name
      end,
    },
  },
}
