local M = {}

M.file_types_to_autoformat = {
  "scss",
  "java",
  "yaml",
  "python",
  "lua",
  "css",
  "html",
  "javascript",
  "json",
  "markdown",
  "typescript",
  "typescriptreact",
  "sh",
  "scad",
  "openscad",
}

function M.enable(filetype)
  table.insert(M.file_types_to_autoformat, filetype)
end

function M.format()
  vim.lsp.buf.formatting_seq_sync({}, 2000)
end

vim.api.nvim_create_autocmd({ "BufWritePre" }, { pattern = "*", callback = M.format })
vim.api.nvim_create_user_command("Format", M.format, {})

return M
