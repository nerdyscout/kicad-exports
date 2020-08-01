build:
	docker build -t kicad-exports .

install:
#	echo 'docker run -u $$(id -u $$USER):$$(id -g $$USER) -w "$$HOME" -v "$$PWD:$$HOME:rw" kicad-exports $$@' > kicad-exports
	echo 'docker run -w "$$HOME" -v "$$PWD:$$HOME:rw" kicad-exports $$@' > kicad-exports
	chmod +x kicad-exports
	mv -f kicad-exports ~/.local/bin/kicad-exports

clean:
	docker image rm -f kicad-exports
