## bundlecache

When a pipeline uses high parallelism, the git hosting service might queue the
clone request. For CI, most of the time it's faster to download a `git bundle`
first, than follow up with a `git fetch` and only download a bit of data through
Git. Additionally, this would help save of bandwidth costs if your CI is setup in
another cloud than your self managed GitLab.

The cached bundles need to be created, updated, and used on the CI runner.
`bundlecache` is a small utility to help with the management.

**bundlecache is experimental**

### Using bundlecache

#### Creating and updating bundles

The advised workflow is to create a scheduled pipeline on GitLab CI, that lists
the projects to cache in the `.gitlab-ci.yml`:


```yaml
Generate cache:
  image: kiwicom/gitlab-ci-helper
  script: |
    bundlecache create
    frontend/frontend
    incubator/universe
  only:
    - schedules
    - web
```


#### Using on GitLab CI

When using the GitLab Runner, a `pre_clone_script` can be configured on the
[runner level][runner-config].

This clone script should download and unbundle to `$CI_BUILDS_DIR`. `bundlecache`
could be used with extract too, but do make sure to always exit with a 0 status
code: `which bundlecache && bundlecache extract || true`.

For authentication either flags or environment variables can be used:

```
$ bundlecache --help
NAME:
   bundlecache - Create a repository bundle to avoid unnecessary load in the git service

USAGE:
   bundlecache [global options] command [command options] [arguments...]

VERSION:
   v0.1.0

COMMANDS:
   create   get the repository, create and upload the bundle to object storage
   extract  download and extract the repository bundle, must run in GitLab CI's pre_clone_script
   help, h  Shows a list of commands or help for one command

GLOBAL OPTIONS:
   --host value               Set the GitLab host to clone from (default: "gitlab.skypicker.com") [$CI_SERVER_HOST]
   --user value               Set the clone user for private projects (default: "aexvir") [$GITLAB_USER]
   --token value              Set the access token for GitLab (default: "bZX3wgp_kbUB4-bmKbSp") [$CI_JOB_TOKEN, $GITLAB_PASSWORD]
   --bucket value             set the bucket with scheme: e.g. s3://gitlab-bundle-cache-bucket (default: "gs://kw-gitlab-runner-bundle-cache") [$BC_BUCKET_URL]
   --access-key-id value      set the bucket access key [$BC_ACCESS_KEY_ID, $AWS_ACCESS_KEY_ID, $CACHE_GCS_ACCESS_ID]
   --secret-access-key value  set the secret token used to access the bucket [$BC_SECRET_ACCESS_KEY, $AWS_SECRET_ACCESS_KEY, $CACHE_GCS_PRIVATE_KEY]
   --bucket-region value      set the region for the bucket (default: "europe-west3") [$BC_BUCKET_REGION, $AWS_DEFAULT_REGION]
   --help, -h                 show help (default: false)
   --version, -v              print the version (default: false)
```
