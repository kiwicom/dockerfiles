package storage

import (
	"fmt"
	"net/url"
	"os"
	"path/filepath"
	"strings"

	"github.com/urfave/cli/v2"
)

// Blob represents the metadata of a binary file containing the Git bundle of a repository
type Blob struct {
	BucketScheme    string
	BucketName      string
	BucketRegion    string
	AccessKeyID     string
	SecretAccessKey string

	ProjectPath string
}

// BlobFromCtx hydrates the metadata with data from the runtime context
func BlobFromCtx(ctx *cli.Context, projectPath string) (Blob, error) {
	var blob Blob

	url, err := url.Parse(ctx.String("bucket"))
	if err != nil {
		return blob, err
	}

	blob.BucketScheme = url.Scheme
	blob.BucketName = url.Host
	blob.BucketRegion = ctx.String("bucket-region")
	blob.AccessKeyID = ctx.String("access-key-id")
	blob.SecretAccessKey = ctx.String("secret-access-key")

	blob.ProjectPath = projectPath

	return blob, nil
}

func (blob *Blob) LocalPath() string {
	return filepath.Join(os.TempDir(), blob.ProjectPath)
}

func (blob *Blob) BundlePath() string {
	return fmt.Sprintf("%s.bundle", blob.LocalPath())
}

func (blob *Blob) ObjectPath() string {
	return strings.TrimPrefix(
		strings.TrimPrefix(blob.LocalPath(), os.TempDir()),
		"/",
	)
}

func (blob *Blob) BucketURL() string {
	return fmt.Sprintf("%s://%s?region=%s", blob.BucketScheme, blob.BucketName, blob.BucketRegion)
}
