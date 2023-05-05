Ant = {
  new = function(self, modem)
    local o = {}
    setmetatable(o, { __index = self })
    o.modem = modem
    o.active = false
    o.running = false
    o.ants = {}
    return o
  end,

  start = function(self)
    print("Starting ant controller")
    rednet.open(self.modem)
    self:run()
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
    if message:sub(1, 4) == "pong" then
      print("Received pong from " .. id)
      self:update_turtle(id, message:sub(6))
    end
    if message:sub(1, 5) == "login" then
      print(id .. " logged in")
      self:update_turtle(id, message:sub(7))
    end
    if message:sub(1, 6) == "logout" then
      print(id .. " logged out")
      self:update_turtle(id, nil)
    end
  end,

  update_turtle = function(self, id, message)
    if message then
      local name = message:sub(1, message:find(" ") - 1)
      local location = message:sub(message:find(" ") + 1)
      if self.ants[id] == nil then
        self.ants[id] = {}
      end
      self.ants[id].name = name
      self.ants[id].location = location
    else
      self.ants[id] = nil
    end
    self:print_screen()
  end,

  print_screen = function(self)
    print("Ants:")
    for id, ant in pairs(self.ants) do
      print(id .. ": " .. ant.name .. " " .. ant.location)
    end
  end,

  stop = function(self)
    self.active = false
    while self.running do
      sleep(0.1)
    end
    rednet.close(self.modem)
  end
}

return Ant
