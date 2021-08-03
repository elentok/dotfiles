local telescope = require('elentok/telescope')

local function goto_symbol(opts)
  telescope.command_picker({
    cmd = {'cindex', 'list'},
    parse_line = function(line)
      local parts = vim.split(line, ",")
      return {
        text = parts[1],
        filename = parts[3],
        lnum = parts[4]
      }
    end,
  })
end

return {
  goto_symbol = goto_symbol,
}
