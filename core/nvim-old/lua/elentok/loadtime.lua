local start = vim.fn.reltime()

local function show_load_time()
  local elapsed_millisec = vim.fn.reltimefloat(vim.fn.reltime(start)) * 1000
  print(string.format("Loaded in %dms", elapsed_millisec))
end

vim.api.nvim_create_autocmd({ "VimEnter" }, { pattern = "*", callback = show_load_time })
