detach := true

DOCKER_STACK := docker stack
DOCKER_STACK_NAMESPACE := promstack-compose-support
DOCKER_STACK_CONFIG := docker stack config
DOCKER_STACK_CONFIG_ARGS := --skip-interpolation
DOCKER_STACK_DEPLOY_ARGS := --detach=$(detach) --with-registry-auth

.EXPORT_ALL_VARIABLES:
include .dockerenv

make:
deploy:
	$(DOCKER_STACK) deploy $(DOCKER_STACK_DEPLOY_ARGS) -c docker-stack.yml $(DOCKER_STACK_NAMESPACE)
upgrade:
	$(DOCKER_STACK) deploy $(DOCKER_STACK_DEPLOY_ARGS) --resolve-image always -c docker-stack.yml $(DOCKER_STACK_NAMESPACE)
remove:
	$(DOCKER_STACK) rm $(DOCKER_STACK_NAMESPACE)
