local function run(cmd, callback)
  local stdout_chunks = {}
  local stderr_chunks = {}
  vim.system(cmd, {
    stdout = function(_, data)
      if data then table.insert(stdout_chunks, data) end
    end,
    stderr = function(_, data)
      if data then table.insert(stderr_chunks, data) end
    end,
  }, function(obj)
    vim.schedule(
      function() callback(obj.code, table.concat(stdout_chunks), table.concat(stderr_chunks)) end
    )
  end)
end

local function autosync()
  vim.notify("Syncing...")
  run({ "git", "autosync" }, function(code, stdout, stderr)
    if code ~= 0 then
      vim.notify("✘ Sync failed:\n" .. stdout .. stderr, vim.log.levels.ERROR)
    else
      vim.notify("✔ Sync complete")
    end
  end)
end

vim.keymap.set("n", "<leader>gn", autosync, { desc = "Git autosync  " })
