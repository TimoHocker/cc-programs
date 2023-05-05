string.split = function(str, delimiter)
  local result = {}
  while true do
    local pos = string.find(str, delimiter)
    if pos == nil then
      table.insert(result, str)
      break
    end
    table.insert(result, string.sub(str, 1, pos - 1))
    str = string.sub(str, pos + 1)
  end
  return result
end
