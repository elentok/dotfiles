local deep_merge = require("elentok/deep-merge")

local config = {
  enable_eslint_formatter = false,
  prettierd_disabled_filetypes = {},
  format_on_save = {
    css = true,
    html = true,
    java = true,
    javascript = true,
    json = true,
    lua = true,
    markdown = "null-ls",
    openscad = true,
    python = true,
    rust = true,
    scad = true,
    scss = true,
    sh = true,
    terraform = true,
    typescript = "null-ls",
    typescriptreact = "null-ls",
    yaml = true,
  },
  path_shorteners = {
    [vim.env.HOME] = "~",
  },
  -- Config specific to root paths in which Neovim was opened.
  path_specific_config = {},

  -- Allows dotprivate configs to parse links (should return the new URL if
  -- recognized or nil otherwise).
  link_parser = nil,
}

local ok, private_config = pcall(require, "elentok-private/config")
if ok then
  deep_merge(config, private_config or {})
end

local git_dir = vim.fn.finddir(".git", ";.")
if git_dir then
  local git_root =
      vim.fn.fnamemodify(vim.fn.fnamemodify(git_dir, ":h"), ":p"):gsub(vim.env.HOME .. "/", "~/")
  local path_specific_config = config.path_specific_config[git_root]
  if path_specific_config ~= nil then
    deep_merge(config, path_specific_config or {})
  end
end

return config
