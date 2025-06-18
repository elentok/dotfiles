---@param files string[]
local function findfiles(files)
  for _, file in ipairs(files) do
    local found = vim.fn.findfile(file, ".;")
    if found ~= "" then return found end
  end

  return ""
end

---@param files string[]
local function hasfile(files) return findfiles(files) ~= "" end

return {
  findfiles = findfiles,
  hasfile = hasfile,
}
