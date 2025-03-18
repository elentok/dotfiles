if not vim.g.vscode then
  return
end

local vscode_action = function(cmd, opts)
  return function()
    require("vscode").action(cmd, opts)
  end
end

vim.keymap.set({ "n" }, "<leader>ts", vscode_action("workbench.action.toggleSidebarVisibility"))
vim.keymap.set({ "n" }, "<leader><leader>", vscode_action("workbench.action.toggleZenMode"))
vim.keymap.set({ "n" }, "<leader>tp", vscode_action("workbench.actions.view.problems"))
vim.keymap.set({ "n" }, "gr", vscode_action("editor.action.goToReferences"))
vim.keymap.set({ "n" }, "<leader>js", vscode_action("workbench.action.openSettingsJson"))
vim.keymap.set({ "n" }, "K", vscode_action("editor.action.showHover"))
vim.keymap.set({ "n" }, "<D-u>", "<C-u>")
vim.keymap.set({ "n" }, "<D-d>", "<C-d>")

vim.keymap.set("n", "<leader>wh", vscode_action("workbench.action.focusLeftGroupWithoutWrap"))
vim.keymap.set("n", "<leader>wj", vscode_action("workbench.action.focusBelowGroupWithoutWrap"))
vim.keymap.set("n", "<leader>wk", vscode_action("workbench.action.focusAboveGroupWithoutWrap"))
vim.keymap.set("n", "<leader>wl", vscode_action("workbench.action.focusRightGroupWithoutWrap"))

vim.keymap.set("n", "<leader>wo", vscode_action("workbench.action.closeOtherEditors"))
vim.keymap.set("n", "<leader>ws", vscode_action("workbench.action.splitEditorDown"))
vim.keymap.set("n", "<leader>wv", vscode_action("workbench.action.splitEditorRight"))
vim.keymap.set("n", "<leader>qq", vscode_action("workbench.action.closeActiveEditor"))
vim.keymap.set("n", "<leader>rn", vscode_action("editor.action.rename"))

vim.keymap.set("n", "<leader>f", vscode_action("workbench.action.quickOpen"))
vim.keymap.set("n", "<leader>js", vscode_action("workbench.action.quickOpen", { args = { "@" } }))
vim.keymap.set("n", "<leader>/", vscode_action("workbench.action.quickOpen", { args = { "%" } }))
vim.keymap.set("n", "<leader>jg", vscode_action("workbench.view.scm"))
vim.keymap.set("n", "<leader>w/", function()
  require("vscode").action(
    "workbench.action.findInFiles",
    { args = { query = vim.fn.expand("<cword>") } }
  )
end)
