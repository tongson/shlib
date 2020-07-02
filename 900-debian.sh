__debian_aptget()
{
    /usr/bin/env LC_ALL=C DEBIAN_FRONTEND=noninteractive apt-get -qq \
        --no-install-recommends \
        -o APT::Install-Suggests=0 \
        -o APT::Get::AutomaticRemove=1 \
        -o Dpkg::Use-Pty=0 \
        -o Dpkg::Options::="--force-confdef" \
        -o Dpkg::Options::="--force-confold" "$@"
}

__debian_upgrade()
{
    debian.aptget update &&
    debian.aptget full-upgrade &&
    debian.aptget autoremove || :
    debian.aptget autoclean || :
    systemctl reboot
}
