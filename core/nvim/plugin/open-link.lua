local function is_http_link(link)
  return vim.startswith(link, "http://") or vim.startswith(link, "https://")
end

local function open_link(link)
  if link == nil then
    link = vim.fn.expand("<cfile>")
  end

  if not is_http_link(link) then
    link = "http://" .. link
  end

  local message = "Link opened."
  local command = "xdg-open"
  if vim.env.SSH_TTY ~= nil then
    message = "Link copied to clipboard."
    command = "dotf-yank-osc52-string" -- when in an SSH session copy the URL to the clipboard
  elseif vim.fn.has("wsl") == 1 then
    command = "explorer.exe"
  elseif vim.fn.has("macunix") == 1 then
    command = "open"
  end

  vim.fn.jobstart({ command, link }, {
    on_exit = function(_, exitcode, _)
      if exitcode == 0 then
        print(message)
      else
        print('Error opening link with "' .. command .. " " .. link .. '"')
      end
    end,
  })
end

vim.keymap.set("n", "ge", open_link)
