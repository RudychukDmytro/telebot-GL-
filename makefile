IMAGE_NAME := image
DOCKER_REGISTRY := quay.io/projectquay
CONTAINER_NAME := my_container

linux:
	GOOS=linux GOARCH=amd64 go build -o $(IMAGE_NAME)_linux

arm:
	GOOS=linux GOARCH=arm go build -o $(IMAGE_NAME)_arm

macos:
	GOOS=darwin GOARCH=amd64 go build -o $(IMAGE_NAME)_macos

windows:
	GOOS=windows GOARCH=amd64 go build -o $(IMAGE_NAME)_windows

clean:
	docker rmi $(DOCKER_REGISTRY)/$(IMAGE_NAME):latest

stop:
	docker stop $(CONTAINER_NAME)
	docker rm $(CONTAINER_NAME)
