vim.api.nvim_create_user_command(
  "Md2Slack",
  ":silent '<,'>w !md2slack | dotf-clipboard copy",
  { range = "%" }
)
