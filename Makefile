IMAGE_NAME="volodymyrsavchenko/integral-osa:latest"

build: 
	docker build -t $(IMAGE_NAME)  .

push: build
	docker push $(IMAGE_NAME)

pull: 
	docker pull $(IMAGE_NAME)

run: build
	docker run -it $(IMAGE_NAME)

run-gui: build
	xhost +local:root && docker run -it  --rm  -e DISPLAY=$(DISPLAY)   -v /tmp/.X11-unix:/tmp/.X11-unix \
	$(IMAGE_NAME)

