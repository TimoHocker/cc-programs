git= require("apis.git")

local args = {...}

local cmd = args[1]

if cmd == "pull" then
  table.remove(args, 1)
  git.pull(table.unpack(args))
end
if cmd == "update" then
  git.update_git()
  print("Updated git")
end
if cmd == "run" then
  table.remove(args, 1)
  git.pull(args[1], ".git-run.temp.lua")
  table.remove(args, 1)
  print("Running " .. args[1])
  shell.run(".git-run.temp.lua", table.unpack(args))
  print("Finished running " .. args[1] .. ", cleaning up")
  fs.delete(".git-run.temp.lua")
end
