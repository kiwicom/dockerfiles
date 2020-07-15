package storage

import (
	"os"
	"strings"
	"testing"
)

func TestPathMethods(t *testing.T) {
	blob := Blob{projectPath: "mep/mep"}

	if !strings.HasPrefix(blob.localPath(), os.TempDir()) {
		t.Fatal("foo")
	}

	if !strings.HasSuffix(blob.bundlePath(), ".bundle") {
		t.Fatal("bundle has to be the suffix")
	}
}

func TestBucketURL(t *testing.T) {
	blob := Blob{bucketScheme: "s3", bucketName: "gitlab-runners-bundle-cache", bucketRegion: "eu-west-1"}
	if blob.bucketURL() != "s3://gitlab-runners-bundle-cache?region=eu-west-1" {
		t.Fail()
	}
}
