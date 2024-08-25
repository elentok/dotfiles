-- vim.keymap.set("t", "")

vim.keymap.set("t", "<c-u>", "<c-\\><c-n><c-u>")
vim.keymap.set("t", "<c-d>", "<c-\\><c-n><c-d>")
vim.keymap.set("t", "<c-;>", "<c-\\><c-n>")

-- local function map(mode, lhs, rhs)
--   vim.keymap.set(mode, lhs, rhs)

--   if vim.g.neovide and lhs.match("^<c-", "") then
--     local lhs_with_cmd = lhs.gsub("^<c-", "<D-", "")
--     vim.keymap.set("t", lhs_with_cmd, rhs)
--   end
-- end

---@param direction "h" | "j" | "k" | "l"
-- local function termNavigate(direction)

--
-- end

-- tmap("<c-w>", "<c-\\><c-n><c-w>")
-- vim.keymap.set("t", "<c-h>", "<c-\\><c-n><c-w>h")
-- vim.keymap.set("t", "<c-j>", "<c-\\><c-n><c-w>j")
-- vim.keymap.set("t", "<c-k>", "<c-\\><c-n><c-w>k")
-- vim.keymap.set("t", "<c-l>", "<c-\\><c-n><c-w>l")

-- map("n", "<c-a>c", ":TermNewTab fish")
-- map("t", "<c-a>a", "<c-a>")
-- map("t", "<c-a>c", "<c-\\><c-n>:TermNewTab fish")
