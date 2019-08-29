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
