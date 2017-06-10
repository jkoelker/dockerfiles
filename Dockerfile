#
# Eagle CAD
#

FROM nfnty/arch-mini:latest

RUN pacman --sync --noconfirm --refresh --sysupgrade && \
    pacman --sync --noconfirm --needed base-devel git vi && \
    find /var/cache/pacman/pkg -mindepth 1 -delete

RUN useradd --create-home --comment "Arch Build User" \
			--system --groups wheel build && \
	echo '%wheel ALL=(ALL) NOPASSWD: ALL' >> /etc/sudoers

USER build
RUN gpg --recv-keys --keyserver hkp://pgp.mit.edu 1EB2638FF56C0C53 && \
	curl -s -o /tmp/aur.sh aur.sh && chmod +x /tmp/aur.sh && \
	cd && /tmp/aur.sh -sri --noconfirm --needed cower pacaur && \
	rm -rf cower pacaur
RUN pacaur -Syyua --noprogressbar --noedit --noconfirm
RUN pacaur -S --noconfirm eagle

# NOTE(jkoelker) The eagle AUR package does not require any fonts,
#                but they are kinda needed
USER root
RUN pacman --sync --noconfirm --needed ttf-croscore

RUN useradd --create-home --comment "Eagle user" eagle
USER eagle

ENTRYPOINT ["/usr/bin/eagle"]
