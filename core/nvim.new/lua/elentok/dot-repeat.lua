local M = {
  callback = nil,
}

function _G.CallDotRepeatCallback()
  if M.callback then
    M.callback()
  end
end

function M.set(callback)
  M.callback = callback
  vim.go.operatorfunc = "v:lua.CallDotRepeatCallback"
end

return M
