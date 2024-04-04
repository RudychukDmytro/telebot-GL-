APP=$(shell basename $(shell git remote get-url origin))
REGISTRY:=hub.docker.com
VERSION=$(shell git describe --tags --abbrev=0)-$(shell git rev-parse --short HEAD)
TARGETOS=linux
TARGETARCH=arm64

IMAGE_NAME := image
DOCKER_REGISTRY := quay.io/projectquay
CONTAINER_NAME := my_container

format:
	gofmt -s -w ./

get:
	go get

build: format get
	CGO_ENABLED=0 GOOS=$(TARGETOS) GOARCH=$(shell dpkg --print-architecture) go build -v -o mybot -ldflags "-X="github.com/RudychukDmytro/telebot-GL-/cmd.appVersion=$(VERSION)

lint:
	go test -v
linux:
	GOOS=linux GOARCH=amd64 go build -o $(IMAGE_NAME)_linux

arm:
	GOOS=linux GOARCH=arm go build -o $(IMAGE_NAME)_arm

macos:
	GOOS=darwin GOARCH=amd64 go build -o $(IMAGE_NAME)_macos

windows:
	GOOS=windows GOARCH=amd64 go build -o $(IMAGE_NAME)_windows

clean:
	rm -rf mybot

image:
	docker build . -t ${REGISTRY}/${APP}:${VERSION}-${TARGETARCH}

push:
	docker push $(REGISTRY)/$(APP):$(VERSION)-$(TARGETARCH)

stop:
	docker stop $(CONTAINER_NAME)
	docker rm $(CONTAINER_NAME)
