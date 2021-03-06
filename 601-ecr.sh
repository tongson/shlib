__ecr_pull()
{
    _name="${2%%:*}"
    _tag="${2##*:}"
    [ "$_name" = "$_tag" ] && _tag="latest"
    podman login -u AWS -p $(/usr/bin/aws ecr get-login --no-include-email|awk '{print $6}') "${1}"
    podman pull "${1}/${_name}:${_tag}"
}
