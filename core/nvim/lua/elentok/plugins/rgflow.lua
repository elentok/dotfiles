return {
  "mangelozzi/nvim-rgflow.lua",
  config = function()
    require("rgflow").setup({
      cmd_flags = "--smart-case --fixed-strings --ignore --max-columns 200",

      -- Mappings to trigger RgFlow functions
      default_trigger_mappings = true,
      -- These mappings are only active when the RgFlow UI (panel) is open
      default_ui_mappings = true,
      -- QuickFix window only mapping
      default_quickfix_mappings = true,
    })
  end,
}
