local function identify(value)
  if type(value) == "table" then
    if vim.islist(value) then
      return "list"
    else
      return "table"
    end
  else
    return "primitive"
  end
end

local function deep_merge(target, source)
  for key, value in pairs(source) do
    if target[key] == nil then
      target[key] = value
    else
      local source_type = identify(value)
      local target_type = identify(target[key])

      if target_type == "primitive" then
        target[key] = target_type
      elseif target_type ~= source_type then
        if not vim.tbl_isempty(target[key]) then
          print(
            "WARNING: deep_merge(): merging key '"
              .. key
              .. '" from type "'
              .. source_type
              .. '" to "'
              .. target_type
              .. '"'
          )
        end
        target[key] = value
      elseif target_type == "table" then
        deep_merge(target[key], value)
      else -- list
        vim.list_extend(target[key], value)
      end
    end
  end

  return target
end

return deep_merge
