local util = require("elentok/util")
local message = require("elentok/message")
local statusline = require("elentok/statusline")

local M = {}

-- Formatter commands.
local formatter_cmds = {
  black = "black --quiet --stdin-filename % -",
  clang = "clang-format --style=Google --assume-filename %",
  luaformat = "lua-format --config=$HOME/.lua-format",
  -- Using "prettierd" instead of "prettier" because it runs as a daemon so its
  -- faster, to use regular prettier replace this with:
  --   "prettier --stdin-filepath %",
  prettier = "prettierd %",
  lsp = function(done)
    vim.lsp.buf.formatting_seq_sync()
    done(true)
  end
}

-- TODO:
-- verify formatter commands are executable.
-- for formatter, cmd in pairs(formatter_cmds) do print(formatter) end

-- Matches filetype to formatter.
local formatter_by_filetype = {
  css = "prettier",
  html = "prettier",
  javascript = "prettier",
  lua = "luaformat",
  markdown = "prettier",
  python = "black",
  typescript = "prettier",
  typescriptreact = "prettier"
}

-- Enable or disable automatic formatting.
local format_on_save_by_filetype = {
  css = true,
  html = true,
  java = true,
  javascript = true,
  json = true,
  lua = true,
  markdown = true,
  python = true,
  scss = true,
  sh = true,
  typescript = true,
  typescriptreact = true,
  yaml = true
}

local function save_views(bufnr)
  local active_winhandle = vim.api.nvim_tabpage_get_win(0)
  for _, winhandle in ipairs(vim.fn.win_findbuf(bufnr)) do
    local winnr = vim.api.nvim_win_get_number(winhandle)
    vim.cmd(winnr .. "wincmd w")
    vim.w.last_view = vim.fn.winsaveview()

    if active_winhandle ~= winhandle then
      vim.cmd("wincmd p")
    end
  end
end

local function restore_views(bufnr)
  local active_winhandle = vim.api.nvim_tabpage_get_win(0)
  for _, winhandle in ipairs(vim.fn.win_findbuf(bufnr)) do
    local winnr = vim.api.nvim_win_get_number(winhandle)
    vim.cmd(winnr .. "wincmd w")
    if vim.w.last_view then
      vim.fn.winrestview(vim.w.last_view)
    else
      put(
          "Warning: missing window view setting: bufnr=" .. bufnr .. ", winnr=" ..
              winnr)
    end

    if active_winhandle ~= winhandle then
      vim.cmd("wincmd p")
    end
  end
end

local function post_format(success)
  if success then
    vim.cmd("write")
    restore_views(vim.fn.bufnr())
  end
  vim.b.is_formatting = false
  vim.bo.modifiable = true
  statusline.set_in_progress("")
end

local function run_formatter(cmd)
  -- replace "%" in the commands with the current file path.
  cmd = cmd:gsub("%%", vim.fn.expand("%"))

  util.log("[run_formatter] cmd = ", cmd)

  vim.bo.modifiable = false -- lock the buffer while formatting in the bg.
  local lines = vim.api.nvim_buf_get_lines(0, 0, -1, true)
  util.shell(cmd, {
    stdin = lines,
    callback = function(exitcode, stdout, stderr)
      if exitcode ~= 0 then
        if stderr then
          put("Error formatting:", stderr[1])
        else
          put("Error formatting: no stderr")
        end
        message.show("Formatting Error",
                     vim.list_extend(stderr or {}, stdout or {}),
                     {mode = "error"})
        post_format(false)
      else
        util.log("[run_formatter] formatted successfully")
        message.close()

        -- Remove blank line at the end.
        local length = table.getn(stdout)
        if stdout[length] == "" then
          table.remove(stdout, length)
        end

        vim.bo.modifiable = true
        vim.api.nvim_buf_set_lines(0, 0, -1, false, stdout)
        post_format(true)
      end
    end
  })
end

function M.format(formatter)
  if vim.b.is_formatting then
    return
  end
  vim.b.is_formatting = true

  if formatter == nil or formatter == "" then
    formatter = formatter_by_filetype[util.buf_get_filetype()] or "lsp"
  end

  statusline.set_in_progress("[FORMATTING (" .. formatter .. ")...]")

  util.log("Formatting with " .. formatter)
  local cmd = formatter_cmds[formatter]

  if cmd == nil then
    print("Error: missing formatter " .. formatter)
    post_format(false)
    return
  end

  save_views(vim.fn.bufnr())

  if type(cmd) == "function" then
    cmd(post_format)
  else
    run_formatter(cmd)
  end
end

function M.format_on_save()
  if format_on_save_by_filetype[util.buf_get_filetype()] then
    M.format()
  end
end

function M.set_formatter_cmd(formatter, cmd)
  formatter_cmds[formatter] = cmd
end

function M.set_formatter(filetype, formatter)
  formatter_by_filetype[filetype] = formatter
end

function M.set_format_on_save(filetype, enabled)
  if enabled == nil then
    enabled = true
  end
  format_on_save_by_filetype[filetype] = enabled
end

vim.cmd([[
  command! -nargs=? Format lua require('elentok/format').format('<args>')
  command! ResetFormatter lua vim.b.is_formatting = false
  command! Prettier Format prettier
  command! ClangFormat Format clang
]])

util.augroup("Format", [[
  autocmd BufWritePost * lua require('elentok/format').format_on_save()
]])

return M
