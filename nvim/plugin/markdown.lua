local util = require("elentok/util")

function _G.MarkdownSetup()
  -- Spell checking
  vim.wo.spell = true
  vim.bo.spellcapcheck = ""

  -- Setup folding by headings.
  vim.wo.foldlevel = 1
  vim.wo.foldmethod = "expr"
  vim.wo.foldexpr = "v:lua.MarkdownFoldexpr(v:lnum)"

  -- Automatic word wrapping.
  vim.bo.textwidth = 80
  -- n = recognize numbered lists
  -- b = auto wrap only if not already longer than textwidth
  vim.bo.formatoptions = vim.bo.formatoptions .. "nb"
end

function _G.MarkdownFoldexpr(lnum)
  local line = vim.fn.getline(lnum)

  local match = line:match("^#+")
  if match then
    return ">" .. string.len(match)
  else
    return "="
  end
end

util.augroup("Markdown", [[
  autocmd FileType markdown lua MarkdownSetup()
]])

