-- function goto_alternate_file() end

local test_regex_str = "[_.]test$"
local test_regex = vim.regex(test_regex_str)

local function is_test(basename)
  return test_regex:match_str(basename)
end

local function find_alternate_file()
  local path = vim.fn.expand("%:h")
  local basename = vim.fn.expand("%:t:r")
  local extension = vim.fn.expand("%:t:e")

  local alternate = nil
  put("is_test", basename)
  if is_test(basename) then
    local code_basename = vim.fn.substitute(basename, test_regex_str, "", "")
    alternate = path .. "/" .. code_basename .. "." .. extension
  else
    for _, suffix in ipairs({ "_test", ".test" }) do
      local fullpath = path .. "/" .. basename .. suffix .. "." .. extension
      if vim.fn.filereadable(fullpath) ~= 0 then
        alternate = fullpath
        break
      end
    end
  end

  return alternate
end

local function goto_alternate_file()
  local alternate = find_alternate_file()
  if alternate == nil then
    print("Alternate file could not be found.")
  else
    vim.cmd("edit " .. alternate)
  end
end

vim.keymap.set("n", "<space>jo", goto_alternate_file, { desc = "Jump between code and test" })
