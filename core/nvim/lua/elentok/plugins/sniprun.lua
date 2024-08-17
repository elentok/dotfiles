return {
  "michaelb/sniprun",
  branch = "master",

  build = "sh install.sh",
  -- do 'sh install.sh 1' if you want to force compile locally
  -- (instead of fetching a binary from the github release). Requires Rust >= 1.65

  opts = {},
  cmd = { "SnipRun" },
  keys = {
    { "<leader>sr", ":SnipRun<cr>", mode = { "v" }, desc = "SnipRun" },
  },
}
