local group_id = vim.api.nvim_create_augroup("PackerRecompileOnSave", {})

vim.api.nvim_create_autocmd({ "BufWritePost" }, {
  pattern = "packer.lua",
  group = group_id,
  callback = function()
    vim.cmd("luafile %")
    print("Recompiling packer lazy loader")
    require("packer").compile()
  end,
})
