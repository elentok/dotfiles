local filetypes = {
  "javascript",
  "javascriptreact",
  "javascript.jsx",
  "typescript",
  "typescriptreact",
  "typescript.tsx",
}

local function root(bufnr)
  local file = vim.api.nvim_buf_get_name(bufnr)

  return vim.fs.root(file, {

    "tsconfig.json",

    "jsconfig.json",

    "package.json",

    ".git",
  })
end

local function major(root_dir)
  local package_json = root_dir .. "/node_modules/typescript/package.json"

  if vim.fn.filereadable(package_json) == 0 then return nil end

  local ok, package = pcall(vim.json.decode, table.concat(vim.fn.readfile(package_json), "\n"))

  if not ok or not package.version then return nil end

  return tonumber(package.version:match("^(%d+)"))
end

return {
  root = root,
  major = major,
  filetypes = filetypes,
}
