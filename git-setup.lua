if not fs.exists('apis') then
  fs.makeDir('apis')
end
if not fs.exists('cli') then
  fs.makeDir('cli')
end

if fs.exists('cli/git.lua') then
  fs.delete('cli/git.lua')
end
if fs.exists('apis/git.lua') then
  fs.delete('apis/git.lua')
end

shell.run("wget https://raw.githubusercontent.com/TimoHocker/cc-programs/master/apis/git.lua apis/git.lua")
shell.run("wget https://raw.githubusercontent.com/TimoHocker/cc-programs/master/cli/git.lua cli/git.lua")
