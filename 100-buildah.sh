printf '[\e[1;33m%s\e[m] \e[1;35m%s\e[m\n' "+H" "Creating ${NAME} container...";
__CONTAINER=$(/usr/bin/buildah from --name "${NAME}" "${FROM}")
CONFIG()
{
    printf '[\e[1;33m%s\e[m] \e[1;35m%s\e[m\n' "+H" "Applying buildah configuration..."
    /usr/bin/buildah config "$@" "${__CONTAINER}"
}

ENTRYPOINT()
{
    printf '[\e[1;33m%s\e[m] \e[1;35m%s\e[m\n' "+H" "Applying entrypoint configuration..."
    /usr/bin/buildah config --entrypoint "$@" "${__CONTAINER}"
    /usr/bin/buildah config --cmd '' "${__CONTAINER}"
    /usr/bin/buildah config --stop-signal TERM "${__CONTAINER}"
}

COMMIT()
{
    printf '[\e[1;33m%s\e[m] \e[1;35m%s\e[m\n' "+H" "Committing container..."
    /usr/bin/buildah commit --rm --squash "${NAME}" "containers-storage:${1}"
}

PUSH()
{
    printf '[\e[1;33m%s\e[m] \e[1;35m%s\e[m\n' "+H" "Pushing container ${1}:${2} to ECR..."
    TMPDIR=$(mktemp -d -p ".")
    pushd "${TMPDIR}" || exit
        /usr/bin/buildah commit --format docker --squash --rm "${NAME}" dir:"${1}"
        ECRPASS=$(/usr/bin/aws ecr get-login | awk '{print $6}')
        /usr/bin/skopeo copy --dcreds "AWS:${ECRPASS}" "dir:${1}" "docker://872492578903.dkr.ecr.ap-southeast-1.amazonaws.com/${1}:${2}"
        printf '[\e[1;33m%s\e[m] \e[1;35m%s\e[m\n' "+H" "Pushing container ${1}:${2} to containers-storage..."
        /usr/bin/skopeo copy "dir:${1}" containers-storage:${1}:${2}
    popd || exit
    rm -rf "${TMPDIR}"
}

CLEAR()
{
    printf '[\e[1;33m%s\e[m] \e[1;35m%s\e[m\n' "+C" "Clearing directories..."
    /usr/bin/buildah run ${OPTS} "${__CONTAINER}" \
    /usr/bin/find "$@" -type f -delete || true
    /usr/bin/buildah run ${OPTS} "${__CONTAINER}" \
    /usr/bin/find "$@" -type s -delete || true
    /usr/bin/buildah run ${OPTS} "${__CONTAINER}" \
    /usr/bin/find "$@" -type p -delete || true
    /usr/bin/buildah run ${OPTS} "${__CONTAINER}" \
    /usr/bin/find "$@" -mindepth 1 -type d -delete || true
}

RUN()
{
    printf '[\e[1;33m%s\e[m] \e[1;35m%s\e[m\n' "+C" "Running command..."
    /usr/bin/buildah run ${OPTS} "${__CONTAINER}" -- "$@"
}
COPY()
{
    printf '[\e[1;33m%s\e[m] \e[1;35m%s\e[m\n' "+C" "Copying file..."
    /usr/bin/buildah copy "${__CONTAINER}" "$@"
}
MKDIR()
{
    printf '[\e[1;33m%s\e[m] \e[1;35m%s\e[m\n' "+C" "Creating directory..."
    /usr/bin/buildah run ${OPTS} "${__CONTAINER}" -- mkdir -p "$@"
}
SH()
{
    printf '[\e[1;33m%s\e[m] \e[1;35m%s\e[m\n' "+C" "Spawning shell..."
    /usr/bin/buildah run ${OPTS} "${__CONTAINER}" -- sh -c "$@"
}

APT_GET()
{
    printf '[\e[1;33m%s\e[m] \e[1;35m%s\e[m\n' "+C" "Debian apt-get..."
    /usr/bin/buildah run ${OPTS} "${__CONTAINER}" -- \
        /usr/bin/env LC_ALL=C DEBIAN_FRONTEND=noninteractive apt-get -qq \
        --no-install-recommends  \
        -o APT::Install-Suggests=0  \
        -o APT::Get::AutomaticRemove=0 \
        -o Dpkg::Use-Pty=0 \
        -o Dpkg::Options::='--force-confdef' \
        -o Dpkg::Options::='--force-confold' "$@"
}
