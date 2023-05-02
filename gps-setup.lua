if not fs.exists("startup") then
  fs.makeDir("startup")
end

local args = {...}
local file = fs.open("startup/gps-host.lua", "w")
file.writeLine("print(\"starting gps host\")")
file.writeLine("shell.run(\"gps host " .. args[1] .. " " .. args[2] .. " " .. args[3] .. "\")")
file.close()
