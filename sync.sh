for f in 7 8 9; do
  rsync -rv --exclude=startup.lua --exclude=.git --exclude=README.md --exclude=sync.sh --chown=1000:1000 --rsync-path="sudo rsync" ./ timo@scode.ovh:/root/docker/services/minecraft_atm8/data/world/computercraft/computer/$f/;
done
