local function rename_file()
  local will_rename = require("lsp-file-operations.will-rename")
  local source_file = vim.api.nvim_buf_get_name(0)

  vim.ui.input({
    prompt = "Target: ",
    completion = "file",
    default = source_file,
  }, function(target_file)
    if target_file == nil or target_file == "" then
      return
    end

    vim.fn.mkdir(vim.fn.fnamemodify(target_file, ":p:h"), "p")

    will_rename.callback({
      old_name = source_file,
      new_name = target_file,
    })
    vim.lsp.util.rename(source_file, target_file, {})
  end)
end

return {
  "antosha417/nvim-lsp-file-operations",
  config = function()
    vim.api.nvim_create_user_command("LspRename", rename_file, {})

    vim.keymap.set("n", "<space>rf", function()
      rename_file()
    end, { desc = "Rename file (with LSP)" })
  end,
  keys = {
    {
      "<space>rf",
      rename_file,
      desc = "Rename file (with LSP)",
    },
  },
}
