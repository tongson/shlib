systemd.start()
{
    systemctl daemon-reload
    systemctl --now enable "$@"
}

systemd.active()
{
    systemctl is-active "$@" && return 0
    return 1
}

systemd.image()
{
    name=$(cut -f1 -d: <<< "${1}")
    tag=$(cut -f2 -d: <<< "${1}")
    [ "$name" = "$tag" ] && tag="latest"
    iid=$(/usr/bin/podman images | grep -F -- "/${name} " | grep -F -- " $tag " | awk '{print $3}')
    sed -i "s|__IMAGE__|$iid|" "/etc/systemd/system/${2}"
}

systemd.stop()
{
    systemctl stop "$@" 2>/dev/null || true
    until ! systemctl is-active --quiet "$@"
    do
      sleep 1
    done
}

systemd.disable()
{
    systemctl disable --now "$@"
}

systemd.restart()
{
    systemctl daemon-reload
    systemctl restart "$@"
}
