function pull(file, target_file, repository)
  repository = repository or "TimoHocker/cc-programs"
  if file:sub(-4) ~= '.lua' then
    file = file .. '.lua'
  end
  if file:sub(1, 1) == '/' then
    file = file:sub(2)
  end
  local  url = "https://raw.githubusercontent.com/" .. repository .. "/master/" .. file
  print("Pulling file " .. url)
  local request = http.get(url);
  if not request then
    error("http error");
  end
  local content = request.readAll()
  if not content then
    error("no content received");
  end
  request.close()
  target_file = target_file or file
  print("Writing file " .. target_file)
  local f = fs.open(target_file, "w")
  f.write(content)
  f.close()
end

function update_git()
  pull("apis/git.lua", "/apis/git.lua");
  pull("git.lua", "/git.lua");
end

function pull_all()
  if not fs.exists("/apis") then
    fs.makeDir("/apis");
  end
  if not fs.exists("/setup") then
    fs.makeDir("/setup");
  end
  pull("/apis/ant-controller.lua");
  pull("/apis/ant-turtle.lua");
  pull("/apis/git.lua");
  pull("/apis/heading.lua");
  pull("/apis/log.lua");
  pull("/apis/station.lua");
  pull("/apis/strutils.lua");

  pull("/setup/git-setup.lua");
  pull("/setup/gps-setup.lua");

  pull("/ant-controller.lua");
  pull("/ant-turtle.lua");
  pull("/git.lua");
  pull("/logview.lua");
end

return {
  pull = pull,
  update_git = update_git,
  pull_all = pull_all
}