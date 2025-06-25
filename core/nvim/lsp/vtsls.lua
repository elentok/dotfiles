vim.g.ts_root = vim.fn.finddir("node_modules/typescript/lib", ".;")

return {
  cmd = { "vtsls", "--stdio" },
  filetypes = {
    "javascript",
    "javascriptreact",
    "javascript.jsx",
    "typescript",
    "typescriptreact",
    "typescript.tsx",
  },
  root_markers = { "package.json" },
  workspace_required = true,
  -- See schema at https://github.com/yioneko/vtsls/blob/main/packages/service/configuration.schema.json
  settings = {
    vtsls = {
      autoUseWorkspaceTsdk = true,
    },
    typescript = {
      tsdk = vim.g.ts_root,
      updateImportsOnFileMove = {
        enabled = "always",
      },
      format = {
        semicolons = "remove",
      },
    },
  },
}
