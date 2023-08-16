local has_cmp, cmp = pcall(require, "cmp")

vim.api.nvim_create_autocmd("CmdwinEnter", {
  callback = function()
    vim.keymap.set("n", "q", ":q<cr>", { buffer = true })

    -- Hide the completion menu so it doesn't cover the command line buffer
    if has_cmp then
      cmp.close()
    end
  end,
})
