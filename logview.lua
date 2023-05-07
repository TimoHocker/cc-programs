rednet.open("top")
local monitor = peripheral.find("monitor")
monitor.clear()
local w, h = monitor.getSize()
local line = 1

local function print_line(text)
  monitor.setCursorPos(1, line)
  local remainder = ""
  if #text > w then
    remainder = text:sub(w + 1)
    text = text:sub(1, w)
  end
  monitor.write(text)
  if line < h then
    line = line + 1
  else
    monitor.scroll(1)
  end
  if remainder ~= "" then
    print_line(remainder)
  end
end

local function print_text(id, text)
  if text:sub(1, 3) == "[W]" then
    monitor.setTextColor(colors.yellow)
  elseif text:sub(1, 3) == "[E]" then
    monitor.setTextColor(colors.red)
  else
    monitor.setTextColor(colors.white)
  end
  print_line(id .. ": " .. text)
end

while true do
  local id, message = rednet.receive("log")
  print_text(id, message)
end
