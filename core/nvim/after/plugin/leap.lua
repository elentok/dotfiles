local leap = require("leap")

-- leap.add_default_mappings()

vim.keymap.set({ "n", "v", "x", "o" }, "s", "<Plug>(leap-forward-to)")
-- vim.keymap.set({ "n", "v", "x", "o" }, "S", "<Plug>(leap-backward-to)")

leap.add_repeat_mappings(";", ",", {
  -- False by default. If set to true, the keys will work like the
  -- native semicolon/comma, i.e., forward/backward is understood in
  -- relation to the last motion.
  relative_directions = true,
  -- By default, all modes are included.
  modes = { "n", "x", "o" },
})
