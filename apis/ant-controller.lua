require("/apis/strutils")
local Log = require("/apis/log")

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
    o.log = Log:new()
    return o
  end,

  start = function(self)
    print("Starting ant controller")
    rednet.open(self.modem)
    self.log:enable()
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

  turtle_count = function(self)
    local count = 0;
    for k, v in pairs(self.ants) do
      count = count + 1
    end
    return count
  end,

  wrap_select = function(self)
    local count = self:turtle_count()
    if self.selected_line <= 0 then
      self.selected_line = count
    end
    if self.selected_line > count then
      self.selected_line = 1
    end
  end,

  handle_key = function(self, key)
    if key == keys.w then
      if self.mode == "list" then
        if self.selected_line == nil then
          self.selected_line = #self.ants
        else
          self.selected_line = self.selected_line - 1
          self:wrap_select()
        end
        self:print_screen()
      else
        self:move_turtle("forward")
      end
    elseif key == keys.s then
      if self.mode == "list" then
        if self.selected_line == nil then
          self.selected_line = 1
        else
          self.selected_line = self.selected_line + 1
          self:wrap_select()
        end
        self:print_screen()
      else
        self:move_turtle("back")
      end
    elseif key == keys.space then
      if self.mode == "list" then
        self.mode = "control"
        self:print_screen()
      else
        self:move_turtle("up")
      end
    elseif key == keys.leftShift then
      self:move_turtle("down")
    elseif key == keys.a then
      self:move_turtle("left")
    elseif key == keys.d then
      self:move_turtle("right")
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
      self.ants[id].id = id
      self.ants[id].name = data[1]
      self.ants[id].location = data[2]
    else
      table.remove(self.ants, id)
    end
    self:print_screen()
  end,

  move_turtle = function(self, direction)
    if (self.mode ~= "control") then
      return
    end
    local ant = self.ants[self.selected_id]
    if ant then
      rednet.send(ant.id, direction, "ant")
    end
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
    if self.mode == "list" then
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
        local w, h = term.getSize()
        term.setCursorPos(w - #ant.location + 1, line + 1)
        term.write(ant.location)
        line = line + 1
      end
    else
      local ant = self.ants[self.selected_id]
      term.setCursorPos(1, 3)
      term.write("Controlling: " .. ant.id .. " " .. ant.name)
      term.setCursorPos(1, 4)
      term.write("Location: " .. ant.location)
      term.setCursorPos(1, 5)
      term.write("Control with WASD, Space and LShift, X to exit")
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
