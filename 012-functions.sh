fn.print()
{
    printf '[\e[1;33m+\e[m] \e[1;35m%s\e[m\n' "$@"
}

fn.info()
{
    printf '\e[1;36m+\e[m \e[1;34minfo \e[m %s\n' "$@"
}

fn.debug()
{
    printf '\e[1;36m.\e[m \e[1;35mdebug\e[m %s\n' "$@"
}

fn.fatal()
{
    printf '\e[1;36m!\e[m \e[1;31mfatal\e[m %s\n' "$@"
}

fn.ok()
{
    printf '\e[1;36m*\e[m \e[1;32mok   \e[m %s\n' "$@"
}

fn.interpolate()
{
    sed -i "s|__$1__|${!1}|g" $2
}

fn.copy_files()
{
    cd "$1"
        LIST=$(mktemp /tmp/__rsync.XXXXXXXXXX)
        if [ -f "$LIST" ]
        then
            fn.info 'Copying files from files folder...'
            find files/ -type f | cut -d '/' -f 2- | tee "${LIST}" | sed 's/^/     \//'
            rsync -lD --files-from="${LIST}" files/ /
            rm "$LIST"
        fi
     cd -
}

fn.fnmatch()
{ 
    case "$2" in $1) return 0 ;; *) return 1 ;; esac ;
}

fn.is_empty() (
    cd "$1"
    set -- .[!.]* ; test -f "$1" && return 1
    set -- ..?* ; test -f "$1" && return 1
    set -- * ; test -f "$1" && return 1
    return 0
)

fn.quote()
{
    printf %s\\n "$1" | sed "s/'/'\\\\''/g;1s/^/'/;\$s/\$/'/" ;
}

