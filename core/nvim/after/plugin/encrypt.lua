if true then
  return
end
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
    "openssl enc -aes-256-cbc -pbkdf2 -salt -in - -out - -k " .. password .. " | base64",
    lines
  )
end

---@return string[]
---@param lines string | string[]
---@param password string
local function decrypt_lines(lines, password)
  return vim.fn.systemlist(
    "base64 --decode | openssl enc -d -aes-256-cbc -pbkdf2 -salt -in - -out - -k " .. password,
    lines
  )
end

local ENCRYPTED_PREFIX = "# <<<encrypted>>>"

---@return string
local function getPassword()
  local password = vim.b["password"]
  if password == nil then
    password = vim.fn.inputsecret("Enter password: ")
    vim.b["password"] = password
  end
  return password
end

local function encrypt()
  local password = getPassword()
  local buf_lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
  local encrypted_lines = encrypt_lines(buf_lines, password)

  table.insert(encrypted_lines, 1, ENCRYPTED_PREFIX)

  vim.fn.writefile(encrypted_lines, vim.fn.expand("%"))
  vim.bo.modified = false
  print("Encrypted " .. vim.fn.expand("%:t"))
end

local function decrypt()
  local password = getPassword()
  local encrypted_lines = vim.api.nvim_buf_get_lines(0, 1, -1, false)
  local decrypted_lines = decrypt_lines(encrypted_lines, password)
  if vim.v.shell_error ~= 0 then
    vim.notify("Error decrypting", vim.log.levels.ERROR)
    return
  end

  vim.fn.timer_start(0, function()
    vim.api.nvim_buf_set_lines(0, 0, -1, false, decrypted_lines)
    vim.bo.modified = false
  end)
end

local function createWriteAutoCmd()
  if vim.b["encryptionAutoCmd"] ~= nil then
    return
  end

  vim.b["encryptionAutoCmd"] = vim.api.nvim_create_autocmd({ "BufWriteCmd" }, {
    callback = function()
      if vim.b["encrypted"] ~= true then
        return
      end

      encrypt()
    end,
  })
end

local function setupBuffer()
  -- buftype="acwrite" means save using the BufWriteCmd command
  vim.bo.buftype = "acwrite"
  vim.bo.swapfile = false
  vim.bo.undofile = false
  vim.b["encrypted"] = true
  createWriteAutoCmd()
end

vim.api.nvim_create_user_command("X", function()
  setupBuffer()
  encrypt()
end, {})

vim.api.nvim_create_autocmd({ "BufReadPost" }, {
  callback = function()
    local first_line = vim.api.nvim_buf_get_lines(0, 0, 1, false)[1]
    if first_line == ENCRYPTED_PREFIX then
      setupBuffer()
      decrypt()
    end
  end,
})
