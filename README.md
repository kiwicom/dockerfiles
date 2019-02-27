# dockerfiles

This is a collection of Dockerfiles maintained by the [Kiwi.com Platform Team](https://www.kiwi.com/jobs/devs-tech/platform-engineer/).

The images are built automatically by Docker Hub for the `:latest` tag,
with updates of the base image triggering rebuilds.

## kiwicom/ansible

- Base image `python:3.6-alpine3.7`
- Packages: CA certificates, ansible

We use this in CI to run Ansible playbooks.

## kiwicom/aws-cli

- Base image: python:3.7-alpine3.8
- Packages: python `awscli`

We use this to use AWS cli from Docker.

## kiwicom/black

- Base image: `python:3.7-alpine`
- Packages: [`black`](https://github.com/ambv/black/)

Image used to format python code using [`pre-commit`](https://pre-commit.com) hooks and to check if all the files are correctly formatted on CI.

`pre-commit` hook example:

```yaml
- repo: local
  hooks:
    - id: black
      name: black-code-formatter
      language: docker_image
      entry: --entrypoint black kiwicom/black:18.9b0
      types: [python]
```

GitLab CI example:

```yaml
code-format:
  stage: build
  image: kiwicom/black:18.9b0
  script:
    - black --check .
```

CLI usage example:

`docker run -ti -v "$(pwd)":/src -v "$(pwd)/.blackcache":/home/black/.cache --workdir=/src kiwicom/black:18.9b0 black .`

## kiwicom/curl

- Base image: `alpine:3.6`
- Packages: `curl`, `jq`, `ca-certificates`

We use this mostly in our GitLab CI or otherwise automated tasks. It's useful when the task is about making or parsing HTTPS requests.

## kiwicom/cypress-cli

- Base image: `node:8-slim`
- Packages: npm's `cypress-cli` and dependencies from apt

This is a container with [cypress.io](https://cypress.io) we use to automate our frontend tests.

## kiwicom/detekt

- Base image: `zenika/kotlin:1.3-jdk12-alpine`
- Packages: [`detekt`](https://github.com/arturbosch/detekt)

Image used to perform static code analysis of Kotlin code we use on CI.

Usage example:

`docker run -ti -v "$(pwd)":/src --workdir=/src kiwicom/detekt:1.0.0rc14 detekt --input .`

GitLab CI example:

```yaml
detekt:
  stage: build
  image: kiwicom/detekt:1.0.0rc14
  script:
    - detekt --input . --report xml:gl-detekt-report.xml
  artifacts:
    paths:
    - gl-detekt-report.xml
```

## kiwicom/dgoss

- Base image: `docker:18.02`
- Packages: goss and dgoss

[goss](https://github.com/aelsabbahy/goss) is a tool for quick and easy server validation.

We use in CI to to start a container and test if it responds on a certain endpoint.

### `.misc/goss/goss.yaml` example

```yaml
http:
  http://localhost/ping:
    status: 200
    timeout: 100  # milliseconds
    body:
      - pong
```

### `.gitlab-ci.yml` example

```yaml
goss:
  image: kiwicom/dgoss
  variables:
    GOSS_FILES_PATH: .misc/goss
    GOSS_FILES_STRATEGY: cp
  script:
    - docker pull $CI_REGISTRY_IMAGE:$CI_COMMIT_SHA && dgoss run $CI_REGISTRY_IMAGE:$CI_COMMIT_SHA
```

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

## kiwicom/gitlab-datadog-agent

- Base image: `datadog/agent:6.3.3`

A Datadog Agent image that collects metrics exposed by GitLab and GitLab CI.

## kiwicom/mypy

- Base image: `python:3.7-alpine3.8`
- Packages: [`mypy`](http://www.mypy-lang.org/)

Image used to type-check python code using [`pre-commit`](https://pre-commit.com) hooks and in CI.

`pre-commit` hook example:

```yaml
- repo: local
  hooks:
    - id: mypy
      name: mypy-type-checks
      language: docker_image
      entry: --entrypoint mypy kiwicom/mypy:0.620
      types: [python]
```

GitLab CI example:

```yaml
type-checks:
  stage: build
  image: kiwicom/mypy:0.620
  script:
    - mypy -p kw
```

CLI usage example:

`docker run -ti -v "$(pwd)":/src --workdir=/src kiwicom/mypy:0.620 mypy -p kw`

## kiwicom/nginx-301-https

- Base image: `nginx:alpine`

We use this to redirect http to https in Rancher.

## kiwicom/nodesecurity

- Base image: `node:9-alpine`
- Packages: npm `nsm`

We use this in CI to check security issues of Node.js dependencies.

## kiwicom/oauth2-proxy

- Base image: `buildpack-deps:jessie-curl`

We use this as reverse proxy that provides authentication with Gitlab or other provider.

Source: https://github.com/chauffer/dockerfiles/tree/master/oauth2-proxy

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

## kiwicom/sentry

- Base image: [`sentry`](https://hub.docker.com/_/sentry/)
- Packages: [`sentry-auth-gitlab`](https://github.com/SkyLothar/sentry-auth-gitlab), [`datadog`](https://github.com/DataDog/datadogpy)

Our own [`sentry`](https://github.com/getsentry/sentry) image. With GitLab SSO support

## kiwicom/sls

Docker image for Serverless deployment to GCP/AWS.

- Base image `alpine:3.9`
- Packages: [`python`](https://www.python.org/), [`curl`](https://curl.haxx.se/), [`Node.js`](https://nodejs.org/en/), [`npm`](https://www.npmjs.com/), [`gcloud SDK`](https://cloud.google.com/sdk/install), [`serverless`](https://serverless.com/)

Gitlab CI example:

```yaml
deploy:
  stage: deploy
  image: kiwicom/sls:latest
  script:
    - echo $GCLOUD_CREDENTIALS > credentials.json
    - npm install
    - serverless deploy -v
```

## kiwicom/sonarqube

- Base image: `openjdk:8-alpine`
- Packages: `sonarqube-developer`

Because of the bug [SONAR-9384](https://jira.sonarsource.com/browse/SONAR-9384) we were experiencing many problems in our CI pipelines so we needed to upgrade our Sonarqube docker image. As Sonarqube [doesn't offer](https://community.sonarsource.com/t/sonarqube-7-2-released/302) a docker image for 7.2 we decided to build our own.

The usage is the same as with the [official](https://hub.docker.com/_/sonarqube/) image

## kiwicom/sonar-scanner

- Base image: `openjdk:8-jre-alpine`
- Packages: `sonar-scanner`

We use this to scan code for SonarQube. It assumes it's running on GitLab CI.

Usage: `$ scan list,of,dirs` or `$ preview list,of,dirs` for preview mode.
Requires setting `SONARQUBE_URL`

## kiwicom/tox

- Base image `alpine:3.8`
- Packages: `tox`, [`pyenv`](https://github.com/pyenv/pyenv) and its dependencies

Image that allows running tox tests on multiple python versions.
