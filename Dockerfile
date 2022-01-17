FROM archlinux:base-devel-20210808.0.31089

COPY entrypoint.sh /entrypoint.sh

RUN pacman-keys --populate

RUN pacman-keys --refresh-keys

RUN pacman -Syy openssh rsync --noconfirm

ENTRYPOINT ["/entrypoint.sh"]