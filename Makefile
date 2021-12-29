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

install-deps-linux:
	wget https://github.com/makeworld-the-better-one/didder/releases/download/v1.1.0/didder_1.1.0_linux_64-bit -O /usr/local/bin/didder
	chmod +x /usr/local/bin/didder