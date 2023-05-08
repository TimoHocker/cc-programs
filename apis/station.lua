local heading = require("/apis/heading")

local station = {
  require_station = function(x, y, z, h)
    if not turtle then
      error("Not a turtle")
    end
    local gx, gy, gz = gps.locate()
    if gx ~= x or gy ~= y or gz ~= z then
      error("Turtle is not at station")
    end
    local gh = heading:determine()
    for _ = 1, (gh + 4 - h) % 4 do
      turtle.turnLeft()
    end
  end
}

return station
