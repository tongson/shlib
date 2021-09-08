__linux_osid()
{
  local v
  v=$(awk '(/^ID='"${1}"'/ || /^ID="'"${1}"'/ || /^ID=\x27'"${1}"'/) {n++} END {print n}' /etc/os-release)
  if [ "$v" = 1 ]
  then
    return 0
  else
    return 1
  fi
}

__linux_useradd()
{
    if ! getent passwd "${1}"
    then
        useradd -M -U -u "${2}" "${1}"
        passwd -d "${1}"
        mkdir "/home/${1}"
        chown -R "${2}:${2}" "/home/${1}"
    fi
}
