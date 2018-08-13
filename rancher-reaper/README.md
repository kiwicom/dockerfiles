Rancher AWS Terminated Host Reaper
==================================

> *Note*: This service deletes hosts from Rancher if they are terminated in AWS.
> All care but no responsibility taken.
> Validate it in a test environment first using the "dry run" setting.

# Overview
This is a Docker service which automatically deletes hosts from [Rancher](http://rancher.com/) if they have been terminated in AWS.

If you have set up an autoscaled fleet of Cattle hosts which scale up and down automatically,
you've probably noticed that Rancher does not automatically deactivate and delete the terminated hosts.
As well as generally cluttering the Rancher UI/API,
if not all your containers have health checks this can result in the containers that were on the terminated host *not* being rescheduled onto healthy hosts.
You must then manually delete the terminated hosts in Rancher to force it to reschedule these containers.

Although somewhat annoying this is really the correct behaviour by Rancher.
It has no way to determine if the host has really been terminated or if it has just lost contact with the agent on that host
(say due to a network partition).

So to work around this problem,
this container constantly checks the Rancher API for instances in the "reconnecting" state.
For each of these instances it tries to find the corresponding instance in AWS.
If the instance exists and is in the "terminated" state,
then it deactivates and deletes the host in Rancher.


# Running

## Labelling Hosts
In order to be able to determine if a Rancher host has been terminated in AWS or not,
this service needs to be able to find the corresponding AWS instance in the AWS API.
This turns out to be quite difficult using only the information that is availabile in the Rancher API,
so this service presently requires you to [label your Rancher hosts](http://rancher.com/docs/rancher/v1.6/en/hosts/#host-labels) with the following labels:

* `aws.instance_id` - the AWS instance ID, eg "i-8b92d524"
* `aws.availability_zone` - the availability zone in which the instance resides, eg "us-west-1a"

The easiest way to do this is to look these values up from the AWS [metadata service](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/ec2-instance-metadata.html) when starting the Rancher agent.
For example:

```shell
$ sudo docker run -d --privileged -v /var/run/docker.sock:/var/run/docker.sock \
    -e CATTLE_HOST_LABELS="aws.instance_id=$(curl -s http://169.254.169.254/latest/meta-data/instance-id)&aws.availability_zone=$(curl -s http://169.254.169.254/latest/meta-data/placement/availability-zone)" \
    rancher/agent:v1.0.2 http://<rancher-server>/v1/scripts/<registrationToken>
```

The names of these labels can be configured through environment variables.
See the configuration documentation below for more details.


## Running the Service
You will generally run one instance of this container in each Rancher environment.The following Rancher config should provide you with a good starting point:

docker-compose.yml:
```yaml
rancher-reaper:
  image: ampedandwired/rancher-reaper:latest
  tty: true
  environment:
    AWS_ACCESS_KEY_ID: ${AccessKeyId}
    AWS_SECRET_ACCESS_KEY: ${SecretAccessKey}
  labels:
    io.rancher.container.create_agent: 'true'
    io.rancher.container.agent.role: environment
```

rancher-compose.yml:
```yaml
rancher-reaper:
  scale: 1
  health_check:
    port: 3000
    interval: 2000
    unhealthy_threshold: 3
    strategy: recreate
    response_timeout: 2000
    request_line: GET / HTTP/1.0
    healthy_threshold: 2
```

This container requires the following environment variables to be set:

* `CATTLE_URL`
* `CATTLE_ACCESS_KEY`
* `CATTLE_SECRET_KEY`
* `AWS_ACCESS_KEY_ID`
* `AWS_SECRET_ACCESS_KEY`

The easiest way to set the `CATTLE_*` variables is to set up your container with a [service account](http://docs.rancher.com/rancher/v1.2/en/rancher-services/service-accounts/) by applying the following labels:
```yaml
io.rancher.container.create_agent: true
io.rancher.container.agent.role: environment
```

The `AWS_*` variables should contain AWS API keys that have `ec2:DescribeInstances` and `ec2:DescribeRegions` permissions on all resources.
Use this IAM policy as a guide:
```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "ec2:DescribeInstances",
        "ec2:DescribeRegions"
      ],
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
```

Note that it *is* possible to run a single global instance of this service that acts on hosts in all environments by using a [global API key](https://forums.rancher.com/t/api-key-for-all-environments/279).
Please note that if you take this approach, you need to manually set the `CATTLE_*` environment variables,
as the "service account" approach described above creates single-environment keys only.

## Configuration
The following environment variables can be used to control the behaviour of this service:

* `REAPER_INTERVAL_SECS` - the interval in seconds between checking host status (default: 30).
  If set to "-1" the container will run in "one-shot" mode,
  in which it will check hosts once and then shut down.
  This is useful if you're running the container using an external scheduler such as [Rancher cron](https://github.com/SocialEngine/rancher-cron).
* `REAPER_DRY_RUN` - If set to "true", this service will simply log what it would do without actually doing it (default: false)
* `REAPER_INSTANCE_ID_LABEL_NAME` - The name of the Rancher host label that holds the AWS instance ID. Defaults to `aws.instance_id`.
* `REAPER_AVAILABILITY_ZONE_LABEL_NAME` - The name of the Rancher host label that holds the AWS availability zone. Defaults to `aws.availability_zone`.


# Developing
Suggestions and pull requests welcome at the [GitHub repo](https://github.com/ampedandwired/rancher-reaper).

To run locally in Docker, set the environment variables listed above and run:
```shell
$ docker-compose up
```

Or without docker (local Ruby 2.x installation required):
```shell
$ bundle install
$ bundle exec thin -R lib/config.ru start
```
