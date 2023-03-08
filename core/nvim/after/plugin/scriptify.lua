#!/usr/bin/env ruby

local hashtags = {
  python = "#!/usr/bin/env python3",
  ruby = "#!/usr/bin/env ruby",
  bash = "#!/usr/bin/env bash\n\nset -euo pipefail",
  node = "#!/usr/bin/env node",
  tsnode = "#!/usr/bin/env -S ts-node --swc",
}

local function scriptify(lang)
  local hashtag = hashtags[lang]
  if hashtag == nil then
    print("Unknown hashtag for language '" .. lang .. "'")
    return
  end

  vim.api.nvim_buf_set_lines(0, 0, 0, true, { hashtag, "" })
  vim.cmd("write")
  vim.fn.system("chmod u+x " .. vim.fn.shellescape(vim.fn.expand("%")))
  vim.cmd("e!")
end

local function scriptify_ui()
  vim.ui.select(vim.tbl_keys(hashtags), {
    prompt = "Select hashtag:",
  }, function(choice)
    if choice ~= nil then
      scriptify(choice)
    end
  end)
end

vim.api.nvim_create_user_command("Scriptify", scriptify_ui, {})
