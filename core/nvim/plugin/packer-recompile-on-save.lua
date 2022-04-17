vim.api.nvim_create_autocmd({"BufWritePost"}, {
  pattern = "packer-plugins.lua",
  callback = function()
    vim.cmd("luafile %")
    print("Recompiling packer lazy loader")
    require("packer").compile()
  end
})
