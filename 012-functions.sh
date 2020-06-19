_Lprint()
{
    printf '[\e[1;33m+\e[m] \e[1;35m%s\e[m\n' "$@"
}

_Linfo()
{
    printf '\e[1;36m+\e[m \e[1;34minfo \e[m %s\n' "$@"
}

_Ldebug()
{
    printf '\e[1;36m.\e[m \e[1;35mdebug\e[m %s\n' "$@"
}

_Lfatal()
{
    printf '\e[1;36m!\e[m \e[1;31mfatal\e[m %s\n' "$@"
}

_Lok()
{
    printf '\e[1;36m*\e[m \e[1;32mok   \e[m %s\n' "$@"
}

_Linterpolate()
{
    sed -i "s|__$1__|${!1}|g" $2
}

_Lcopy_files()
{
    cd "$1"
        LIST=$(mktemp /tmp/__rsync.XXXXXXXXXX)
        if [ -f "$LIST" ]
        then
            _Linfo 'Copying files from files folder...'
            find files/ -type f | cut -d '/' -f 2- | tee "${LIST}" | sed 's/^/     \//'
            rsync -lD --files-from="${LIST}" files/ /
            rm "$LIST"
        fi
     cd -
}

_Lfnmatch()
{ 
    case "$2" in $1) return 0 ;; *) return 1 ;; esac ;
}

_Lis_empty() (
    cd "$1"
    set -- .[!.]* ; test -f "$1" && return 1
    set -- ..?* ; test -f "$1" && return 1
    set -- * ; test -f "$1" && return 1
    return 0
)

_Lquote()
{
    printf %s\\n "$1" | sed "s/'/'\\\\''/g;1s/^/'/;\$s/\$/'/" ;
}

