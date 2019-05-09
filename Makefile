name = go-from-scratch
version = 1.0.1
binary = $(name).amd64
image = $(name)-amd64:$(version)

all: apply

clean:
	kubectl delete deployment $(name) && kubectl delete service $(name) && sleep 3 || true
	docker rmi $(image) || true
	rm -f $(binary) Dockerfile 

$(binary): src/*.go src/**/*.go
	go test ./src
	GOOS=linux GOARCH=amd64 go build -ldflags \
	'-w -extldflags "-static"' \
	-o $(binary) ./src/main.go

Dockerfile:
	echo 'FROM scratch\nCOPY $(binary) /$(binary)\nCMD ["/$(binary)"]\n' > Dockerfile
	
image: $(binary) Dockerfile
	docker build -t $(image) ./	

apply: image
	kubectl set image deployment/$(name) $(name)=$(image)

init: image
	kubectl run $(name) --image $(image) --expose --port=8088 --service-overrides='{ "spec": { "type": "NodePort" } }'

.PHONY = clean image apply init
