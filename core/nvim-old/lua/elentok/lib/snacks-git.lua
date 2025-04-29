---@type snacks.picker.Config
local git_commits_picker_config = {
  actions = {
    fixup = function(picker, item)
      picker:close()
      require("elentok.lib.git-actions").fixup(item.commit, item.msg)
    end,
    open_commit = function(picker, item)
      picker:close()
      require("diffview").open(item.commit)
    end,
    yank_commit = function(_, item)
      vim.fn.setreg("+", item.commit)
      Snacks.notifier.notify("Copied " .. item.commit)
    end,
  },

  win = {
    input = {
      keys = {
        ["f"] = { "fixup", mode = { "n" } },
        ["<cr>"] = { "open_commit", mode = { "n", "i" } },
        ["y"] = { "yank_commit", mode = { "n" } },
      },
    },
  },
}

---@type snacks.picker.Config
local git_status_picker_config = {
  actions = {
    yank_file = function(_, item)
      vim.fn.setreg("+", item.file)
      Snacks.notifier.notify("Copied " .. item.file)
    end,
    git_stage = function(picker, item)
      picker:close()
      require("elentok.lib.git-actions").stage_patch(item.file)
    end,
  },

  win = {
    input = {
      keys = {
        ["y"] = { "yank_file", mode = { "n" } },
        ["gs"] = { "git_stage", mode = { "n" } },
      },
    },
  },
}

return {
  git_commits_picker_config = git_commits_picker_config,
  git_status_picker_config = git_status_picker_config,
}
