local has_lspconfig, lspconfig = pcall(require, "lspconfig")
local has_cmp, cmp = pcall(require, "cmp_nvim_lsp")
local has_aerial, aerial = pcall(require, "aerial")

if not (has_lspconfig and has_cmp and has_aerial) then
  return {
    setup = function()
      print("Warning: LSP not loaded, missing plugins.")
    end,
  }
end

local M = {}

local function on_attach(client, bufnr)
  put("Client", client.name, "attached to", bufnr)
  aerial.on_attach(client, bufnr)

  -- Use <c-]> to go to definition
  vim.api.nvim_buf_set_option(bufnr, "tagfunc", "v:lua.vim.lsp.tagfunc")
end

M.capabilities = cmp.update_capabilities(vim.lsp.protocol.make_client_capabilities())

-- For nvim-ufo
M.capabilities.textDocument.foldingRange = {
  dynamicRegistration = false,
  lineFoldingOnly = true,
}

function M.setup(servers, capabilities)
  for server, config in pairs(servers) do
    if config == true then
      config = {}
    elseif config == false then
      goto continue
    end

    config.capabilities = capabilities or M.capabilities

    local original_on_attach
    if config.on_attach then
      original_on_attach = config.on_attach
    end

    config.on_attach = function(client, bufnr)
      on_attach(client, bufnr)
      if original_on_attach then
        original_on_attach(client, bufnr)
      end
    end

    lspconfig[server].setup(config)
    ::continue::
  end
end

return M
