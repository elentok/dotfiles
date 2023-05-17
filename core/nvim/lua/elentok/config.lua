local config = {
  prettierd_disabled_filetypes = {},
  format_on_save = {
    "css",
    "html",
    "java",
    "javascript",
    "json",
    "lua",
    "markdown",
    "openscad",
    "python",
    "rust",
    "scad",
    "scss",
    "sh",
    "terraform",
    "typescript",
    "typescriptreact",
    "yaml",
  },
  path_shorteners = {
    [vim.env.HOME] = "~",
  },
  -- Config specific to root paths in which Neovim was opened.
  path_specific_config = {},
}

local function extend_config(new_config)
  if new_config then
    if new_config.prettierd_disabled_filetypes ~= nil then
      vim.list_extend(config.prettierd_disabled_filetypes, new_config.prettierd_disabled_filetypes)
    end

    vim.list_extend(config.format_on_save, new_config.format_on_save or {})
    config.path_shorteners =
        vim.tbl_extend("force", config.path_shorteners, new_config.path_shorteners or {})
    config.path_specific_config =
        vim.tbl_extend("force", config.path_specific_config, new_config.path_specific_config or {})
  end
end

local ok, private_config = pcall(require, "elentok-private/config")
if ok then
  extend_config(private_config)
end

local git_dir = vim.fn.finddir(".git")
if git_dir then
  local git_root =
      vim.fn.fnamemodify(vim.fn.fnamemodify(git_dir, ":h"), ":p"):gsub(vim.env.HOME .. "/", "~/")
  local path_specific_config = config.path_specific_config[git_root]
  if path_specific_config ~= nil then
    extend_config(path_specific_config)
  end
end

return config
