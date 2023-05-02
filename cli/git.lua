os.loadAPI("apis/git.lua")

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
  shell.run(".git-run.temp.lua", table.unpack(args))
  fs.delete(".git-run.temp.lua")
end
