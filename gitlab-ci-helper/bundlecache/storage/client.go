package storage

import (
	"context"
	"encoding/base64"
	"errors"
	"io"
	"os"
	"path/filepath"
	"strings"

	"gocloud.dev/gcp"
	"golang.org/x/oauth2/google"

	"github.com/aws/aws-sdk-go/aws"
	"github.com/aws/aws-sdk-go/aws/credentials"
	"github.com/aws/aws-sdk-go/aws/session"

	goblob "gocloud.dev/blob"
	"gocloud.dev/blob/gcsblob"
	"gocloud.dev/blob/s3blob"
)

func StoreBlob(ctx context.Context, blob Blob) error {
	bucket, err := GetBucket(ctx, blob)
	if err != nil {
		return err
	}
	defer bucket.Close()

	inBucketPath := strings.TrimPrefix(blob.LocalPath(), os.TempDir())
	// fix different implementation of TempDir between systems
	inBucketPath = strings.TrimPrefix(inBucketPath, "/")

	writer, err := bucket.NewWriter(ctx, inBucketPath, nil)
	if err != nil {
		return err
	}

	file, err := os.Open(blob.BundlePath())
	if err != nil {
		return err
	}
	defer file.Close()

	_, err = io.Copy(writer, file)
	closeErr := writer.Close()

	if err != nil {
		return err
	}

	return closeErr
}

func DownloadBlob(ctx context.Context, blob Blob) error {
	bucket, err := GetBucket(ctx, blob)
	if err != nil {
		return err
	}
	defer bucket.Close()

	reader, err := bucket.NewReader(ctx, blob.ObjectPath(), nil)
	if err != nil {
		return err
	}
	defer reader.Close()

	if err := os.MkdirAll(filepath.Dir(blob.BundlePath()), 0755); err != nil {
		return err
	}

	file, err := os.OpenFile(blob.BundlePath(), os.O_RDWR|os.O_CREATE|os.O_TRUNC, 0755)
	if err != nil {
		return err
	}
	defer file.Close()

	_, err = io.Copy(file, reader)
	return err
}

var errProviderNotSupported = errors.New("unrecognized scheme, only s3:// and gs:// supported")

func GetBucket(ctx context.Context, blob Blob) (*goblob.Bucket, error) {
	if blob.BucketScheme == s3blob.Scheme {
		session, err := session.NewSession(&aws.Config{
			Region: &blob.BucketRegion,
			Credentials: credentials.NewStaticCredentials(
				blob.AccessKeyID,
				blob.SecretAccessKey,
				"",
			),
		})

		if err != nil {
			return nil, err
		}

		return s3blob.OpenBucket(ctx, session, blob.BucketName, nil)
	}

	if blob.BucketScheme == gcsblob.Scheme {
		jsonKey, err := base64.StdEncoding.DecodeString(blob.SecretAccessKey)

		if err != nil {
			return nil, err
		}

		creds, err := google.CredentialsFromJSON(
			ctx,
			jsonKey,
			"https://www.googleapis.com/auth/devstorage.read_write",
		)

		if err != nil {
			return nil, err
		}

		client, err := gcp.NewHTTPClient(
			gcp.DefaultTransport(),
			gcp.CredentialsTokenSource(creds),
		)

		if err != nil {
			return nil, err
		}

		return gcsblob.OpenBucket(ctx, client, blob.BucketName, nil)
	}

	return nil, errProviderNotSupported
}
