trap '_TRAP_ERROR $? $LINENO "$BASH_COMMAND"' 1 2 3 15 ERR

function _TRAP_ERROR() {
    local err=$1
    local line=$2
    local command="$3"
    fn.fatal "'$command' failed at line $line - exited with status: $err" 
    return $err
}
