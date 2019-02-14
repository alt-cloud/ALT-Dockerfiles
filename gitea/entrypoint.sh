#!/bin/sh -eu

if [ ! -f custom/conf/app.ini ]; then
    mkdir -p custom/conf
    cp /etc/gitea/app.ini -t custom/conf
fi

start_sshd() {
    # Store openssh config and keys in openssh directory to use them if
    # container recreats
    if [ -d openssh ]; then
        cp -a openssh/* /etc/openssh/
    else
        cp -a /etc/openssh -T openssh
    fi

    if ! ls openssh/ssh_host_*_key openssh/ssh_host_*_key.pub &>/dev/null; then
        /usr/bin/ssh-keygen -A
        cp -a /etc/openssh/* openssh/
    fi

    /usr/sbin/sshd -t
    /usr/sbin/sshd
}

start_sshd

chmod 0700 .
chown gitea:gitea . -R

exec su gitea -c "/usr/bin/gitea web"
