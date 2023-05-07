local Log = {
  new = function(self)
    local o = {}
    setmetatable(o, { __index = self })
    o.enabled = false
    return o
  end,

  enable = function(self)
    if not rednet.isOpen() then
      error("Rednet is not open")
    end
    self.enabled = true
  end,

  disable = function(self)
    self.enabled = false
  end,

  log = function(self, message)
    if self.enabled then
      rednet.broadcast(message, "log")
    end
  end,

  error = function(self, message)
    self:log("[E] " .. message)
  end,

  warn = function(self, message)
    self:log("[W] " .. message)
  end
}

return Log
