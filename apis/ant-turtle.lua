local Log = require("/apis/log")

Ant = {
  new = function(self, modem, name)
    if not turtle then
      error("This is not a turtle")
    end

    local o = {}
    setmetatable(o, { __index = self })
    o.modem = modem
    o.name = name or os.getComputerLabel()
    if o.name == nil then
      error("No name provided and no computer label set")
    end
    o.location = vector.new(0, 0, 0)
    o.active = false
    o.running = false
    o.log = Log:new()
    return o
  end,

  start = function(self)
    print("Starting ant with name " .. self.name)
    rednet.open(self.modem)
    self.log:enable()
    if (rednet.lookup("ant", self.name) ~= nil) then
      error("Ant with name " .. self.name .. " already exists")
    end
    print("Registering hostname " .. self.name)
    rednet.host("ant", self.name)
    self:update_location()
    rednet.broadcast("login " .. self.name .. " " .. self:location_str(), "ant")
    self:run()
  end,

  run = function(self)
    self.running = true
    self.active = true
    while self.active do
      local data = { os.pullEventRaw() }
      if data[1] == "terminate" then
        self:stop()
      elseif data[1] == "rednet_message" and data[4] == "ant" then
        self:handle_message(data[2], data[3])
      end
    end
    self.running = false
    self:after_stop()
  end,

  handle_message = function(self, id, message)
    if message == "ping" then
      print("Received ping from " .. id)
      rednet.send(id, "pong " .. self.name .. " " .. self:location_str(), "ant")
    elseif message == "stop" then
      print("Received stop from " .. id)
      self:stop()
    elseif message == "forward" then
      print("Received forward from " .. id)
      turtle.forward()
      self:update_location()
    elseif message == "back" then
      print("Received back from " .. id)
      turtle.back()
      self:update_location()
    elseif message == "up" then
      print("Received up from " .. id)
      turtle.up()
      self:update_location()
    elseif message == "down" then
      print("Received down from " .. id)
      turtle.down()
      self:update_location()
    elseif message == "left" then
      print("Received left from " .. id)
      turtle.turnLeft()
      self:update_location()
    elseif message == "right" then
      print("Received right from " .. id)
      turtle.turnRight()
      self:update_location()
    end
  end,

  update_location = function(self)
    print("locating turtle with gps")
    local x, y, z = gps.locate(2, true)
    if x == nil then
      print("Could not locate turtle")
      self.position = nil
    else
      self.position = vector.new(x, y, z)
    end
    rednet.broadcast("update " .. self.name .. " " .. self:location_str(), "ant")
  end,

  location_str = function(self)
    if self.position == nil then
      return "unknown"
    else
      return self.position:tostring()
    end
  end,

  stop = function(self)
    self.active = false
  end,

  after_stop = function(self)
    print("Stopping ant")
    print("Broadcasting logout")
    rednet.broadcast("logout " .. self.name, "ant")
    print("Unregistering hostname")
    rednet.unhost("ant", self.name)
    rednet.close(self.modem)
    print("Ant stopped")
  end
}

return Ant
