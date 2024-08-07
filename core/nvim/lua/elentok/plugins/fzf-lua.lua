return {
  "ibhagwan/fzf-lua",
  opts = {
    "max-perf",
    winopts = {
      width = 0.9,
      preview = {
        horizontal = "right:50%",
        flip_columns = 140,
      },
    },
    keymap = {
      fzf = {
        ["ctrl-q"] = "select-all+accept",
        ["ctrl-d"] = "half-page-down",
        ["ctrl-u"] = "half-page-up",
        ["ctrl-w"] = "toggle-preview-wrap",
      },
    },
    grep = {
      multiline = 1,
    },
    git = {
      status = {
        actions = {
          -- I keep hitting ctrl-x by mistake and resetting
          -- (and there's no confirmation)
          ["ctrl-x"] = false,
        },
      },
    },
  },
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
    { "<leader>p", "<cmd>FzfLua files<cr>" },
    { "<leader>fl", ":FzfLua " },
    { "z=", "<cmd>FzfLua spell_suggest<cr>" },
    { "<leader>jb", "<cmd>FzfLua buffers<cr>" },
    { "<leader>jg", "<cmd>FzfLua git_status<cr>", desc = "Jump to git modified" },
    { "<leader>jj", "<cmd>FzfLua jumps<cr>", desc = "Jump to jumplist" },
    { "<leader>jh", "<cmd>FzfLua helptags<cr>", desc = "Jump to help" },
    { "<leader>jk", "<cmd>FzfLua keymaps<cr>", desc = "Jump to keymap" },
    { "<leader>gh", "<cmd>FzfLua git_bcommits<cr>", desc = "Jump to buffer commit history" },
    { "<leader>ca", "<cmd>FzfLua lsp_code_actions<cr>", desc = "Code actions" },
    { "<leader>cl", "<cmd>FzfLua complete_line<cr>", desc = "Complete line" },
    { "<c-f>", "<cmd>FzfLua complete_line<cr>", mode = "i", desc = "Complete line" },
    { "<c-x><c-f>", "<cmd>FzfLua complete_path<cr>", mode = "i", desc = "Complete path" },
    { "qw", "<cmd>FzfLua lines<cr>", desc = "Search buffer lines" },
    { "``", "<cmd>FzfLua resume<cr>", desc = "Resume last FzfLua search" },
    {
      "<Leader>jm",
      "<cmd>FzfLua oldfiles cwd=$PWD<cr>",
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
          cmd = "git diff --name-only --relative upstream/main HEAD",
        })
      end,
      desc = "Jump to files in last commit",
    },
  },
  cmd = { "FzfLua" },
}
