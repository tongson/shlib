linux.osid()
{
    [[ $(awk '(/^ID='${1}'/ || /^ID="'${1}'/ || /^ID=\x27'${1}'/) {n++} END {print n}' /etc/os-release) = "1" ]] && return 0
    return 1
}

linux.install()
{
    if linux.osid "opensuse"
    then
        zypper --non-interactive install --no-recommends "$@"
    fi
    if linux.osid "debian"
    then
         /usr/bin/env LC_ALL=C DEBIAN_FRONTEND=noninteractive apt-get -qq \
        --no-install-recommends  \
        -o APT::Install-Suggests=0  \
        -o APT::Get::AutomaticRemove=1 \
        -o Dpkg::Use-Pty=0 \
        -o Dpkg::Options::='--force-confdef' \
        -o Dpkg::Options::='--force-confold' "$@"        
    fi
}
