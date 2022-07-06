CONTAINER_TAG="latest"

all: build run

build:
	@echo '--- 🐳 Building container image...'
	docker build -t nmap-docker:$(CONTAINER_TAG) .
.PHONY: build

run:
	@echo '--- 🐳 Running container image...'
	docker run --rm nmap-docker
.PHONY: run

smoketest:
	@echo '--- 🐳 Running container smoke test...'
	docker run --rm nmap-docker 127.0.0.1
.PHONY: smoketest
