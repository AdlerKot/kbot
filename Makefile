
APP=$(shell basename $(shell git remote get-url origin))
REGISTRY=fatmeowcat
VERSION=$(shell git describe --tags --abbrev=0)-$(shell git rev-parse --short HEAD)
TARGETARCH=arm64
format:
	gofmt -s -w ./
lint:
	golint
test: 
	go test -v
get: 
	go get
build: format get 
	go build -v -o kbot -ldflags "-X="github.com/AdlerKot/kbot/cmd.appVersion=${VERSION}
#CGO_ENABLED=0 GOOS=${TARGETOS} GOARCH=${shell machine} 
clean: 
	rm -rf kbot
image:
	docker build . -t ${REGISTRY}/${APP}:${VERSION}-${TARGETARCH}
push:
	docker push -t ${REGISTRY}/${APP}:${VERSION}-${TARGETARCH}
qwe:
	${APP}