__systemd_enable()
{
    systemctl daemon-reload
    systemctl enable --now "$@"
}

__systemd_active()
{
    systemctl is-active "$@" && return 0
    return 1
}

__systemd_image()
{
    _name="${1%%:*}"
    _tag="${1##*:}"
    [ "$_name" = "$_tag" ] && _tag="latest"
    _iid=$(/usr/bin/podman images |
    awk -v name="$_name" -v tag="$_tag" '$0 ~ name {if ($2==tag) print $3}')
    sed -i "s|__IMAGE__|$_iid|" "/etc/systemd/system/${2}"
}

__systemd_stop()
{
    systemctl stop "$@" 2>/dev/null || true
    until ! systemctl is-active --quiet "$@"
    do
      sleep 1
    done
}

__systemd_disable()
{
    systemctl disable --now "$@"
}

__systemd_reload()
{
    systemctl daemon-reload
}

__systemd_restart()
{
    systemctl daemon-reload
    systemctl restart "$@"
}
