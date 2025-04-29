local allow = vim.fn.findfile(".no-ai", ";.") == ""

if not allow then
  print("Found .no-ai, not initializing AI plugins")
else
  print("No .no-ai found, AI plugins allowed")
end

return { allow = allow }
