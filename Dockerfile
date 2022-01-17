FROM archlinux:base-devel-20210808.0.31089

COPY entrypoint.sh /entrypoint.sh

RUN pacman -Syyu openssh rsync --noconfirm

ENTRYPOINT ["/entrypoint.sh"]