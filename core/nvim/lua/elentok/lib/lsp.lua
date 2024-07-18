---@param name string
---@return boolean
local function hasLspClient(name)
  return #vim.tbl_filter(function(client)
    return client.name == name
  end, vim.lsp.buf_get_clients()) > 0
end

return { hasLspClient = hasLspClient }
