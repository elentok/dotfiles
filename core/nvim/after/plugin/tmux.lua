local uv = vim.loop

local function set_tmux_title()
  if not vim.env.TMUX then
    return
  end
  local cwd = vim.fn.getcwd()
  local dir = "~"
  if cwd ~= uv.os_homedir() then
    dir = vim.fn.fnamemodify(vim.fn.getcwd(), ":t")
  end
  vim.fn.system("tmux rename-window '" .. vim.fn.shellescape(dir) .. " '", {})
end

vim.api.nvim_create_autocmd({ "VimEnter", "DirChanged" }, {
  callback = function()
    set_tmux_title()
  end,
})
