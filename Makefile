
#APP = $(shell basename $(shell git remote get-url origin))
APP=kbot
REGISTRY=fatcatmeow
VERSION=$(shell git describe --tags --abbrev=0)-$(shell git rev-parse --short HEAD)
TARGETARCH=arm64
TARGETOS=linux

format:
	gofmt -s -w ./
lint:
	golint
test: 
	go test -v
get: 
	go get
build: format get 
	CGO_ENABLED=0 GOOS=${TARGETOS} GOARCH=${TARGETARCH} go build -v -o kbot -ldflags "-X="github.com/AdlerKot/kbot/cmd.appVersion=${VERSION}
build-mac: format get 
	CGO_ENABLED=0 go build -v -o kbot-app -ldflags "-X="github.com/AdlerKot/kbot/cmd.appVersion=${VERSION}
image:
	docker build . -t ${REGISTRY}/${APP}:${VERSION}-${TARGETARCH}
push:
	docker push ${REGISTRY}/${APP}:${VERSION}-${TARGETARCH}
clean: 
	rm -rf kbot
	docker rmi ${REGISTRY}/${APP}:${VERSION}-${TARGETARCH}
linux:
	CGO_ENABLED=0 GOOS=linux GOARCH=${TARGETARCH} go build -v -o kbot -ldflags "-X="github.com/AdlerKot/kbot/cmd.appVersion=${VERSION}