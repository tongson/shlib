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

_Lfnmatch()
{ 
    case "$2" in $1) return 0 ;; *) return 1 ;; esac ;
}

_Lis_empty() (
    cd "$1" || return 1
    set -- .[!.]* ; test -f "$1" && return 1
    set -- ..?* ; test -f "$1" && return 1
    set -- * ; test -f "$1" && return 1
    return 0
)

_Lquote()
{
    printf %s\\n "$1" | sed "s/'/'\\\\''/g;1s/^/'/;\$s/\$/'/" ;
}

