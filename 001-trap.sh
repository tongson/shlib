trap '_TRAP_ERROR $? $LINENO $BASH_COMMAND; exit' 1 2 3 15 ERR

function _TRAP_ERROR() {
    local err=$1
    local line=$2
    local command="$3"
    printf '%s failed at line %s - exited with status: %s\n' $command $line $err
    return $err
}
