__apt_get()
{
    /usr/bin/env LC_ALL=C DEBIAN_FRONTEND=noninteractive apt-get -qq \
        --no-install-recommends \
        -o APT::Install-Suggests=0 \
        -o APT::Get::AutomaticRemove=1 \
        -o Dpkg::Use-Pty=0 \
        -o Dpkg::Options::="--force-unsafe-io" \
        -o Dpkg::Options::="--force-confdef" \
        -o Dpkg::Options::="--force-confold" "$@"
}

__apt_purge()
{
        dpkg --purge --no-triggers --force-remove-reinstreq --force-remove-essential --force-breaks --force-unsafe-io "$@"
}

__apt_upgrade()
{
    # shellcheck disable=SC2015
    __apt_get update &&
    __apt_get full-upgrade &&
    __apt_get ---purge autoremove || :
    __apt_get autoclean || :
    systemctl reboot
}
