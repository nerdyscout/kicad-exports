build:
	docker build -t kicad-exports \
		--build-arg BUILD_DATE=`date -u +"%Y-%m-%d"` \
		--build-arg BUILD_COMMIT=`git rev-parse --short HEAD` \
		--build-arg VERSION="2.3" \
		. > build.log

install:
	echo 'docker run \
		--volume="$$PWD:/home/${USER}:rw" \
		--volume=/tmp/.X11-unix:/tmp/.X11-unix -e DISPLAY=${DISPLAY} \
		--volume="/home/${USER}/.config/kicad:/home/${USER}/.config/kicad:rw" \
		--volume="/home/${USER}/.cache/kicad:/home/${USER}/.cache/kicad:rw" \
		--volume="/etc/group:/etc/group:ro" \
		--volume="/etc/passwd:/etc/passwd:ro" \
		--volume="/etc/shadow:/etc/shadow:ro" \
		--workdir="/home/${USER}" \
		--user $$(id -u):$$(id -g) \
		kicad-exports $$@' > kicad-exports
	chmod +x kicad-exports

install-local: install
	mv -f kicad-exports ~/.local/bin/kicad-exports

update:
	docker pull setsoft/kicad_auto:latest
	git submodule update

clean:
	docker image rm -f kicad-exports
	git clean -f -x
	rm -r -f kicad-exports build.log

shell:
	docker run -it --entrypoint '/bin/bash' \
		--volume="$$PWD:/home/${USER}:rw" \
		--volume=/tmp/.X11-unix:/tmp/.X11-unix -e DISPLAY=${DISPLAY} \
		--volume="/home/${USER}/.config/kicad:/home/${USER}/.config/kicad:rw" \
		--volume="/home/${USER}/.cache/kicad:/home/${USER}/.cache/kicad:rw" \
		--volume="/etc/group:/etc/group:ro" \
		--volume="/etc/passwd:/etc/passwd:ro" \
		--volume="/etc/shadow:/etc/shadow:ro" \
		--workdir="/home/${USER}" \
		--user $$(id -u):$$(id -g) \
		kicad-exports
		