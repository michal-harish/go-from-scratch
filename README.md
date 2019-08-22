# go-from-scratch

This project builds static linux binaries and wraps them in a layer-less Docker image 

1. .amd64 - is copied into Dockerfile and runs the main program (an example http server)
2. test.amd64 - is copied into Dockerfile.test and runs the test suite (also statically)

## Prerequisites

- go
- docker
- kubectl

## Building the main image

    make image

## Building the test image

    make test-image
    
### Running the test image on local docker

    make suite
    
    OR

    docker run -it go-from-scratch.test-amd64:1.0.1

## Kubernetes

	make init #deploys into k8s
	
	make apply #updates the k8s deployment
	
	make stop #stops and removes the k8s deployment
	
### Minikube

    eval $(minikube docker-env)
    
    make init 
    
    minikube service go-from-scratch

    ...
    
	

	
