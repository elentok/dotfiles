local ok, luasnip = pcall(require, "luasnip")
if not ok then
  return
end

require("luasnip/loaders/from_vscode").lazy_load()

local s = luasnip.snippet
local t = luasnip.text_node

luasnip.add_snippets("openscad", {
  s("head", {
    t({ "include <BOSL2/std.scad>", "$fn = 64;", "", "" }),
  }),
})
