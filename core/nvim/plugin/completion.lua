local util = require("elentok/util")
local cmp = util.safe_require("cmp")

if cmp == nil then
  return
end

cmp.setup({
  sources = cmp.config.sources({{name = "nvim_lsp"}, {name = "buffer"}}),
  mapping = {
    ["<Tab>"] = cmp.mapping(cmp.mapping.select_next_item(), {"i", "s"})
  }
})
