package main

import (
	"fmt"
	"os"

	"github.com/urfave/cli/v2"
	"gitlab.skypicker.com/platform/software/gitlab-ci/bundlecache/cmd"
)

func main() {
	app := &cli.App{
		Name:    "bundlecache",
		Usage:   "Create a repository bundle to avoid unnecessary load in the git service",
		Flags:   flags,
		Version: "v0.1.0",
		Commands: []*cli.Command{
			{
				Name:   "create",
				Usage:  "get the repository, create and upload the bundle to object storage",
				Action: cmd.BundleRepo,
			},
			{
				Name:   "extract",
				Usage:  "download and extract the repository bundle, must run in GitLab CI's pre_clone_script",
				Action: cmd.ExtractRepo,
			},
		},
	}

	if err := app.Run(os.Args); err != nil {
		fmt.Println(err)
		os.Exit(1)
	}
}

var flags = []cli.Flag{
	&cli.StringFlag{
		Name:    "host",
		Value:   "gitlab.com",
		Usage:   "Set the GitLab host to clone from",
		EnvVars: []string{"CI_SERVER_HOST"},
	},
	&cli.StringFlag{
		Name:    "user",
		Value:   "gitlab-ci-token",
		Usage:   "Set the clone user for private projects",
		EnvVars: []string{"GITLAB_USER"},
	},
	&cli.StringFlag{
		Name:    "token",
		Usage:   "Set the access token for GitLab",
		EnvVars: []string{"CI_JOB_TOKEN", "GITLAB_PASSWORD"},
	},
	&cli.StringFlag{
		Name:    "bucket",
		Usage:   "set the bucket with scheme: e.g. s3://gitlab-bundle-cache-bucket",
		EnvVars: []string{"BC_BUCKET_URL"},
	},
	&cli.StringFlag{
		Name:    "access-key-id",
		Usage:   "set the bucket access key",
		EnvVars: []string{"BC_ACCESS_KEY_ID", "AWS_ACCESS_KEY_ID", "CACHE_GCS_ACCESS_ID"},
	},
	&cli.StringFlag{
		Name:    "secret-access-key",
		Usage:   "set the secret token used to access the bucket",
		EnvVars: []string{"BC_SECRET_ACCESS_KEY", "AWS_SECRET_ACCESS_KEY", "CACHE_GCS_PRIVATE_KEY"},
	},
	&cli.StringFlag{
		Name:    "bucket-region",
		Usage:   "set the region for the bucket",
		EnvVars: []string{"BC_BUCKET_REGION", "AWS_DEFAULT_REGION"},
	},
}
