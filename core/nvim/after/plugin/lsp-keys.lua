-- local function lsp_hover_or_peek_into_fold()
--   local winid = require("ufo").peekFoldedLinesUnderCursor()
--   if not winid then
--     vim.lsp.buf.hover()
--   end
-- end

vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("Elentok_LspConfig", {}),
  callback = function(ev)
    -- Enable completion triggered by <c-x><c-o>
    vim.bo[ev.buf].omnifunc = "v:lua.vim.lsp.omnifunc"

    -- Buffer local mappings
    -- local opts = { buffer = ev.buf }

    local function map(mode, key, callback, desc)
      vim.keymap.set(mode, key, callback, { buffer = ev.buf, desc = desc })
    end

    map("n", "gr", vim.lsp.buf.references, "Jump to references")
    map("n", "gd", vim.lsp.buf.definition, "Jump to definition")

    map("n", "<space>jd", vim.lsp.buf.declaration, "Jump to declaration")
    map("n", "<space>jD", vim.lsp.buf.type_definition, "Jump to type definition")
    map("n", "<space>ji", vim.lsp.buf.implementation, "Jump to implementation")

    map("n", "<space>rn", vim.lsp.buf.rename, "Rename symbol")
    map({ "n", "v" }, "<space>ca", vim.lsp.buf.code_action, "Code actions")

    map("n", "K", vim.lsp.buf.hover, "Hover info")
    map("n", "<space>k", vim.lsp.buf.signature_help, "Signature help")

    -- vim.keymap.set("n", "<leader>wa", vim.lsp.buf.add_workspace_folder, opts)
    -- vim.keymap.set("n", "<leader>wr", vim.lsp.buf.remove_workspace_folder, opts)
    -- vim.keymap.set("n", "<leader>wl", function()
    --   print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    -- end, opts)
  end,
})
