IMG_NAME=fmi

COMMAND_RUN=docker run \
	  --name fmi \
	  --detach=false \
	  --network host \
	  --rm \
	  -v `pwd`:/home/developer/fmu \
	  -i \
	  -t \
	  ${IMG_NAME} /bin/bash -c

build:
	docker build --network host --no-cache --rm -t ${IMG_NAME} .

remove-image:
	docker rmi ${IMG_NAME}

run:
	$(COMMAND_RUN) \
            "cd /home/developer/ && bash"