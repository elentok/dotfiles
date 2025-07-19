# Debian testing
FROM debian:testing

# RUN sed -i -E 's/^#(en_US.UTF-8 UTF-8)/\1/' /etc/locale.gen && \
#     locale-gen && \
#     (echo 'LANG=en_US.UTF-8' > /etc/locale.conf)

# RUN pacman -Syu --noconfirm && pacman -S --noconfirm git

WORKDIR /root/.dotfiles

RUN apt-get update && apt-get -y install sudo git

COPY . .

RUN ./bootstrap.sh

# CMD /usr/sbin/zsh
