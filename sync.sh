for f in 0 7 8 9 10; do
  rsync -rv --exclude=startup.lua --exclude=.git --exclude=README.md --exclude=sync.sh --rsync-path="sudo rsync" ./ timo@scode.ovh:/root/docker/services/minecraft_atm8/data/world/computercraft/computer/$f/;
done
ssh timo@scode.ovh "sudo chown -R 1000:1000 /root/docker/services/minecraft_atm8/data/world/computercraft/computer/"
