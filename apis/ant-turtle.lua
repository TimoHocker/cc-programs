Ant = {
  new = function(self, modem, name)
    if not turtle then
      error("This is not a turtle")
    end

    local o = {}
    setmetatable(o, { __index = self })
    o.modem = modem
    o.name = name or os.getComputerLabel()
    if name == nil then
      error("No name provided and no computer label set")
    end
    o.location = vector.new(0, 0, 0)
    o.active = false
    o.running = false
    return o
  end,

  start = function(self)
    print("Starting ant with name " .. self.name)
    rednet.open(self.modem)
    if (rednet.lookup("ant", self.name) ~= nil) then
      error("Ant with name " .. self.name .. " already exists")
    end
    print("Registering hostname " .. self.name)
    rednet.host("ant", self.name)
    print("locating turtle with gps")
    local x, y, z = gps.locate(2, true)
    if x == nil then
      error("Could not locate turtle")
    end
    self.position = vector.new(x, y, z)
    rednet.broadcast("login " .. self.name .. " " .. self.position:tostring(), "ant")
  end,

  run = function(self)
    self.running = true
    self.active = true
    while self.active do
      local id, message = rednet.receive("ant", 5)
      if id and self.active then
        self:handle_message(id, message)
      end
    end
    self.running = false
  end,

  handle_message = function(self, id, message)
    if message == "ping" then
      print("Received ping from " .. id)
      rednet.send(id, "pong " .. self.name .. " " .. self.position:tostring(), "ant")
    end
  end,

  stop = function(self)
    self.active = false
    while self.running do
      sleep(0.1)
    end
    rednet.broadcast("logout " .. self.name, "ant")
    rednet.unhost("ant", self.name)
    rednet.close(self.modem)
  end
}

return Ant
