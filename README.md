# dockerfiles

This is a collection of Dockerfiles maintained by the [Kiwi.com Platform Team](https://www.kiwi.com/jobs/devs-tech/platform-engineer/).

The images are built automatically by Docker Hub for the `:latest` tag,
with updates of the base image triggering rebuilds.

## kiwicom/curl

- Base image: `alpine:3.6`
- Packages: `curl`, `jq`, `ca-certificates`

We use this mostly in our GitLab CI or otherwise automated tasks. It's useful when the task is about making or parsing HTTPS requests.

## kiwicom/cypress-cli

- Base image: `node:8-slim`
- Packages: npm's `cypress-cli` and dependencies from apt

This is a container with [cypress.io](https://cypress.io) we use to automate our frontend tests.

## kiwicom/dgoss

- Base image: `docker:18.02`
- Packages: goss and dgoss

[goss](https://github.com/aelsabbahy/goss) is a tool for quick and easy server validation.

We use it to, during CI, to start a container and test if it responds on a certain endpoint.

## kiwicom/docker-cleanup

- Base image: `alpine:3.5`
- Packages: `docker`, `curl`, [Spotify's `docker-gc`](https://github.com/spotify/docker-gc), and a script to remove dangling volumes.

We use this to cleanup docker garbage. It removes more garbage than `docker system prune`. Mostly for dev machines purposes.

Usage is `docker run -v/var/run/docker.sock:/var/run/docker.sock kiwicom/docker-cleanup`

## kiwicom/docker-cron

- Base image: `docker:1.12`
- Packages: `tini`

This image runs `crond` in the foreground

It takes a `CRONTAB` environment variable such as `37 13 * * * * echo hi`, to print `hi` everyday at 13:37 UTC.

## kiwicom/docker-gc-cron

- Base image: `alpine:3.5`
- Packages: `docker`, [Spotify's `docker-gc`](https://github.com/spotify/docker-gc)

This is a copy of [clockworksoul's docker-gc-cron](https://github.com/clockworksoul/docker-gc-cron), which is maintained in our GitHub repo for security.

Requires the `/var/run/docker.sock` socket mounted.

## kiwicom/elasticsearch-icu

- Base image: `docker.elastic.co/elasticsearch/elasticsearch:5.2.2`
- Packages: ElasticSearch's `analysis-icu`

We use this for integration tests in CI, as a GitLab CI service.

## kiwicom/flow

- Base image: `alpine:3.6`
- Packages: facebook's `flow`, and its dependencies

We use this in CI to check JavaScript code's type correctness, mounting code to `/app` and running `flow check --show-all-errors`.

## kiwicom/nodesecurity

- Base image: `node:9-alpine`
- Packages: npm `nsm`

We use this in CI to check security issues of Node.js dependencies.

## kiwicom/python-rancher-compose

- Base image: `python:3.6-alpine`
- Packages: rancher-compose, CA certificates

We use this mostly to programmatically create stacks in Rancher.

## kiwicom/s3-sftp

- Base image: `alpine:3.5`
- Packages: OpenSSH server, `s3fs` 1.82 and dependencies

This is a pretty cool image. :snowman: It's a containerized SFTP server with S3 as a backend for storage. 

Check the `entrypoint` file to see how it works.

## kiwicom/s3cmd-plus-docker

- Base image: python:2-alpine
- Packages: `docker` from apk, python `s3cmd`

We use this to copy static files from Docker images and put them onto S3 which serves them.

## kiwicom/s3cmd

- Base image: python:2-alpine

Like above, but no docker.

## kiwicom/s4cmd-plus-docker

Like above, but s4cmd instead of s3cmd
