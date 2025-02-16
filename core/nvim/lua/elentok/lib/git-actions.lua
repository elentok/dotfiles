---@param commit_hash string
---@param commit_title string?
local function fixup(commit_hash, commit_title)
  if commit_hash == nil then
    return
  end

  local ui = require("elentok.lib.ui")
  local git = require("elentok.lib.git")

  local title = commit_title or commit_hash

  if ui.confirm("Fixup " .. title .. "?") then
    git.run({ "commit", "--fixup", commit_hash })
  end
end

return {
  fixup = fixup,
}
