#!/bin/sh

if [ "x$CRONTAB" == "x" ]; then
    echo "Set environment variable CRONTAB"
    echo "Example: 0 3 * * * echo hi"
    sleep 10
    exit 1
fi

echo "$CRONTAB" >> /etc/crontabs/root

cat /etc/crontabs/root

exec crond -f
