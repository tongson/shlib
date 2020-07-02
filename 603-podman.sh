__podman_start()
{
    name="${1%%:*}"
    tag="${1##*:}"
    [ "$name" = "$tag" ] && tag="latest"

    # stop any existing container first
    systemctl disable --now "podman:${name}.service" 2>&- ||:
    until ! podman top "${name}" 2>&- 1>/dev/null
    do
        sleep 1
    done

    # get desired image ID and generate unit
    iid=$(podman images |
    awk -v name="$name" -v tag="$tag" '$0 ~ name" " {if ($2==tag) print $3}')
    sed -i "s|__IMAGE__|$iid|" "/etc/systemd/system/podman:${name}.service"

    # start the systemd unit
    systemctl daemon-reload
    systemctl enable --now "podman:${name}.service"
}
