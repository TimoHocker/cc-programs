require("/apis/strutils")

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
    rednet.broadcast("ping", "ant")
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
    local data = message:split(" ")
    if data[1] == "pong" or data[1] == "update" or data[1] == "login" then
      print("Received update from " .. id)
      table.remove(data, 1)
      self:update_turtle(id, data)
    elseif data[1] == "logout" then
      print(id .. " logged out")
      self:update_turtle(id, nil)
    end
  end,

  update_turtle = function(self, id, data)
    if data then
      if self.ants[id] == nil then
        self.ants[id] = {}
      end
      self.ants[id].name = data[1]
      self.ants[id].location = data[2]
    else
      self.ants[id] = nil
    end
    self:print_screen()
  end,

  print_screen = function(self)
    term.clear()
    term.setCursorPos(1, 1)
    term.setBackgroundColor(colors.yellow)
    term.setTextColor(colors.black)
    term.write("Ant Controller")
    term.setCursorPos(1, 2)
    term.setBackgroundColor(colors.black)
    term.setTextColor(colors.white)
    local line = 2
    for id, ant in pairs(self.ants) do
      term.setCursorPos(1, line)
      term.write(id .. ": " .. ant.name .. " " .. ant.location)
      line = line + 1
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
