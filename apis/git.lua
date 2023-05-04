function pull(file, target_file, repository)
  repository = repository or "TimoHocker/cc-programs"
  if string.sub(file, -4) ~= '.lua' then
    file = file .. '.lua'
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
  pull("apis/git.lua", "apis/git.lua");
  pull("cli/git.lua", "cli/git.lua");
end

return {
  pull = pull,
  update_git = update_git
}