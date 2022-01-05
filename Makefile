SHARDS_BIN ?= shards
THREADS ?= --threads=12
CRFLAGS ?= -p --production

build-all: build-helix build-vangaurd build-site
	@echo "---- Built all"

build-all-dev: build-helix-dev build-site
	@echo "---- Built all-dev"

build-site: build-content
	@echo "---- Building site"
	@sleep 1
	rm -rf docs
	mv site/out docs

build-content: build-helix
	@echo "---- Building content"
	cd site && ../bin/helix

build-helix-dev:
	@echo "---- Building helix"
	mkdir -p bin
	cd software/helix && THREADS=$(THREADS) make build
	mv software/helix/bin/helix ./bin

build-vangaurd:
	@echo "---- Building vangaurd"
	mkdir -p bin
	cd software/starport/vangaurd && shards build $(THREADS)
	mv software/starport/vangaurd/bin/vangaurd ~/.local/bin/vangaurd

build-helix:
	@echo "---- Building helix"
	mkdir -p bin
	CRFLAGS="--pproduction" cd software/helix && CRFLAGS="--production" make build
	mv software/helix/bin/helix ./bin

install-deps-linux:
	wget https://github.com/makeworld-the-better-one/didder/releases/download/v1.1.0/didder_1.1.0_linux_64-bit -O /usr/local/bin/didder
	chmod +x /usr/local/bin/didder

install-deps-non-root:
	mkdir bin
	wget https://github.com/makeworld-the-better-one/didder/releases/download/v1.1.0/didder_1.1.0_linux_64-bit -O bin/didder
	chmod +x bin/didder