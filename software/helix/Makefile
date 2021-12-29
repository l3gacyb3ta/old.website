CRYSTAL_BIN ?= crystal
SHARDS_BIN ?= shards
PREFIX ?= /usr/local
SHARD_BIN ?= ../../bin
THREADS ?= --threads=12
CRFLAGS ?= -p --production

build: clean
	$(SHARDS_BIN) build $(CRFLAGS) $(THREADS)

clean:
	rm -rf bin

install: build
	mkdir -p $(PREFIX)/bin
	cp ./bin/monis $(PREFIX)/bin

bin: build
	mkdir -p $(SHARD_BIN)
	cp ./bin/monis $(SHARD_BIN)

test: build
	$(CRYSTAL_BIN) spec
	./bin/monis --all

dev:
	$(SHARDS_BIN) build -p $(THREADS)
	mv ./bin/monis ./