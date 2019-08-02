ecr.pull()
{
    name=$(cut -f1 -d: <<< "${1}")
    tag=$(cut -f2 -d: <<< "${1}")
    [ "$name" = "$tag" ] && tag="latest"
    /usr/bin/podman login -u AWS -p $(/usr/bin/aws ecr get-login --no-include-email|awk '{print $6}') 872492578903.dkr.ecr.ap-southeast-1.amazonaws.com
    /usr/bin/podman pull "docker://872492578903.dkr.ecr.ap-southeast-1.amazonaws.com/${name}:${tag}"
}
