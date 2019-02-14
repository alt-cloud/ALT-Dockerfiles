#!/bin/sh -eu

if [ ! -f custom/conf/app.ini ]; then
    mkdir -p custom/conf
    cp /etc/gitea/app.ini -t custom/conf
fi

start_sshd() {
    if [ -d openssh ]; then
        cp -a openssh -T /etc/openssh
    else
        /usr/bin/ssh-keygen -A
        cp -a /etc/openssh openssh
    fi
    /usr/sbin/sshd -t
    /usr/sbin/sshd
}

start_sshd

chmod 0700 .
chown gitea:gitea . -R

exec su gitea -c "/usr/bin/gitea web"
