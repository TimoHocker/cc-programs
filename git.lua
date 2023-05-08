git = require("apis.git")

local args = { ... }

local cmd = args[1]

if cmd == "pull" then
  table.remove(args, 1)
  git.pull(table.unpack(args))
elseif cmd == "pull-all" then
  git.pull_all()
elseif cmd == "update" then
  git.update_git()
  print("Updated git")
elseif cmd == "run" then
  table.remove(args, 1)
  local file = args[1]
  git.pull(file, ".git-run.temp.lua")
  table.remove(args, 1)
  print("Running " .. file)
  shell.run(".git-run.temp.lua", table.unpack(args))
  print("Finished running " .. file .. ", cleaning up")
  fs.delete(".git-run.temp.lua")
end
