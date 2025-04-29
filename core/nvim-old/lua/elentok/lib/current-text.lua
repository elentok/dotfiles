local function get_visual_selection()
  -- Visual mode: Get the selected text
  local _, start_row, start_col, _ = unpack(vim.fn.getpos("'<"))
  local _, end_row, end_col, _ = unpack(vim.fn.getpos("'>"))
  if end_col > 0 then
    end_col = end_col - 1
  end
  local lines = vim.api.nvim_buf_get_lines(0, start_row - 1, end_row, false)
  if #lines == 1 then
    lines[1] = lines[1]:sub(start_col, end_col)
  else
    lines[1] = lines[1]:sub(start_col)
    lines[#lines] = lines[#lines]:sub(1, end_col)
  end
  return table.concat(lines, "\n")
end

local function get_current_text()
  local mode = vim.api.nvim_get_mode().mode
  if mode:match("^[vV]") then
    return get_visual_selection()
  else
    return vim.fn.expand("<cword>")
  end
end

return { get_visual_selection = get_visual_selection, get_current_text = get_current_text }
