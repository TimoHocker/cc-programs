local function get_url(file, repository)
  repository = repository or "TimoHocker/cc-programs"
  return "https://raw.githubusercontent.com/" .. repository .. "/master/" .. file
end

function pull(file, target_file, repository)
  local url = get_url(file, repository)
  target_file = target_file or file
  os.run({}, "/rom/programs/wget", url, target_file)
end

function run(file, repository)
  local url = get_url(file, repository)
  os.run({}, "/rom/programs/wget", "run", url)
end

function update_git()
  pull("apis/git.lua", "apis/git.lua");
  pull("cli/git.lua", "cli/git.lua");
end
