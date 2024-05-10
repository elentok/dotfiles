local function toggle_test_line(line)
  if line:match("%f[%a]describe%(") then
    return line:gsub("%f[%a]describe%(", "describe.only(")
  elseif line:match("%f[%a]describe.only%(") then
    return line:gsub("%f[%a]describe.only%(", "describe(")
  elseif line:match("%f[%a]it%(") then
    return line:gsub("%f[%a]it%(", "it.only(")
  elseif line:match("%f[%a]it.only%(") then
    return line:gsub("%f[%a]it.only%(", "it(")
  elseif line:match("%f[%a]test%(") then
    return line:gsub("%f[%a]test%(", "test.only(")
  elseif line:match("%f[%a]test.only%(") then
    return line:gsub("%f[%a]test.only%(", "test(")
  end

  return nil
end

local function toggle_focused_test()
  local line
  local line_index = vim.api.nvim_win_get_cursor(0)[1]
  while line_index > 0 do
    line = toggle_test_line(vim.fn.getline(line_index))

    if line ~= nil then
      vim.api.nvim_buf_set_lines(0, line_index - 1, line_index, false, { line })
      return
    end

    line_index = line_index - 1
  end

  print("No test found")
end

vim.keymap.set("n", "<leader>tf", toggle_focused_test, { desc = "Toggle focused test" })

vim.keymap.set("n", "<leader>jf", function()
  local telescope = require("telescope")
  telescope.extensions.live_grep_args.live_grep_args({
    search_dirs = { "%" },
    default_text = "'(it|test|describe).(only|skip)'",
  })
end, { desc = "Jump to focused/skipped tests" })
