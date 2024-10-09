---@param str string
---@return string
local function snake_to_camel_case(str)
  local result, _ = str
    :gsub("(%a)(%w*)", function(a, b)
      return a:upper() .. b
    end)
    :gsub("_", "")

  return result
end

return {
  snake_to_camel_case = snake_to_camel_case,
}
