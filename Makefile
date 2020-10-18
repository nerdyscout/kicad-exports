build:
	docker build --build-arg USER=$$USER -t kicad-exports . > build.log

install:
	echo 'docker run -u $$(id -u):$$(id -g) -v "$$PWD:$$HOME:rw" kicad-exports $$@' > kicad-exports
	chmod +x kicad-exports
	mv -f kicad-exports ~/.local/bin/kicad-exports

clean:
	docker image rm -f kicad-exports
	git clean -f -x

shell: 
	docker run -it --entrypoint '/bin/bash' -u $$(id -u):$$(id -g) -v "$$PWD:/$$HOME:rw" kicad-exports 