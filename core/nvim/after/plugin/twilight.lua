local ok, twilight = pcall(require, "twilight")

if not ok then
  return
end

twilight.setup({
  context = 14,
  dimming = {
    alpha = 0.5,
  },
  expand = {
    "function",
    "method",
    "table",
  },
})
