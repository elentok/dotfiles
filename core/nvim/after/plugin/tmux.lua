local uv = vim.loop

local function set_tmux_title()
  if not vim.env.TMUX then
    return
  end
  local cwd = vim.fn.getcwd()
  local dir = "~"
  local branch = ""
  local branchVar = vim.env.GIT_BRANCH
  if branchVar ~= nil and #branchVar > 0 then
    if branchVar ~= "main" and branchVar ~= dir then
      branch = " (" .. branchVar .. ")"
    end
  end
  if cwd ~= uv.os_homedir() then
    dir = vim.fn.fnamemodify(vim.fn.getcwd(), ":t")
  end

  local title = dir .. branch .. " "

  vim.fn.system("tmux rename-window " .. vim.fn.shellescape(title), {})
end

vim.api.nvim_create_autocmd({ "VimEnter", "DirChanged", "FocusGained" }, {
  callback = function()
    set_tmux_title()
  end,
})
