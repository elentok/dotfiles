local M = {}

local function gh(repo) return "https://github.com/" .. repo end

local specs = {
  gh("mason-org/mason.nvim"),
  gh("WhoIsSethDaniel/mason-tool-installer.nvim"),
}

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

local loaded = false
local bin_path = vim.fn.stdpath("data") .. "/mason/bin"

function M.setup_path()
  vim.env.MASON = vim.fn.stdpath("data") .. "/mason"

  local path = vim.env.PATH or ""
  if not vim.list_contains(vim.split(path, ":", { plain = true }), bin_path) then
    vim.env.PATH = bin_path .. ":" .. path
  end
end

function M.load()
  if loaded then return end

  M.setup_path()
  require("config.pack").add(specs, { load = false })
  require("mason").setup({})
  require("mason-tool-installer").setup({
    ensure_installed = ensure_installed,
    run_on_start = false,
  })

  loaded = true
end

function M.install_sync()
  M.load()
  require("mason-tool-installer").check_install(false, true)
end

function M.open()
  M.load()
  vim.cmd.Mason()
end

return M
