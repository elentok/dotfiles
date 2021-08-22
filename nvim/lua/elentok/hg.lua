local M = {}

function M.log()
  vim.cmd([[
    tabnew
    noswapfile hide enew
    file Log
  ]])
  vim.fn.setline(1, 'Loading...')

  vim.bo.buftype = 'nofile'
  vim.bo.bufhidden = 'hide'

  vim.fn.jobstart('hg log', {
    stdout_buffered = true,
    on_stdout = function(_, data, _)
      vim.api.nvim_buf_set_lines(0, 0, #data, false, data)
    end
  })
end

return M
