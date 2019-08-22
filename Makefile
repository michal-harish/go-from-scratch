name = go-from-scratch
version = 1.0.1
binary = $(name).amd64
test-binary = $(name).test.amd64
image = $(name)-amd64:$(version)
test-image = $(name)-test-amd64:$(version)

all: apply

.PHONY = clean test suite test-binary image apply init stop

clean:
	docker rmi $(image) || true
	rm -f $(binary) Dockerfile
	rm -f $(test-binary) Dockerfile.test


# MAIN

image: $(binary) Dockerfile
	docker build -t $(image) ./	

Dockerfile: $(binary)
	echo 'FROM scratch\nCOPY $(binary) /$(binary)\nCMD ["/$(binary)"]\n' > Dockerfile

$(binary): src/*.go src/**/*.go
	go test ./src
	GOOS=linux GOARCH=amd64 go build -ldflags \
	'-w -extldflags "-static"' \
	-o $(binary) ./src/main.go


# TEST

suite: test-image
	docker run -it $(test-image)

test-image: $(test-binary) Dockerfile.test
	docker build -t $(test-image) -f Dockerfile.test ./

Dockerfile.test: $(test-binary) Makefile
	echo 'FROM scratch\nCOPY src $(shell pwd)/src\nCOPY $(test-binary) /$(test-binary)\nCMD ["/$(test-binary)", "-test.v"]\n' > Dockerfile.test

$(test-binary): src/*.go src/**/*.go
	GOOS=linux GOARCH=amd64 go test ./src -c -ldflags \
	'-w -extldflags "-static"' \
	-o $(test-binary)


# KUBE

init: image
	kubectl run $(name) --image $(image) --restart=Never --expose --port=8088 --service-overrides='{ "spec": { "type": "NodePort" } }'

apply: image
	kubectl set image deployment/$(name) $(name)=$(image)

stop:
	kubectl delete pod $(name) && kubectl delete service $(name) && sleep 3 || true


