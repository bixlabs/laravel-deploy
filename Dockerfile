FROM archlinux:base-devel-20220109.0.43549

COPY entrypoint.sh /entrypoint.sh

RUN pacman -Syy openssh rsync glibc --noconfirm

ENTRYPOINT ["/entrypoint.sh"]
