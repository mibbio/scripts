# sudo tar -vcf /mnt/storage/backup/mibbio.tar.xz /home/mibbio/ --exclude='*ropbox*' --exclude='.cache' &&
U=${SUDO_USER:-$USER}
G=$(id -g -n ${U})
sudo rsync -vauRPmh --delete --exclude='*ropbox*' --exclude='dbox' --exclude='.cache' --exclude='*Geny*' --exclude='*Steam*' /home/mibbio /mnt/storage/backup &&
sudo chown -R ${U}:${G} /mnt/storage/backup/home &&
sudo rsync -vauRPmh /etc /mnt/storage/backup/ &&
sudo rsync -vauRPmh /var/lib/pacman/local /mnt/storage/backup/
