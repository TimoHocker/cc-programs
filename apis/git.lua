function pull(file, target_file, repository)
  repository = repository or "TimoHocker/cc-programs"
  local  url = "https://raw.githubusercontent.com/" .. repository .. "/master/" .. file
  local request = http.get(url);
  local content = request.readAll()
  request.close()
  if not content then
    error("could not pull file " .. url);
  end
  target_file = target_file or file
  local f = fs.open(target_file, "w")
  f.write(content)
  f.close()
end

function update_git()
  pull("apis/git.lua", "apis/git.lua");
  pull("cli/git.lua", "cli/git.lua");
end
