build:
	docker build -t kicad-exports . > build.log

install: build
	echo 'docker run \
		-v "$$PWD:/home/$$USER/workdir:rw" \
		--user $$(id -u):$$(id -g) \
		--workdir="/home/$$USER/workdir" \
		--volume="/etc/group:/etc/group:ro" \
	    --volume="/home/$$USER/.config/kicad:/home/$$USER/.config/kicad:rw" \
	    --volume="/home/$$USER/.cache/kicad:/home/$$USER/.cache/kicad:rw" \
	    --volume="/etc/passwd:/etc/passwd:ro" \
	    --volume="/etc/shadow:/etc/shadow:ro" \
		kicad-exports $$@' > kicad-exports
	chmod +x kicad-exports
	mv -f kicad-exports ~/.local/bin/kicad-exports

clean:
	docker image rm -f kicad-exports
	git clean -f -x

shell: build
	docker run -it --entrypoint '/bin/bash' \
		-v "$$PWD:/home/$$USER/workdir:rw" \
		--user $$(id -u):$$(id -g) \
		--workdir="/home/$$USER/workdir" \
		--volume="/etc/group:/etc/group:ro" \
	    --volume="/home/$$USER/.config/kicad:/home/$$USER/.config/kicad:rw" \
	    --volume="/home/$$USER/.cache/kicad:/home/$$USER/.cache/kicad:rw" \
	    --volume="/etc/passwd:/etc/passwd:ro" \
	    --volume="/etc/shadow:/etc/shadow:ro" \
		kicad-exports