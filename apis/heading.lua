local heading = {
  north = 0,
  east = 1,
  south = 2,
  west = 3,

  left = function(heading)
    return (heading + 3) % 4
  end,

  right = function(heading)
    return (heading + 1) % 4
  end,

  determine = function(self)
    if not turtle then
      error("Not a turtle")
    end
    local x, _, z = gps.locate()
    if x == nil then
      return nil
    end
    local result = nil
    local turns = 0
    for _ = 1, 4 do
      if turtle.getFuelLevel() < 2 then
        break
      end
      if turtle.forward() then
        local x2, _, z2 = gps.locate()
        turtle.back()
        if x2 ~= nil then
          if x2 > x then
            result = self.east
            break
          elseif x2 < x then
            result = self.west
            break
          elseif z2 > z then
            result = self.south
            break
          elseif z2 < z then
            result = self.north
            break
          end
        end
      end
      turtle.turnRight()
      turns = turns + 1
    end
    if turns > 2 then
      for _ = 1, 4 - turns do
        turtle.turnRight()
      end
    else
      for _ = 1, turns do
        turtle.turnLeft()
      end
    end
    if (result ~=nil) then
      for _ = 1, turns do
        result = self.left(result)
      end
    end
    return result
  end
}

return heading
