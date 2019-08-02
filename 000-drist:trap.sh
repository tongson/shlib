set -o errexit -o nounset -o pipefail -o errtrace
PATH=/bin:/sbin:/usr/bin:/usr/sbin

trap 'traperror $? $LINENO $BASH_LINENO "$BASH_COMMAND" $(printf "::%s" ${FUNCNAME[@]:-})' 1 2 3 15 ERR
#trap 'trapexit $? $LINENO' EXIT

function trapexit() {
  print "$0: EXIT on line $2 (exit status $1)"
}

function traperror () {
    local err=$1 # error status
    local line=$2 # LINENO
    local linecallfunc=$3
    local command="$4"
    local funcstack="$5"
    #print "$(date) $(uname -n) $0: ERROR '$command' failed at line $line - exited with status: $err" 

    if [ "$funcstack" != "::" ]; then
      print "$(date) $(uname -n) $0: DEBUG Error in ${funcstack} "
      if [ "$linecallfunc" != "" ]; then
        print "called at line $linecallfunc"
      else
        echo
      fi
    fi
    print "'$command' failed at line $line - exited with status: $err" 
    return $err
}
