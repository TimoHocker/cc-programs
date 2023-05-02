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
  git.pull(args[2], ".git-run.temp.lua", args[3])
  shell.run(".git-run.temp.lua")
  fs.delete(".git-run.temp.lua")
end
