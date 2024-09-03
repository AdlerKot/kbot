
#APP = $(shell basename $(shell git remote get-url origin))
APP=kbot
REGISTRY=ghcr.io/adlerkot
VERSION=$(shell git describe --tags --abbrev=0)-$(shell git rev-parse --short HEAD)
#echo $(git describe --tags --abbrev=0)-$(git rev-parse --short HEAD)
TARGETARCH=amd64
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
	docker build . -t ${REGISTRY}/${APP}:${VERSION}-${TARGETOS}-${TARGETARCH}
push:
	docker push ${REGISTRY}/${APP}:${VERSION}-${TARGETOS}-${TARGETARCH}
clean:
	docker rmi ${REGISTRY}/${APP}:${VERSION}-${TARGETOS}-${TARGETARCH}
check:
	echo ${REGISTRY}/${APP}:${VERSION}-${TARGETOS}-${TARGETARCH}
# image2:
# 	docker build . -t ${REGISTRY}/${APP}:${VERSION}-${TARGETARCH}
# push2:
# 	docker push ${REGISTRY}/${APP}:${VERSION}-${TARGETARCH}
# clean: 
# 	rm -rf kbot
# 	docker rmi ${REGISTRY}/${APP}:${VERSION}-${TARGETARCH}