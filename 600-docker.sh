__podman_pull()
{
    # docker.pull docker://.... name:tag login:password
    _name="${2%%:*}"
    _tag="${2##*:}"
    _username="${3%%:*}"
    _password="${3##*:}"
    [ "$_name" = "$_tag" ] && _tag="latest"
    /usr/bin/podman login -u "${_username}" -p "${_password}" "${1}"
    /usr/bin/podman pull "${1}/${_name}:${_tag}"
}
