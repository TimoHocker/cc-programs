function pull(file, target_file, repository)
  repository = repository or "TimoHocker/cc-programs"
  local  url = "https://raw.githubusercontent.com/" .. repository .. "/master/" .. file
  print("Pulling file " .. url)
  local request = http.get(url);
  local content = request.readAll()
  request.close()
  if not content then
    error("http error");
  end
  target_file = target_file or file
  print("Writing file " .. target_file)
  local f = fs.open(target_file, "w")
  f.write(content)
  f.close()
end

function update_git()
  pull("apis/git.lua", "apis/git.lua");
  pull("cli/git.lua", "cli/git.lua");
end
