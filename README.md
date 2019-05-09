# Prerequisites
- go
- docker
- kubectl

# Start

	make init

# Stop

	make clean

# Update
	
	make apply


# Running on Minikube

	eval $(minikube docker-env)

	make init

	minikube service go-from-scratch
