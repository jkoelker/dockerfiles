#!/bin/sh

usermod -o -u "$UID" weechat
groupmod -o -g "$GID" weechat

mkdir -p /weechat/python/autoload
rm -f /weechat/python/wee_slack.py
wget -P /weechat/python https://raw.githubusercontent.com/wee-slack/wee-slack/master/wee_slack.py
ln -s /weechat/python/wee_slack.py /weechat/python/autoload/wee_slack.py

chown -R weechat:weechat /weechat

exec setpriv --reuid=weechat --regid=weechat --init-groups weechat "$@"
