local http_prefix_regex = vim.regex("^https?://")

local function open_link(link)
  if link == nil then
    link = vim.fn.expand("<cfile>")
  end

  if not http_prefix_regex:match_str(link) then
    link = "http://" .. link
  end

  local command = "xdg-open"
  if vim.fn.has("macunix") == 1 then
    command = "open"
  end

  vim.fn.jobstart({ command, link }, {
    on_exit = function(_, exitcode, _)
      if exitcode == 0 then
        print("Link opened.")
      else
        print('Error opening link with "' .. command .. " " .. link .. '"')
      end
    end,
  })
end

vim.keymap.set("n", "ge", open_link)
