systemd.start()
{
    fn.info "Enabling and starting service..."
    systemctl daemon-reload
    systemctl --now enable "$@"
}

systemd.active()
{
    fn.info "Checking if container service is up..."
    systemctl is-active "$@" && return 0
    return 1
}

systemd.image()
{
    fn.info "Generating systemd unit..."
    name=$(cut -f1 -d: <<< "${1}")
    tag=$(cut -f2 -d: <<< "${1}")
    [ "$name" = "$tag" ] && tag="latest"
    iid=$(/usr/bin/podman images | grep -F -- "/${name} " | grep -F -- " $tag " | awk '{print $3}')
    sed -i "s|__IMAGE__|$iid|" "/etc/systemd/system/${2}"
}

systemd.stop()
{
    fn.info "Stopping existing unit..."
    systemctl stop "$@" 2>/dev/null || true
    until ! systemctl is-active --quiet "$@"
    do
      sleep 1
    done
}

systemd.disable()
{
    fn.info "Disabling unit ($*)..."
    systemctl disable --now "$@"
}

systemd.restart()
{
    fn.info "Restarting unit ($*)..."
    systemctl daemon-reload
    systemctl restart "$@"
}
