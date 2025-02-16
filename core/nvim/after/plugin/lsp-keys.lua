-- local function lsp_hover_or_peek_into_fold()
--   local winid = require("ufo").peekFoldedLinesUnderCursor()
--   if not winid then
--     vim.lsp.buf.hover()
--   end
-- end

local function toggle_inlay_hints()
  if vim.lsp.inlay_hint.is_enabled() then
    vim.lsp.inlay_hint.enable(false)
    print("Inlay hints: disabled")
  else
    vim.lsp.inlay_hint.enable(true)
    print("Inlay hints: enabled")
  end
end

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

    -- map("n", "gr", vim.lsp.buf.references, "Jump to references")
    -- map("n", "gd", vim.lsp.buf.definition, "Jump to definition")
    -- map("n", "gr", "<Cmd>FzfLua lsp_references<cr>", "Jump to references")
    -- map("n", "gd", "<Cmd>FzfLua lsp_definitions<cr>", "Jump to definition")
    map("n", "gr", function()
      Snacks.picker.lsp_references()
    end, "Jump to references")
    map("n", "gd", function()
      Snacks.picker.lsp_definitions()
    end, "Jump to definition")

    -- map("n", "<leader>js", "<Cmd>FzfLua lsp_document_symbols<cr>", "Jump to definition")
    map("n", "<leader>js", function()
      Snacks.picker.lsp_symbols()
    end, "Jump to symbol")

    map("n", "<leader>jd", vim.lsp.buf.declaration, "Jump to declaration")
    map("n", "<leader>jD", vim.lsp.buf.type_definition, "Jump to type definition")
    map("n", "<leader>ji", vim.lsp.buf.implementation, "Jump to implementation")

    map("n", "<leader>ti", toggle_inlay_hints, "Toggle inlay hints")

    map("n", "<leader>rn", vim.lsp.buf.rename, "Rename symbol")
    map({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, "Code actions")

    map("n", "<leader>ik", vim.lsp.buf.signature_help, "Signature help")

    -- vim.keymap.set("n", "<leader>wa", vim.lsp.buf.add_workspace_folder, opts)
    -- vim.keymap.set("n", "<leader>wr", vim.lsp.buf.remove_workspace_folder, opts)
    -- vim.keymap.set("n", "<leader>wl", function()
    --   print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    -- end, opts)
  end,
})
