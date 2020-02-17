.PHONY: build
build:
	docker build -t sbuggay/srcds-docker .

.PHONY: push
push: build
	docker push sbuggay/srcds-docker