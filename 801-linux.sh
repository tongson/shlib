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

linux.useradd()
{
    if ! getent passwd "${1}"
    then
        useradd -M -U -u "${2}" "${1}"
        passwd -d "${1}"
        mkdir "/home/${1}"
        chown -R "${2}:${2}" "/home/${1}"
    fi
}

linux.chown()
{
    chown -R "${2}:${2}" "/home/${1}"
}

linux.keygen() {
    rm -f "$2.pub" "$2"
    ssh-keygen -t rsa -b 4096 -P '' -f "$2"
    mkdir "/home/$2/.ssh"
    mv "$2.pub" "/home/$2/.ssh/$1.pub"
    mv "$2" "/home/$2/.ssh/$1.rsa"
    chmod 0600 "/home/$2/.ssh/$1.rsa"
}

