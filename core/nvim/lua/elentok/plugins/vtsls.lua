return {
  "yioneko/nvim-vtsls",
  ft = { "typescript", "typescriptreact", "javascript" },
  config = function()
    require("vtsls").config({})
  end,
}
