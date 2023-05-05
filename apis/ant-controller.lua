require("/apis/strutils")

Ant = {
  new = function(self, modem)
    local o = {}
    setmetatable(o, { __index = self })
    o.modem = modem
    o.active = false
    o.running = false
    o.ants = {}
    o.selected_id = nil
    o.selected_line = nil
    o.mode = "list"
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
      local data = { os.pullEventRaw() }
      if data[1] == "terminate" then
        self:stop()
      elseif data[1] == "rednet_message" and data[4] == "ant" then
        self:handle_message(data[2], data[3])
      elseif data[1] == "key" then
        self:handle_key(data[2])
      end
    end
    self.running = false
    self:after_stop()
  end,

  wrap_slect = function(self)
    if self.selected_line <= 0 then
      self.selected_line = #self.ants
    end
    if self.selected_line > #self.ants then
      self.selected_line = 1
    end
  end,

  handle_key = function(self, key)
    if key == keys.up then
      if self.selected_line == nil then
        self.selected_line = #self.ants
      else
        self.selected_line = self.selected_line - 1
        self:wrap_slect()
      end
      self:print_screen()
    elseif key == keys.down then
      if self.selected_line == nil then
        self.selected_line = 1
      else
        self.selected_line = self.selected_line + 1
        self:wrap_slect()
      end
      self:print_screen()
    elseif key == keys.space then
      self.mode = "control"
      self:print_screen()
    elseif key == keys.x then
      self.mode = "list"
      self:print_screen()
    end
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
      self.ants:remove(id)
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
    local line = 1
    for id, ant in pairs(self.ants) do
      term.setCursorPos(1, line + 1)
      if line == self.selected_line then
        term.setBackgroundColor(colors.white)
        term.setTextColor(colors.black)
        self.selected_id = id
      end
      term.write(id)
      term.setBackgroundColor(colors.black)
      term.setTextColor(colors.white)
      term.write(" " .. ant.name)
      local w,h = term.getSize()
      term.setCursorPos(w - #ant.location + 1, line + 1)
      term.write(ant.location)
      line = line + 1
    end
  end,

  stop = function(self)
    self.active = false
  end,

  after_stop = function(self)
    rednet.close(self.modem)
    term.clear()
    term.setCursorPos(1, 1)
    print("Ant Controller stopped")
  end
}

return Ant
