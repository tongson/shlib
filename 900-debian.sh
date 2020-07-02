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

__debian_purge()
{
        dpkg --purge --no-triggers --force-remove-essential --force-breaks --force-unsafe-io "$@"
}

__debian_upgrade()
{
    __debian_aptget update &&
    __debian_aptget full-upgrade &&
    __debian_aptget ---purge autoremove || :
    __debian_aptget autoclean || :
    systemctl reboot
}
