SHARDS_BIN ?= shards
THREADS ?= --threads=12
CRFLAGS ?= -p --production

build-all: build-site
	@echo "---- Built all"

build-site: build-helix build-content
	@echo "---- Building site"
	rm -rf www
	mv site/out www

build-content:
	@echo "---- Building content"
	cd site && ../bin/helix

build-helix:
	@echo "---- Building helix"
	mkdir -p bin
	cd software/helix && make build
	mv software/helix/bin/helix ./bin