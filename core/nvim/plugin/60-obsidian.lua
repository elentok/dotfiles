require("obsidian").setup({
  ---@diagnostic disable-next-line: missing-fields
  ui = {
    enable = false,
  },
  legacy_commands = false,
  workspaces = {
    {
      name = "notes",
      path = "~/notes",
    },
  },
  daily_notes = {
    folder = "daily",
    date_format = "%Y/%m/%Y-%m-%d",
  },
  frontmatter = {
    enabled = false,
  },
  completion = {
    blink = true,
    create_new = false,
  },
  link = {
    style = function(opts) return require("obsidian.util").wiki_link_id_prefix(opts) end,
  },
  picker = {
    name = "snacks.pick",
  },
  checkbox = {
    order = { " ", "x", "/", "w", "r" },
  },
  footer = {
    enabled = false,
  },
  new_notes_location = "current_dir",
  note_id_func = function(title)
    local clean_title = nil
    if title ~= nil then
      -- If title is given, transform it into valid file name.
      clean_title = title:gsub(" ", "-"):gsub("[^A-Za-z0-9-]", ""):lower()
    end

    if clean_title == nil then return tostring(os.time()) end

    return clean_title
  end,
})

vim.keymap.set("n", "<leader>ob", ":Obsidian<cr>", { desc = "Obsidian menu" })
