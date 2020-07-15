package cmd

import (
	"context"
	"fmt"
	"net/url"
	"os"
	"os/exec"
	"path/filepath"

	"github.com/urfave/cli/v2"
	"gitlab.skypicker.com/platform/software/gitlab-ci/bundlecache/storage"
)

func BundleRepo(ctx *cli.Context) error {
	for _, project := range ctx.Args().Slice() {
		blob, err := storage.BlobFromCtx(ctx, project)
		if err != nil {
			return err
		}

		if err := bundleProject(ctx, blob); err != nil {
			return err
		}

		if err := storage.StoreBlob(context.Background(), blob); err != nil {
			return err
		}

		fmt.Printf("bundle for %s created successfully 🎉\n\n", project)
	}

	return nil
}

func bundleProject(ctx *cli.Context, blob storage.Blob) error {
	if err := gitClone(ctx, blob); err != nil {
		return err
	}
	if err := gitBundle(blob); err != nil {
		return err
	}

	return nil
}

// gitClone inflates
func gitClone(ctx *cli.Context, blob storage.Blob) error {
	// Make sure the sink does not exist
	_ = os.RemoveAll(blob.LocalPath())

	if err := os.MkdirAll(filepath.Dir(blob.LocalPath()), 0755); err != nil {
		return err
	}

	host := ctx.String("host")
	url, err := url.Parse("https://" + host)

	if err != nil {
		return err
	}

	user := ctx.String("user")
	password := ctx.String("token")

	cloneURL := fmt.Sprintf("%s://%s:%s@%s/%s.git", url.Scheme, user, password, url.Host, blob.ProjectPath)

	cmd := exec.Command("git", "clone", "--bare", cloneURL, blob.LocalPath())
	cmd.Stdout = os.Stdout
	cmd.Stderr = os.Stderr
	return cmd.Run()
}

func gitBundle(blob storage.Blob) error {
	cmd := exec.Command("git", "-C", blob.LocalPath(), "bundle", "create", blob.BundlePath(), "--all")

	cmd.Stdout = os.Stdout
	cmd.Stderr = os.Stderr
	return cmd.Run()
}
