SHARDS_BIN ?= shards
THREADS ?= --threads=8
CRFLAGS ?= -p --production --link-flags -L/usr/lib 

.PHONY: clean clean-helix clean-helix-content clean-helix-site build-all build-all-dev build-site build-content install-vangaurd install-deps-linux install-deps-non-root

all: ./bin/helix ./bin/vangaurd build-site
	@echo "---- Built all"

build-all-dev: ./bin/helix-dev build-site
	@echo "---- Built all-dev"

build-site: build-content
	@echo "---- Building site"
	@sleep 1
	rm -rf docs
	mv site/out docs

build-content: ./bin/helix
	@echo "---- Building content"
	cd site && ../bin/helix

./bin/helix-dev:
	@echo "---- Building helix"
	mkdir -p bin
	cd software/helix && THREADS=$(THREADS) make build
	mv software/helix/bin/helix ./bin

./bin/vangaurd:
	@echo "---- Building vangaurd"
	mkdir -p bin
	cd software/starport/vangaurd && shards build $(THREADS) --link-flags -L/usr/lib

install-vangaurd: ./bin/vangaurd
	mv software/starport/vangaurd/bin/vangaurd ~/.local/bin/vangaurd


clean:
	rm ./bin/*
	rm -rf docs

clean-helix: clean ./bin/helix

clean-helix-content: clean-helix build-content

clean-helix-site: clean-helix build-site

./bin/helix:
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