APP := $(shell basename $(shell git remote get-url origin))
REGISTRY := rudychuk
VERSION := $(shell git describe --tags --abbrev=0)-$(shell git rev-parse --short HEAD)
TARGETOS := linux
TARGETARCH := arm64

IMAGE_NAME := mybot
LD_FLAGS := -X=github.com/RudychukDmytro/telebot-GL-/cmd.appVersion=$(VERSION)
IMAGE_TAG := $(REGISTRY)/$(APP):$(VERSION)-$(TARGETARCH)


format:
	gofmt -s -w ./
	
get:
	go get

build: format get
	CGO_ENABLED=0 GOOS=$(TARGETOS) GOARCH=$(TARGETARCH) go build -v -o $(IMAGE_NAME) -ldflags "$(LD_FLAGS)"

test:
	go test -v

lint:
	golint

linux: format get
	GOOS=linux GOARCH=amd64 go build -o $(IMAGE_NAME) -ldflags "$(LD_FLAGS)"

arm: format get
	GOOS=linux GOARCH=arm go build -o $(IMAGE_NAME) -ldflags "$(LD_FLAGS)"

macos: format get
	GOOS=darwin GOARCH=amd64 go build -o $(IMAGE_NAME) -ldflags "$(LD_FLAGS)"

windows: format get
	GOOS=windows GOARCH=amd64 go build -o $(IMAGE_NAME) -ldflags "$(LD_FLAGS)"

clean:
	docker rmi $(IMAGE_TAG)

image:
	docker build . -t ${REGISTRY}/${APP}:${VERSION}-${TARGETARCH}

push:
	docker push $(REGISTRY)/$(APP):$(VERSION)-$(TARGETARCH)

stop:
	docker stop $(CONTAINER_NAME)
	docker rm $(CONTAINER_NAME)
