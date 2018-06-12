# ArchLinux image with base-devel
FROM base/devel

RUN sed -i -E 's/^#(en_US.UTF-8 UTF-8)/\1/' /etc/locale.gen && \
    locale-gen && \
    (echo 'LANG=en_US.UTF-8' > /etc/locale.conf)

RUN pacman -Syu --noconfirm && pacman -S --noconfirm git

WORKDIR /root/.dotfiles

COPY . .

RUN scripts/dotf install

CMD /usr/sbin/zsh
