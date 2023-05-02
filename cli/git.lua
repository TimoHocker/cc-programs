os.loadAPI("apis/git.lua")

local args = {...}

local cmd = args[1]

if cmd == "pull" then
  table.remove(args, 1)
  git.pull(table.unpack(args))
end
if cmd == "update" then
  git.update_git()
end
