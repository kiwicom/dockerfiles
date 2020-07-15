package cmd

import (
	"context"
	"errors"
	"fmt"
	"os"
	"os/exec"
	"path/filepath"

	"gitlab.skypicker.com/platform/software/gitlab-ci/bundlecache/storage"

	"github.com/urfave/cli/v2"
)

func ExtractRepo(ctx *cli.Context) error {
	projectPath, ok := os.LookupEnv("CI_PROJECT_PATH")
	if !ok {
		return errors.New("error: $CI_PROJECT_PATH not defined, not in GitLab-CI")
	}

	blob, err := storage.BlobFromCtx(ctx, projectPath)
	if err != nil {
		return err
	}

	fmt.Printf("📦 Downloading %s bundle...\n", projectPath)

	if err := storage.DownloadBlob(context.Background(), blob); err != nil {
		return errors.New("cached git bundle not found, fetching all the changes from gitaly...")
	}
	if err := extractBundle(blob); err != nil {
		return err
	}

	return nil
}

func extractBundle(blob storage.Blob) error {
	targetPath, ok := os.LookupEnv("CI_PROJECT_DIR")
	if !ok {
		return errors.New("error: $CI_PROJECT_DIR not defined, not in GitLab-CI")
	}

	if err := os.MkdirAll(filepath.Dir(targetPath), 0755); err != nil {
		return err
	}

	_ = os.RemoveAll(targetPath)
	cmd := exec.Command("git", "clone", blob.BundlePath(), targetPath)

	// we don't need to be verbose in a CI job just started
	// which is why there's no: cmd.Stdout = os.Stdout
	cmd.Stderr = os.Stderr
	return cmd.Run()
}
