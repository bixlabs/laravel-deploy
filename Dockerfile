FROM archlinux:base-devel-20210808.0.31089

COPY entrypoint.sh /entrypoint.sh

RUN sudo pacman-keys --populate

RUN sudo pacman-keys --refresh-keys

RUN pacman -Syy openssh rsync --noconfirm

ENTRYPOINT ["/entrypoint.sh"]