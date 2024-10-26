return {
  "homerours/jumper.nvim",
  config = function()
    vim.keymap.set("n", "<space>zd", require("jumper.fzf-lua").jump_to_directory)
    vim.keymap.set("n", "<space>zf", require("jumper.fzf-lua").jump_to_file)
    vim.keymap.set("n", "<space>zi", require("jumper.fzf-lua").find_in_files)
  end,
}
