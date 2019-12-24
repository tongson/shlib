systemd.start()
{
    systemctl daemon-reload
    systemctl enable --now "$@"
}

systemd.active()
{
    systemctl is-active "$@" && return 0
    return 1
}

systemd.image()
{
    _name="${1%%:*}"
    _tag="${1##*:}"
    [ "$_name" = "$_tag" ] && _tag="latest"
    _iid=$(/usr/bin/podman images | grep -F -- "/${_name} " | grep -F -- " $_tag " | awk '{print $3}')
    sed -i "s|__IMAGE__|$_iid|" "/etc/systemd/system/${2}"
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
