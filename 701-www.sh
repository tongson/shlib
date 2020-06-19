_Lfetch()
{
curl -H 'Pragma: no-cache' \
     -H 'Cache-Control: no-cache' \
     --tcp-fastopen --tcp-nodelay \
     --retry 32 --retry-delay 1 \
     -s -L -o "${1}" "${2}"
}

