local null_ls = require("null-ls")
local helpers = require("null-ls.helpers")

local M = {}

M.diagnostics = {
  name = "SCA2D",
  method = null_ls.methods.DIAGNOSTICS,
  filetypes = { "scad", "openscad" },
  generator = helpers.generator_factory({
    command = "sca2d",
    args = { "$FILENAME" },
    from_temp_file = true,
    format = "line", -- calls "on_output" once per line
    on_output = function(params)
      local columns = vim.split(params, ":")
      if #columns < 5 then
        return nil
      end

      put(columns)
      local code = vim.trim(columns[4])
      local data = {
        row = columns[2],
        col = columns[3],
        code = code,
        message = columns[5] .. " (" .. code .. ")",
      }
      put(data)
      return data
    end,
  }),
}

M.formatter = {
  name = "OpenSCAD Format",
  method = null_ls.methods.FORMATTING,
  filetypes = { "scad", "openscad" },
  generator = helpers.formatter_factory({
    command = "openscad-format",
    args = { "--dry" },
    to_stdin = true,
  }),
}

return M
