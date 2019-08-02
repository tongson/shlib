debian.rmusers()
{
    fn.info "Removing useless user accounts..."
    for users in games gnats irc list news sync uucp
    do
        2>/dev/null userdel -r "$users" || true
    done
    fn.info "Successfully removed accounts."
}


debian.rmsuid()
{
    fn.info "Removing suid bits from executables..."
    for p in /bin/fusermount /bin/mount /bin/ping /bin/ping6 /bin/su /bin/umount /usr/bin/bsd-write /usr/bin/chage /usr/bin/chfn /usr/bin/chsh /usr/bin/mlocate /usr/bin/mtr /usr/bin/newgrp /usr/bin/pkexec /usr/bin/traceroute6.iputils /usr/bin/wall /usr/sbin/pppd
    do
        if [ -e "$p" ]
        then
            oct=$(stat -c "%a" $p |sed 's/^4/0/')
            ug=$(stat -c "%U %G" $p)
            2>/dev/null dpkg-statoverride --remove $p || true
            2>/dev/null dpkg-statoverride --add "$ug" "$oct" $p || true
            chmod -s $p
        fi
    done
    fn.info "Successfully removed suid bits."
}
