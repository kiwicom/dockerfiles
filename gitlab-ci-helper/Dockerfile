FROM golang:1.14 as builder

WORKDIR /src

COPY bundlecache/go.mod bundlecache/go.sum ./
RUN go mod download
COPY bundlecache/ .
RUN CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo -o bundlecache .

FROM gitlab/gitlab-runner-helper:x86_64-4c96e5ad

COPY --from=builder /src/bundlecache /usr/local/bin/bundlecache
