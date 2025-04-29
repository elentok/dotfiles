local util = require("elentok.util")

local function add_text_after_visual_selection(text_to_add)
  local esc = vim.api.nvim_replace_termcodes("<esc>", true, false, true)
  vim.api.nvim_feedkeys("ooA" .. " = " .. vim.trim(text_to_add) .. esc, "n", true)
end

local function calculate()
  local selection = util.get_visual_selection()
  local obj = vim.system({ "bc" }, { stdin = selection }):wait()
  if obj.code ~= 0 then
    vim.notify("Failed to calculate expression: " .. selection, vim.log.levels.ERROR)
  end

  add_text_after_visual_selection(vim.trim(obj.stdout))
end

vim.keymap.set("v", "<leader>cm", calculate)
