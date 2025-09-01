local allow = vim.fn.findfile(".no-ai", ".;") == ""

if not allow then print(" Found .no-ai, not initializing AI plugins") end

return { allow = allow }
