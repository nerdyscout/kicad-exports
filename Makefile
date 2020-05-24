DOCKER = docker run -it \
	--volume $(PWD):/mnt \
	kicad-exports

#--user $(id -u):$(id -g) \

build:
	docker build -t kicad-exports .
#	echo "$(DOCKER)" > kicad-exports
#	chmod +x kicad-exports
	cp -u kicad-exports ~/.local/bin/kicad-exports

shell:
	$(DOCKER) bash

clean:
	docker image rm -f kicad-exports
	rm kicad-exports