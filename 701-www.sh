__fetch()
{
curl -H 'Pragma: no-cache' \
     -H 'Cache-Control: no-cache' \
     --tcp-fastopen --tcp-nodelay \
     --retry-connrefused \
     --retry 32 --retry-delay 1 \
     -s -L -o "${2}" "${1}"
}

__get_json()
{
curl -X GET \
     -H 'Accept: application/json' \
     -H 'Pragma: no-cache' \
     -H 'Cache-Control: no-cache' \
     -v --fail --silent --show-error -L "${1}"
}
