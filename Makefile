build:
	docker build -t kicad-exports .
	echo 'docker run -it --volume $$PWD:/mnt kicad-exports' > kicad-exports
	chmod +x kicad-exports
	cp -u kicad-exports ~/.local/bin/kicad-exports

clean:
	docker image rm -f kicad-exports
	rm kicad-exports