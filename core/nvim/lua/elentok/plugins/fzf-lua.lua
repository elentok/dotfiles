---@param selected string[]
---@return {hash: string, title: string}|nil
local function get_first_commit(selected)
  if not selected[1] then
    return nil
  end
  local commit = selected[1]
  return { hash = vim.split(commit, " ")[1], title = commit }
end

---@param selected string[]
local function stage_patch(selected)
  local file = selected[1]
  if file == nil then
    return
  end

  put(string.sub(file, 9))

  local git = require("elentok.lib.git")
  git.run({ "add", "-p", string.sub(file, 9) })
end

local function deferred_stage_patch(selected)
  vim.defer_fn(function()
    stage_patch(selected)
  end, 100)
end

---@param selected string[]
local function fixup(selected)
  local commit = get_first_commit(selected)
  if commit == nil then
    return
  end

  local ui = require("elentok.lib.ui")
  local git = require("elentok.lib.git")
  if ui.confirm("Fixup " .. commit.title .. "?") then
    git.run({ "commit", "--fixup", commit.hash })
  end
end

local function deferred_fixup(selected)
  vim.defer_fn(function()
    fixup(selected)
  end, 100)
end

---@param selected string[]
local function open_commit(selected)
  local commit = get_first_commit(selected)
  if commit == nil then
    return
  end

  require("diffview").open(commit.hash .. "^!")
end

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
        ["ctrl-l"] = "select-all+accept",
        ["ctrl-d"] = "half-page-down",
        ["ctrl-u"] = "half-page-up",
        ["ctrl-w"] = "toggle-preview-wrap",
      },
    },
    grep = {
      multiline = 1,
    },
    git = {
      commits = {
        actions = {
          ["ctrl-f"] = deferred_fixup,
          ["ctrl-d"] = open_commit,
        },
      },
      bcommits = {
        actions = {
          ["ctrl-f"] = deferred_fixup,
          ["ctrl-d"] = open_commit,
        },
      },
      status = {
        actions = {
          -- I keep hitting ctrl-x by mistake and resetting
          -- (and there's no confirmation)
          ["ctrl-x"] = false,
          ["ctrl-s"] = deferred_stage_patch,
        },
      },
    },
  },
  keys = {
    {
      "<leader>/",
      "<cmd>FzfLua live_grep<cr>",
      mode = "n",
      desc = "Live grep",
    },
    {
      "<leader>/",
      "<cmd>FzfLua grep_visual<cr>",
      mode = "v",
      desc = "Grep visual",
    },
    {
      "<leader>w/",
      "<cmd>FzfLua grep_cword<cr>",
      mode = "n",
      desc = "Grep word",
    },
    { "<leader>f", "<cmd>FzfLua files<cr>" },
    { "z=", "<cmd>FzfLua spell_suggest<cr>" },
    { "<leader>jb", "<cmd>FzfLua buffers<cr>" },
    { "<leader>jg", "<cmd>FzfLua git_status<cr>", desc = "Jump to git modified" },
    { "<leader>jj", "<cmd>FzfLua jumps<cr>", desc = "Jump to jumplist" },
    { "<leader>jh", "<cmd>FzfLua helptags<cr>", desc = "Jump to help" },
    { "<leader>jk", "<cmd>FzfLua keymaps<cr>", desc = "Jump to keymap" },
    { "<leader>gh", "<cmd>FzfLua git_bcommits<cr>", desc = "Jump to buffer commit history" },
    { "<leader>gl", "<cmd>FzfLua git_commits<cr>", desc = "Jump to commit history" },
    { "<leader>ca", "<cmd>FzfLua lsp_code_actions<cr>", desc = "Code actions" },
    { "<leader>cl", "<cmd>FzfLua complete_line<cr>", desc = "Complete line" },
    { "<c-f>", "<cmd>FzfLua complete_line<cr>", mode = "i", desc = "Complete line" },
    { "<c-x><c-f>", "<cmd>FzfLua complete_path<cr>", mode = "i", desc = "Complete path" },
    { "<space>ll", "<cmd>FzfLua lines<cr>", desc = "Search buffer lines" },
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
