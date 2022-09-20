local ok, osc52 = pcall(require, "osc52")
if not ok then
  return
end

local function copy(lines, _)
  osc52.copy(table.concat(lines, "\n"))
end

local function paste()
  return { vim.fn.split(vim.fn.getreg(""), "\n"), vim.fn.getregtype("") }
end

-- Register osc52 as the clipboard handler
vim.g.clipboard = {
  name = "osc52",
  copy = { ["+"] = copy, ["*"] = copy },
  paste = { ["+"] = paste, ["*"] = paste },
}
