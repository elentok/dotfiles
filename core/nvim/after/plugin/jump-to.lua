vim.keymap.set("n", "<leader>jn", function()
  require("fzf-lua").grep({ search = "^#", no_esc = true, cwd = "~/notes", rg_opts = "-tmd" })
end, { desc = "Jump to note" })

vim.keymap.set("n", "<leader>jc", function()
  require("fzf-lua").files({
    cwd = "~",
    raw_cmd = "rg -tlua -tvim --files .dotfiles/core/nvim .dotplugins/*/nvim",
  })
end, { desc = "Jump to config" })

vim.keymap.set("n", "<leader>jvp", function()
  require("fzf-lua").files({
    cwd = "~/.dotfiles/core/nvim/lua/elentok/plugins/",
  })
end, { desc = "Jump to plugin" })

vim.keymap.set("n", "<leader>jS", function()
  require("fzf-lua").files({
    cwd = "~",
    raw_cmd = "rg --files .dotfiles/core/scripts .dotplugins/*/scripts",
  })
end, { desc = "Jump to script" })

vim.keymap.set("n", "<leader>ja", "<c-^>", { desc = "Jump to alternate file" })

vim.keymap.set("n", "<leader>jp", function()
  require("fzf-lua").fzf_exec("dotf-projects list", {
    prompt = "Projects> ",
    actions = {
      ["default"] = function(selected)
        vim.fn.chdir(selected[1])
        vim.cmd("LspRestart")
        vim.defer_fn(function()
          vim.notify("Changed directory to " .. selected[1])
        end, 10)
      end,
    },
  })
end, { desc = "Jump to project" })

vim.keymap.set("n", "<leader>jW", function()
  local root = vim.fn.systemlist("git-wt root")[1]
  require("fzf-lua").fzf_exec("git-wt list", {
    prompt = "Worktrees> ",
    actions = {
      ["default"] = function(selected)
        vim.fn.chdir(root .. "/" .. selected[1])
        vim.cmd("LspRestart")
        vim.defer_fn(function()
          vim.notify("Changed directory to " .. selected[1])
        end, 10)
      end,
    },
  })
end, { desc = "Jump to workspace" })
