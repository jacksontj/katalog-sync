BUILD := build
GO ?= go
GOFILES := $(shell find . -name "*.go" -type f ! -path "./vendor/*")
GOFMT ?= gofmt
GOIMPORTS ?= goimports -local=github.com/wish/katalog-sync
STATICCHECK ?= staticcheck

.PHONY: clean
clean:
	$(GO) clean -i ./...
	rm -rf $(BUILD)

.PHONY: static-check
static-check:
	$(STATICCHECK) ./...

.PHONY: fmt
fmt:
	$(GOFMT) -w -s $(GOFILES)

.PHONY: imports
imports:
	$(GOIMPORTS) -w $(GOFILES)

.PHONY: test
test:
	$(GO) test -v ./...

.PHONY: docker
docker:
	DOCKER_BUILDKIT=1 docker build .

testlocal-build:
	DOCKER_BUILDKIT=1 docker build -t quay.io/wish/katalog-sync:latest .
	kind load docker-image quay.io/wish/katalog-sync:latest
