package.path = package.path
  .. ";"
  .. vim.fn.expand("$HOME")
  .. "/.luarocks/share/lua/5.1/?/init.lua;"
package.path = package.path .. ";" .. vim.fn.expand("$HOME") .. "/.luarocks/share/lua/5.1/?.lua;"

return {
  "3rd/image.nvim",
  config = function()
    if vim.g.neovide then
      return
    end

    require("image").setup({
      integrations = {
        markdown = {
          enabled = true,
          only_render_image_at_cursor = true,
        },
      },
      editor_only_render_when_focused = true, -- auto show/hide images when the editor gains/looses focus
      tmux_show_only_in_active_window = true, -- auto show/hide images in the correct Tmux window (needs visual-activity off)
      max_width = 100,
      max_width_window_percentage = 90,
    })
  end,
  ft = { "markdown" },
}
