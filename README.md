# dockerfiles

This is a collection of Dockerfiles maintained by the [Kiwi.com Platform Team](https://www.kiwi.com/jobs/devs-tech/platform-engineer/).

You can use `./release` to build and publish new versions of the images.

Some of them are also configured to be built automatically by Docker Hub for the `:latest` tag,
but this is not that reliable so we recommend manually publishing versions from your dev machine.

## kiwicom/android-automation

- Base image: `python:3.8-alpine`
- Packages: `curl`, `click`, `requests`

This is currently used for automated phraseapp translations within a job in Android CI.

## kiwicom/ansible

- Base image `python:3.6-alpine3.7`
- Packages: CA certificates, ansible

We use this in CI to run Ansible playbooks.

## kiwicom/aws-cli

- Base image: python:3.7-alpine3.8
- Packages: python `awscli`

We use this to use AWS cli from Docker.

## kiwicom/black

- Base image: `python:3.8-alpine`
- Packages: [`black`](https://github.com/psf/black/)

Image used to format python code using [`pre-commit`](https://pre-commit.com) hooks and to check if all the files are correctly formatted on CI.

`pre-commit` hook example:

```yaml
- repo: local
  hooks:
    - id: black
      name: black-code-formatter
      language: docker_image
      entry: --entrypoint black kiwicom/black:19.10b0
      types: [python]
```

GitLab CI example:

```yaml
code-format:
  stage: build
  image: kiwicom/black:19.10b0
  script:
    - black --check .
```

CLI usage example:

`docker run -ti -v "$(pwd)":/src -v "$(pwd)/.blackcache":/home/black/.cache --workdir=/src kiwicom/black:19.10b0 black .`

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

## kiwicom/gitlab-pipeline-checker

- Base image: `alpine:3.9`

A simple script for checking (and waiting for) pipeline status of a Project's commit.

CLI usage example:

```
docker run -t -e GITLAB_API_TOKEN=<token> kiwicom/gitlab-pipeline-checker wait_for_pipeline <project/name> <commit-sha>
```

Gitlab CI example:

```yaml
check_pipeline:
  stage: test
  image: kiwicom/gitlab-pipeline-checker
  script:
    - wait_for_pipeline project/name $(cat remote-build/commit-sha)
```

Note that the `GITLAB_API_TOKEN` variable can be configured in Settings > CI/CD.

## kiwicom/isort

- Base image: `python:3.7-alpine`
- Packages: [`isort`](https://github.com/timothycrosley/isort/)

Image used to format python code using [`pre-commit`](https://pre-commit.com) hooks and to check if all the imports are correctly sorted on CI.

`pre-commit` hook example:

```yaml
- repo: local
  hooks:
    - id: isort
      name: sort-python-imports
      language: docker_image
      entry: --entrypoint isort kiwicom/isort
      types: [python]
```

GitLab CI example:

```yaml
isort:
  stage: build
  image: kiwicom/isort
  script:
    - isort --check-only --diff **/*.py
```

CLI usage example:

`docker run -ti -v "$(pwd)":/src --workdir=/src kiwicom/isort isort **/*.py`

## kiwicom/mypy

- Base image: `python:3.7-alpine`
- Packages: [`mypy`](http://www.mypy-lang.org/)

Image used to type-check python code using [`pre-commit`](https://pre-commit.com) hooks and in CI.

`pre-commit` hook example:

```yaml
- repo: local
  hooks:
    - id: mypy
      name: mypy-type-checks
      language: docker_image
      entry: --entrypoint mypy kiwicom/mypy
      types: [python]
```

GitLab CI example:

```yaml
type-checks:
  stage: build
  image: kiwicom/mypy
  script:
    - mypy -p kw
```

CLI usage example:

`docker run -ti -v "$(pwd)":/src --workdir=/src kiwicom/mypy mypy -p kw`

## kiwicom/markdownlint

- Base image: `node:11-alpine`
- Packages: [`markdownlint-cli`](https://github.com/igorshubovych/markdownlint-cli)

Image used to perform static code analysis of Markdown files we use on CI.

Usage example:

`docker run -ti -v "$(pwd)":/src --workdir=/src kiwicom/markdownlint:0.15.0 markdownlint .`

GitLab CI example:

```yaml
markdownlint:
  stage: build
  image: kiwicom/markdownlint:0.15.0
  script:
    - markdownlint .
```

## kiwicom/nginx-301-https

- Base image: `nginx:alpine`

We use this to redirect http to https in Rancher.

## kiwicom/nodesecurity

- Base image: `node:9-alpine`
- Packages: npm `nsm`

We use this in CI to check security issues of Node.js dependencies.

## kiwicom/poetry

- Base image: python:3.12-slim
- Packages: `poetry` and dependencies

We use this in CI for installing dependencies and uploading to PyPI.

## kiwicom/oauth2-proxy

- Base image: `buildpack-deps:jessie-curl`

We use this as reverse proxy that provides authentication with Gitlab or other provider.

Source: https://github.com/chauffer/dockerfiles/tree/master/oauth2-proxy

## kiwicom/pgbouncer

- Base image: `alpine`
- Packages: [pgbouncer](https://pgbouncer.github.io)

All options have to be configured in `pgbouncer.ini` which you need to mount as a
volume. If you want to use `auth_type = md5` or any other method which requires
`userlist.txt`, you need to mount that as well. Here is an example:

```
docker run -d \
    -p 6432:6432 \
    -v "$(pwd)"/pgbouncer.ini:/etc/pgbouncer/pgbouncer.ini
    -v "$(pwd)"/userlist.txt:/etc/pgbouncer/userlist.txt
    kiwicom/pgbouncer
```

Here is an example of the `pgbouncer.ini` file:

```
[databases]
mydb = host=127.0.0.1 port=5432 dbname=mydb

[pgbouncer]
listen_port = 6432
listen_addr = 127.0.0.1
auth_type = md5
auth_file = /etc/pgbouncer/userlist.txt
pidfile = /etc/pgbouncer/pgbouncer.pid
logfile = /etc/pgbouncer/pgbouncer.log
```

And here is an example of `userlist.txt`:

```
"username1" "md5_of_the_password"
"username2" "md5_of_the_password"
```

For more information, see http://www.pgbouncer.org/usage.html.

## kiwicom/pre-commit

- Base image: `python:3.12-slim`
- packages: `git npm nodejs bash build-base golang pre-commit`
- supported Python versions: 3.12, 3.11, 3.10, 3.9, 3.8, 3.7

We use this image to run our `pre-commit` hooks in CI.

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

- Base image `node:lts-slim`
- Packages: [`python`](https://www.python.org/), [`curl`](https://curl.haxx.se/), [`gcloud SDK`](https://cloud.google.com/sdk/install), [`serverless`](https://serverless.com/), [`aws cli`](https://github.com/aws/aws-cli), [`jq`](https://github.com/stedolan/jq), [`vault`](https://github.com/hashicorp/vault)

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

## kiwicom/spectacles

- Base image: `python:3.8-alpine`
- Packages: `spectacles` (https://github.com/spectacles-ci/spectacles)

Spectacles is a command-line, continuous integration tool for Looker and LookML. spectacles runs validators which perform a range of tests on your Looker instance and your LookML.

## kiwicom/spectral

- Base image: `node:alpine`
- Packages: [`@stoplight/spectral`](https://github.com/stoplightio/spectral)

Image used for linting OpenAPI definitions

GitLab CI example:

```yaml
spectral:
  stage: build
  image:
    name: kiwicom/spectral
  script:
    - spectral lint kw/pub/openapi/openapi.yaml
    - spectral lint kw/baggage/openapi/openapi.yaml
```

## kiwicom/tox

- Base image `alpine:3.21`
- Packages: `tox`, [`pyenv`](https://github.com/pyenv/pyenv) and its dependencies

Image that allows running tox tests on multiple python versions.

## kiwicom/jackalope

- Base image `ubuntu:16.04`

Used for JAMF audit log in slack.

## kiwicom/kubeval

Image for Kubernetes manifests validation.

- Base image `alpine`
- Packages: [`kubectl`](https://kubernetes.io/docs/reference/kubectl), [`kubeval`](https://kubeval.instrumenta.dev)

Gitlab CI example:

```yaml
kubeval:
  stage: lint
  image: kiwicom/kubeval
  script:
    - analyse k8s
```
