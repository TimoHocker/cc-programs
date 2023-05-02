function pull(file, target_file, repository)
  repository = repository or "TimoHocker/cc-programs"
  local  url = "https://raw.githubusercontent.com/" .. repository .. "/master/" .. file
  local content = http.get(url).readAll()
  if not content then
    error("could not pull file " .. url);
  end
  target_file = target_file or file
  local f = fs.open(target_file, "w")
  f.write(content)
  f.close()
end
