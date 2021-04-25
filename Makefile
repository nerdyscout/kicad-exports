DVOLUMES = --volume="$$PWD:/home/${USER}/workdir:rw" \
		--volume="/etc/group:/etc/group:ro" \
		--volume="/etc/passwd:/etc/passwd:ro" \
		--volume="/etc/shadow:/etc/shadow:ro" \
		--volume="/tmp/.X11-unix:/tmp/.X11-unix" \
		--volume="/home/${USER}/.config/kicad:/home/${USER}/.config/kicad:rw" \
		--volume="/home/${USER}/.cache/kicad:/home/${USER}/.cache/kicad:rw"
DWORKDIR = --workdir="/home/${USER}/workdir"
DUSER = --user $$(id -u):$$(id -g)
DENV = --env NO_AT_BRIDGE=1

build:
	docker build -t kicad-exports \
		--build-arg BUILD_DATE=`date -u +"%Y-%m-%d"` \
		--build-arg BUILD_COMMIT=`git describe --exact-match --tags 2> /dev/null || git rev-parse --abbrev-ref HEAD` \
		. > build.log

install:
	echo 'docker run $(DVOLUMES) $(DWORKDIR) $(DUSER) kicad-exports $$@' > kicad-exports
	chmod +x kicad-exports
	cp -f kicad-exports ~/.local/bin/kicad-exports

install-ci:
	echo 'docker run $(DVOLUMES) $(DWORKDIR) kicad-exports $$@' > kicad-exports
	chmod +x kicad-exports

kicad:
	docker run -it $(DVOLUMES) $(DWORKDIR) $(DUSER) $(DENV) --entrypoint kicad -e DISPLAY=${DISPLAY} kicad-exports

shell:
	docker run -it $(DVOLUMES) $(DWORKDIR) $(DUSER) --entrypoint bash kicad-exports

update:
	docker pull setsoft/kicad_auto:latest
	git submodule foreach git pull
	
clean: clean-test
	docker image rm -f kicad-exports
	git clean -f -x
	rm -r -f kicad-exports build.log
	rm -r -f .config .cache .fontconfig .local

clean-test:
	rm -r -f test_data/output/*
	rm -f tests/log/*.log

test: clean-test build install
	./tests/run.sh || exit $$?

test-ci: clean-test build install-ci
	./tests/run.sh || exit $$?
