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
    _iid=$(/usr/bin/podman images |
    awk -v name="$_name" -v tag="$_tag" '$0 ~ name {if ($2==tag) print $3}')
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

systemd.reload()
{
    systemctl daemon-reload
}

systemd.restart()
{
    systemctl daemon-reload
    systemctl restart "$@"
}
