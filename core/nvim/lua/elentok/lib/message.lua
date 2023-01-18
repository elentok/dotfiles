local util = require("elentok/util")

local M = {}

-- Opts:
--   mode = 'normal' or 'error' (defaults to 'normal')
function M.show(title, lines, opts)
  opts = vim.tbl_extend("force", { mode = "normal" }, opts or {})

  if vim.t.message_bufnr then
    local winnr = util.tabpage_get_buf_win_number(0, vim.t.message_bufnr)
    if winnr then
      -- jump to the existing message window
      vim.cmd(winnr .. "wincmd w")
    else
      -- split and load the existing message buffer
      vim.cmd("belowright split")
      vim.cmd("buffer " .. vim.t.message_bufnr)
    end
  else
    -- create a new message buffer
    vim.cmd([[
      belowright new
      noswapfile hide enew
    ]])
    vim.bo.buftype = "nofile"
    vim.bo.bufhidden = "hide"
    vim.cmd("file " .. title)
    vim.t.message_bufnr = vim.fn.bufnr()

    if opts.mode == "error" then
      vim.wo.winhighlight = "Normal:DiffText"
      vim.wo.cursorline = false
    end

    vim.api.nvim_buf_set_keymap(0, "n", "q", ":close<cr>", { noremap = true, silent = true })
  end
  vim.api.nvim_buf_set_lines(0, 0, -1, false, lines)
  vim.cmd([[wincmd p]])
end

function M.close()
  if vim.t.message_bufnr then
    vim.cmd("silent bd " .. vim.t.message_bufnr)
    vim.t.message_bufnr = nil
  end
end

return M
