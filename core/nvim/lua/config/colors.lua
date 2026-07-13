vim.cmd.colorscheme("catppuccin")

---@param name string highlight group name
---@param val vim.api.keyset.highlight
local function update(name, val)
  val.update = true
  vim.api.nvim_set_hl(0, name, val)
end

local function link(from, to) update(from, { link = to }) end

local color_surface = "#313244"
local color_blue = "#89b4fa"
local color_subtle = "#a6adc8"
local color_overlay = "#6c7086"
local color_red = "#f38ba8"
-- local color_surface1 = "#45475a"
-- local color_yellow = "#f9e2af"
-- local color_teal = "#94e2d5"
local color_orange = "#fab387"

update("ElDim", { fg = color_surface })
update("ElLink", { fg = color_blue })

link("Identifier", "Normal")

update("Delimiter", { fg = color_overlay })
update("Conditional", { fg = color_subtle })
update("Keyword", { fg = color_subtle })
update("Include", { fg = color_subtle })
update("Structure", { fg = color_subtle })
update("Type", { fg = color_subtle })
update("DiagnosticUnderlineError", { fg = color_red, undercurl = true })
update("DiagnosticUnderlineWarn", { fg = color_orange, undercurl = true })
update("DiagnosticError", { fg = color_red })
update("DiagnosticWarn", { fg = color_orange })
update("Comment", { italic = true, fg = color_overlay })

update("@lsp.typemod.variable.declaration.typescript", { link = "Function" })
-- update("@lsp.typemod.function.declaration.typescript", { fg = color_orange })

link("WinSeparator", "ElDim")
link("FzfLuaBorder", "NormalFloat")
link("FzfLuaNormal", "NormalFloat")
update("FzfLuaBorder", { fg = color_surface })

link("@markup.link.label.markdown_inline", "ElLink")
