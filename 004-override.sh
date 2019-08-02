drist()
{
    /usr/local/bin/drist "$@"
}

bashing()
{
    1>/dev/null 2>&1 /usr/local/bin/bashing "$@"
}

cd()
{
    1>/dev/null builtin cd "$@"
}

pushd()
{
    1>/dev/null builtin pushd "$@"
}

popd()
{
    1>/dev/null builtin popd
}
