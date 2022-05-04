CRYSTAL_BIN ?= crystal
SHARDS_BIN ?= shards
PREFIX ?= /usr/local
SHARD_BIN ?= ../../bin
THREADS ?= --threads=8
CRFLAGS ?= -p --production --link-flags -L/usr/lib


build: clean
	$(SHARDS_BIN) build --link-flags -L/usr/lib $(CRFLAGS) $(THREADS)

clean:
	rm -rf bin

install: build
	mkdir -p $(PREFIX)/bin
	cp ./bin/helix $(PREFIX)/bin

bin: build
	mkdir -p $(SHARD_BIN)
	cp bin/helix $(SHARD_BIN)

test: build
	$(CRYSTAL_BIN) spec
	./bin/helix --all

dev:
	$(SHARDS_BIN) build -p $(THREADS)
	mv ./bin/helix ./