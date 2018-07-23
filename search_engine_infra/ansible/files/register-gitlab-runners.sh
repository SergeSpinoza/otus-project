#!/bin/bash

RUNNERS=2
URL="http://35.204.135.157/"
TOKEN="zekw5wfMHoMi7PfoA3TX"

for (( c=1; c<=$RUNNERS; c++ ))
do
  docker run -d --name gitlab-runner-$c --restart always \
    -v /srv/gitlab-runner/config:/etc/gitlab-runner \
    -v /var/run/docker.sock:/var/run/docker.sock \
    gitlab/gitlab-runner:latest

  docker exec -it gitlab-runner-$c gitlab-runner register \
    --non-interactive \
    --executor "docker" \
    --docker-image alpine:latest \
    --url $URL \
    --registration-token $TOKEN \
    --description "my-runner-$c" \
    --tag-list "linux,xenial,ubuntu,docker" \
    --run-untagged \
    --docker-privileged \
    --locked="false"
done
