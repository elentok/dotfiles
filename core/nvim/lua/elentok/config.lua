local util = require("elentok/util")

local config = {
  enable_prettier = true,
  enable_tsserver = true,
  format_on_save = {
    "scss",
    "java",
    "yaml",
    "python",
    "lua",
    "css",
    "html",
    "javascript",
    "json",
    "markdown",
    "typescript",
    "typescriptreact",
    "sh",
    "scad",
    "openscad",
  },
  path_shorteners = {
    [vim.env.HOME] = "~",
  },
}

local local_config = util.safe_require("elentok-local/config", { silent = true })
if local_config then
  if local_config.enable_tsserver ~= nil then
    config.enable_tsserver = local_config.enable_tsserver
  end

  if local_config.enable_prettier ~= nil then
    config.enable_prettier = local_config.enable_prettier
  end

  vim.list_extend(config.format_on_save, local_config.format_on_save or {})
  config.path_shorteners =
  vim.tbl_extend("force", config.path_shorteners, local_config.path_shorteners or {})
end

return config
