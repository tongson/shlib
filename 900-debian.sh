__debian_aptget()
{
    /usr/bin/env LC_ALL=C DEBIAN_FRONTEND=noninteractive apt-get -qq \
        --no-install-recommends \
        -o APT::Install-Suggests=0 \
        -o APT::Get::AutomaticRemove=1 \
        -o Dpkg::Use-Pty=0 \
        -o Dpkg::Options::="--force-unsafe-io" \
        -o Dpkg::Options::="--force-confold" "$@"
}

__debian_upgrade()
{
    __debian_aptget update &&
    __debian_aptget full-upgrade &&
    __debian_aptget autoremove || :
    __debian_aptget autoclean || :
    systemctl reboot
}
