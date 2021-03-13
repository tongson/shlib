__ecr_pull()
{
    local name="${2%%:*}"
    local tag="${2##*:}"
    [ "$name" = "$tag" ] && local tag="latest"
    podman login -u AWS -p $(/usr/bin/aws ecr get-login --no-include-email|awk '{print $6}') "${1}"
    podman pull "${1}/${name}:${tag}"
}
