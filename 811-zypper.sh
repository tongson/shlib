__zypper_install()
{
  zypper --non-interactive install --no-recommends "$@"
}
