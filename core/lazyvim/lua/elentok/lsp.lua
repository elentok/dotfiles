local function has_lsp_client(name)
  return #vim.tbl_filter(function(client)
    return client.name == name
  end, vim.lsp.get_clients()) > 0
end

return { has_lsp_client = has_lsp_client }
