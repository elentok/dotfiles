package.path = package.path
  .. ";"
  .. vim.fn.expand("$HOME")
  .. "/.luarocks/share/lua/5.1/?/init.lua;"
package.path = package.path .. ";" .. vim.fn.expand("$HOME") .. "/.luarocks/share/lua/5.1/?.lua;"

return {
  "3rd/image.nvim",
  config = function()
    require("image").setup({
      integrations = {
        markdown = {
          enabled = true,
          only_render_image_at_cursor = true,
        },
      },
      max_width = 100,
      max_wdith_window_percentage = 90,
    })
  end,
  ft = { "markdown" },
}
