local M = {}

local ensure_installed = {
  "bash-language-server",
  "biome",
  "css-lsp",
  "cssmodules-language-server",
  "docker-compose-language-service",
  "dockerfile-language-server",
  "dprint",
  "eslint-lsp",
  -- "eslint_d",
  "fish-lsp",
  "gopls",
  "harper-ls",
  "html-lsp",
  "json-lsp",
  "lua-language-server",
  "markdown-oxide",
  "npm-groovy-lint",
  "openscad-lsp",
  "prettierd",
  "pyright",
  "shfmt",
  "rust-analyzer",
  "ruff", -- python formatter
  "stylua",
  "taplo",
  "ty",
  "vtsls",
  "yaml-language-server",
}

function M.install_sync()
  local mason = require("mason")
  if not mason.has_setup then mason.setup({}) end

  local registry = require("mason-registry")
  registry.refresh()

  local pending = 0
  local failed = {}

  print("Ensuring " .. #ensure_installed .. " packages are installed...\n")

  for _, name in ipairs(ensure_installed) do
    local pkg = registry.get_package(name)
    if pkg:is_installed() then
      print(("- Already installed: %s"):format(name))
    else
      pending = pending + 1
      print(("- Installing Mason package: %s"):format(name))
      pkg:install({}, function(success, result)
        pending = pending - 1
        if not success then
          table.insert(failed, ("%s: %s"):format(name, result))
        else
          print(("- Installed Mason package: %s"):format(name))
        end
      end)
    end
  end

  vim.wait(3600000, function() return pending == 0 end, 100)

  if #failed > 0 then error("Failed to install Mason packages:\n" .. table.concat(failed, "\n")) end

  print("\nMason tools are installed.\n")
end

return M
