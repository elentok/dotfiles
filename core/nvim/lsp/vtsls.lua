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
  settings = {
    typescript = {
      tsdk = vim.g.ts_root,
    },
  },
}
