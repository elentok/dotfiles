local lspconfig = require("lspconfig")
local cmp = require("cmp_nvim_lsp")
local aerial = require("aerial")

local M = {}

local function on_attach(client, bufnr)
  put("Client", client.name, "attached to", bufnr)
  aerial.on_attach(client, bufnr)

  -- Use <c-]> to go to definition
  vim.api.nvim_buf_set_option(bufnr, "tagfunc", "v:lua.vim.lsp.tagfunc")
end

local capabilities = cmp.update_capabilities(vim.lsp.protocol.make_client_capabilities())

function M.setup(servers)
  for server, config in pairs(servers) do
    if config == true then
      config = {}
    elseif config == false then
      goto continue
    end

    config.capabilities = capabilities

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
