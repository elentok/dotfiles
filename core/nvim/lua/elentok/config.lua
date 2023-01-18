local util = require("elentok/util")

local config = {
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
}

local local_config = util.safe_require("elentok-local/config", { silent = true })
if local_config then
  if local_config.enable_tsserver ~= nil then
    config.enable_tsserver = local_config.enable_tsserver
  end

  vim.list_extend(config.format_on_save, local_config.format_on_save or {})
end

return config
