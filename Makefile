DVOLUMES = --volume="$$PWD:/home/${USER}/workdir:rw" \
		--volume="/home/${USER}/.config/kicad:/home/${USER}/.config/kicad:rw" \
		--volume="/home/${USER}/.cache/kicad:/home/${USER}/.cache/kicad:rw" \
		--volume="/etc/group:/etc/group:ro" \
		--volume="/etc/passwd:/etc/passwd:ro" \
		--volume="/etc/shadow:/etc/shadow:ro" \
		--volume="/tmp/.X11-unix:/tmp/.X11-unix"
DWORKDIR = --workdir="/home/${USER}/workdir"
DUSER = --user $$(id -u):$$(id -g)

# BUILD
build:
	docker build -t kicad-exports \
		--build-arg BUILD_DATE=`date -u +"%Y-%m-%d"` \
		--build-arg BUILD_COMMIT=`git rev-parse --short HEAD` \
		--build-arg VERSION="2.3" \
		. > build.log

# INSTALL
install:
	echo 'docker run $(DVOLUMES) $(DWORKDIR) $(DUSER) kicad-exports $$@' > kicad-exports
	chmod +x kicad-exports

install-local: install
	mv -f kicad-exports ~/.local/bin/kicad-exports

install-ci:
	echo 'docker run $(DVOLUMES) $(DWORKDIR) kicad-exports $$@' > kicad-exports
	chmod +x kicad-exports

# RUN
kicad:
	docker run -it $(DVOLUMES) $(DWORKDIR) $(DUSER) --entrypoint kicad -e DISPLAY=${DISPLAY} kicad-exports

shell:
	docker run -it $(DVOLUMES) $(DWORKDIR) $(DUSER) --entrypoint bash kicad-exports

# UPDATE
update:
	docker pull setsoft/kicad_auto:latest
	git submodule update

# CLEAN
clean:
	docker image rm -f kicad-exports
	git clean -f -x
	rm -r -f kicad-exports build.log
