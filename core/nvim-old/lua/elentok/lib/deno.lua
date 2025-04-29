---Checks if the cwd is inside a deno project by searching for either a
--deno.json or deno.jsonc project
---@return boolean
local function isDenoProject()
  return vim.fn.findfile("deno.json", ";.") ~= "" or vim.fn.findfile("deno.jsonc", ";.") ~= ""
end

return { isDenoProject = isDenoProject }
