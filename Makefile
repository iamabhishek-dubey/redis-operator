all: get-depends build-code build-image

get-depends:
	dep ensure

build-code:
	CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -o bin/redis-operator -ldflags "-X main.commit=${COMMIT} -X main.version=${VERSION}" ./cmd/manager

build-image:
	mv build/Dockerfile .
	docker build -t redis-operator:latest -f Dockerfile .
