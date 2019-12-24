ecr.pull()
{
    _name="${2%%:*}"
    _tag="${2##*:}"
    [ "$_name" = "$_tag" ] && _tag="latest"
    /usr/bin/podman login -u AWS -p $(/usr/bin/aws ecr get-login --no-include-email|awk '{print $6}') 872492578903.dkr.ecr.ap-southeast-1.amazonaws.com
    /usr/bin/podman pull "${1}/${_name}:${_tag}"
}
