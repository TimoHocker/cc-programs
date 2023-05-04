if not fs.exists('apis') then
  fs.makeDir('apis')
end

if fs.exists('apis/git.lua') then
  fs.delete('apis/git.lua')
end

shell.run("wget https://raw.githubusercontent.com/TimoHocker/cc-programs/master/apis/git.lua /apis/git.lua")
shell.run("wget https://raw.githubusercontent.com/TimoHocker/cc-programs/master/git.lua /git.lua")
