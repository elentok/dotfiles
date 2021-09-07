local util = require("elentok/util")
local message = require("elentok/message")

local M = {}

-- Formatter commands.
local formatter_cmds = {
  black = "black --quiet --stdin-filename % - 2>/dev/null",
  clang = "clang-format --style=Google --assume-filename %",
  luaformat = "lua-format --config=$HOME/.lua-format",
  -- Using "prettierd" instead of "prettier" because it runs as a daemon so its
  -- faster, to use regular prettier replace this with:
  --   "prettier --stdin-filepath %",
  prettier = "prettierd %",
  lsp = function(done)
    vim.lsp.buf.formatting_seq_sync()
    done()
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
  local active_windhandle = vim.api.nvim_tabpage_get_win(0)
  for _, winhandle in ipairs(vim.fn.win_findbuf(bufnr)) do
    local winnr = vim.api.nvim_win_get_number(winhandle)
    vim.cmd(winnr .. "wincmd w")
    vim.w.last_view = vim.fn.winsaveview()

    if active_windhandle ~= winhandle then
      vim.cmd("wincmd p")
    end
  end
end

local function restore_views(bufnr)
  local active_windhandle = vim.api.nvim_tabpage_get_win(0)
  for _, winhandle in ipairs(vim.fn.win_findbuf(bufnr)) do
    local winnr = vim.api.nvim_win_get_number(winhandle)
    vim.cmd(winnr .. "wincmd w")
    vim.fn.winrestview(vim.w.last_view)

    if active_windhandle ~= winhandle then
      vim.cmd("wincmd p")
    end
  end
end

local function post_format()
  vim.cmd("write")
  vim.b.is_formatting = false
  restore_views(vim.fn.bufnr())
end

local function run_formatter(cmd)
  -- replace "%" in the commands with the current file path.
  cmd = cmd:gsub("%%", vim.fn.expand("%"))

  util.log("[run_formatter] cmd = ", cmd)
  save_views(vim.fn.bufnr())

  local lines = vim.api.nvim_buf_get_lines(0, 0, -1, true)
  util.shell(cmd, {
    stdin = lines,
    callback = function(exitcode, stdout, stderr)
      if exitcode ~= 0 then
        put("Error formatting:", stderr[1])
        message.show("Formatting Error", vim.list_extend(stderr, stdout),
                     {mode = "error"})
        vim.b.is_formatting = false
      else
        util.log("[run_formatter] formatted successfully")
        message.close()

        -- Remove blank line at the end.
        local length = table.getn(stdout)
        if stdout[length] == "" then
          table.remove(stdout, length)
        end

        vim.api.nvim_buf_set_lines(0, 0, -1, false, stdout)
        post_format()
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

  util.log("Formatting with " .. formatter)
  local cmd = formatter_cmds[formatter]

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
  command! Prettier Format prettier
  command! ClangFormat Format clang
]])

util.augroup("Format", [[
  autocmd BufWritePost * lua require('elentok/format').format_on_save()
]])

return M

