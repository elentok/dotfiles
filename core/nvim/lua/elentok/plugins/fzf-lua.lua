return {
  "ibhagwan/fzf-lua",
  opts = {},
  keys = {
    {
      "<leader>ff",
      "<cmd>FzfLua live_grep<cr>",
      mode = "n",
      desc = "Live grep",
    },
    {
      "<leader>ff",
      "<cmd>FzfLua grep_visual<cr>",
      mode = "v",
      desc = "Grep visual",
    },
    {
      "<leader>fw",
      "<cmd>FzfLua grep_cword<cr>",
      mode = "n",
      desc = "Grep word",
    },
    { "<leader>p", "<cmd>FzfLua git_files<cr>" },
    { "<leader>fl", ":FzfLua " },
    { "z=", "<cmd>FzfLua spell_suggest<cr>" },
    { "<leader>jb", "<cmd>FzfLua buffers file_ignore_patterns={}<cr>" },
    { "<leader>jg", "<cmd>FzfLua git_status<cr>", desc = "Jump to git modified" },
    { "<leader>jj", "<cmd>FzfLua jumps<cr>", desc = "Jump to jumplist" },
    { "<leader>jh", "<cmd>FzfLua helptags<cr>", desc = "Jump to help" },
    { "<leader>jk", "<cmd>FzfLua keymaps<cr>", desc = "Jump to keymap" },
    { "``", "<cmd>FzfLua resume<cr>", desc = "Resume last FzfLua search" },
    {
      "<Leader>jm",
      "<cmd>FzfLua oldfiles only_cwd=true<cr>",
      desc = "Jump to MRU (locally)",
    },
    {
      "<Leader>jM",
      "<cmd>FzfLua oldfiles<cr>",
      desc = "Jump to MRU (globally)",
    },
    {
      "<Leader>jl",
      function()
        require("fzf-lua").files({
          cmd = "git diff-tree --no-commit-id --name-only -r HEAD",
        })
      end,
      desc = "Jump to files in last commit",
    },
  },
  cmd = { "FzfLua" },
}
