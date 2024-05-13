vim.api.nvim_create_autocmd({ "BufReadPost" }, {
  callback = function()
    local first_line = vim.api.nvim_buf_get_lines(0, 0, 1, false)[0]
    put(first_line)
  end,
})

-- vim.api.nvim_create_autocmd({ "BufWritePre" }, {
--   callback = function()
--     -- local first_line = vim.api.nvim_buf_get_lines(0, 0, 1, false)[0]
--     put("BufWritePre encrypted=", vim.b["encrypted"])
--   end,
-- })

---@return string[]
---@param lines string | string[]
---@param password string
local function encrypt_lines(lines, password)
  return vim.fn.systemlist(
    "openssl enc -aes-256-cbc -pbkdf2 -salt -in - -out - -k " .. password,
    lines
  )
end

local ENCRYPTED_PREFIX = "# <<<encrypted>>>"

local function encrypt()
  local password = vim.b["password"] or vim.fn.inputsecret("Enter password: ")
  local buf_lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
  local encrypted_lines = encrypt_lines(buf_lines, password)

  table.insert(encrypted_lines, 1, ENCRYPTED_PREFIX)

  vim.fn.writefile(encrypted_lines, vim.fn.expand("%"))
  vim.b["password"] = password
  vim.b["encrypted"] = true
  -- buftype="acwrite" means save using the BufWriteCmd command
  vim.bo.buftype = "acwrite"
  vim.bo.modified = false

  print("Encrypted " .. vim.fn.expand("%:t"))

  -- vim.api.nvim_buf_set_lines(0, 0, 0, false, { "# <<<encrypted>>>" })
  -- vim.api.nvim_buf_set_lines(0, 1, -1, false, encrypted_lines)
end

local function createWriteAutoCmd()
  if vim.b["encryptionAutoCmd"] ~= nil then
    return
  end

  vim.b["encryptionAutoCmd"] = vim.api.nvim_create_autocmd({ "BufWriteCmd" }, {
    callback = function()
      put("encrypted", vim.b["encrypted"])
      if vim.b["encrypted"] ~= true then
        return
      end

      encrypt()
    end,
  })
end

vim.api.nvim_create_user_command("X", function()
  encrypt()
  createWriteAutoCmd()
end, {})
