function start(modem, name)
  if not turtle then
    error("This is not a turtle")
  end
  name = name or os.getComputerLabel()
  if name == nil then
    error("No name provided and no computer label set")
  end
  print("Starting ant with name " .. name)
  rednet.open(modem)
  if (rednet.lookup("ant", name) ~= nil) then
    error("Ant with name " .. name .. " already exists")
  end
  print("Registering hostname " .. name)
  rednet.host("ant", name)
  print("locating turtle with gps")
  local x,y,z = gps.locate(2, true)
  if x == nil then
    error("Could not locate turtle")
  end
  local position = vector.new(x,y,z)
  rednet.broadcast("login " .. name .. " " .. position:tostring(), "ant")
  return { modem = modem, name = name, position = position }
end

function run(config)
  while true do
    local id, message = rednet.receive("ant")
    if message == "ping" then
      print("Received ping from " .. id)
      rednet.send(id, "pong " .. config.name .. " " .. config.position:tostring(), "ant")
    end
  end
end

function stop(config)
  rednet.unhost("ant", config.name)
  rednet.close(config.modem)
end

return {
  start = start,
  run = run,
  stop = stop
}
