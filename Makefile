build:
	docker build -t kicad-exports \
		--build-arg BUILD_DATE=`date -u +"%Y-%m-%d"` \
		--build-arg BUILD_COMMIT=`git rev-parse --short HEAD` \
		--build-arg VERSION="2.3" \
		. > build.log

install:
	echo 'docker run \
		-v "$$PWD:/home/$$USER/workdir:rw" \
		-v /tmp/.X11-unix:/tmp/.X11-unix -e DISPLAY=$$DISPLAY \
		--user $$(id -u):$$(id -g) \
		--workdir="/home/$$USER/workdir" \
		--volume="/etc/group:/etc/group:ro" \
	    --volume="/home/$$USER/.config/kicad:/home/$$USER/.config/kicad:rw" \
	    --volume="/home/$$USER/.cache/kicad:/home/$$USER/.cache/kicad:rw" \
	    --volume="/etc/passwd:/etc/passwd:ro" \
	    --volume="/etc/shadow:/etc/shadow:ro" \
		kicad-exports $$@' > kicad-exports
	chmod +x kicad-exports

install-local: install
	mv -f kicad-exports ~/.local/bin/kicad-exports

clean:
	docker image rm -f kicad-exports
	git clean -f -x

shell:
	docker run -it --entrypoint '/bin/bash' \
		-v "$$PWD:/home/$$USER/workdir:rw" \
		-v /tmp/.X11-unix:/tmp/.X11-unix -e DISPLAY=$$DISPLAY \
		--user $$(id -u):$$(id -g) \
		--workdir="/home/$$USER/workdir" \
		--volume="/etc/group:/etc/group:ro" \
	    --volume="/home/$$USER/.config/kicad:/home/$$USER/.config/kicad:rw" \
	    --volume="/home/$$USER/.cache/kicad:/home/$$USER/.cache/kicad:rw" \
	    --volume="/etc/passwd:/etc/passwd:ro" \
	    --volume="/etc/shadow:/etc/shadow:ro" \
		kicad-exports
		