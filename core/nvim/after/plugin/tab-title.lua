local uv = vim.loop

vim.opt.title = true

local function ellipsis(length, text)
  if #text > length then
    return string.sub(text, 0, length) .. "… "
  else
    return text
  end
end

local function set_tab_title()
  -- if not vim.env.TMUX then
  --   return
  -- end
  local cwd = vim.fn.getcwd()
  local dir = "~"
  if cwd ~= uv.os_homedir() then
    dir = vim.fn.fnamemodify(vim.fn.getcwd(), ":t")
  end

  local short_dir = ellipsis(15, dir)

  local branch = ""
  local branchVar = vim.env.GIT_BRANCH
  if branchVar ~= nil and #branchVar > 0 then
    if branchVar ~= "main" and branchVar ~= dir then
      branch = " (" .. ellipsis(10, branchVar) .. ")"
    end
  end

  local title = short_dir .. branch .. "  "

  vim.opt.titlestring = title
  -- vim.fn.system("tmux rename-window " .. vim.fn.shellescape(title), {})
end

vim.api.nvim_create_autocmd({ "VimEnter", "DirChanged", "FocusGained" }, {
  callback = function()
    set_tab_title()
  end,
})
