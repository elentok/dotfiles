local has_mason, mason = pcall(require, "mason")
local has_mason_lspconfig, mason_lspconfig = pcall(require, "mason-lspconfig")
if not has_mason or not has_mason_lspconfig then
  return
end

mason.setup({})
mason_lspconfig.setup({
  ensure_installed = { "marksman" },
})
