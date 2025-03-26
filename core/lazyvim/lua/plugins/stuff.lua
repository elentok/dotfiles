---@module "lazy"
---@module "stuff"
---@type LazySpec
return {
  "elentok/stuff.nvim",
  dev = true,
  ---@type StuffOptions
  opts = {
    toggleWord = {},
  },
  keys = {
    { "<leader>tw" },
  },
}
