return {
  cmd = { "deno", "lsp" },
  cmd_env = { NO_COLOR = true },
  filetypes = {
    "javascript",
    "javascriptreact",
    "javascript.jsx",
    "typescript",
    "typescriptreact",
    "typescript.tsx",
  },
  root_markers = { "deno.json", "deno.jsonc" },
  workspace_required = true,
  settings = {
    deno = {
      enable = true,
      suggest = {
        imports = {
          hosts = {
            ["https://deno.land"] = true,
          },
          autoDiscover = true,
        },
        autoImports = true,
        names = true,
        completeFunctionCalls = true,
      },
    },
  },
}
