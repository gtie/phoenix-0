# Path handling
_makefile_path := $(abspath $(lastword $(MAKEFILE_LIST)))
_makefile_dir := $(dir $(_makefile_path))

DOCKER_RUN = docker run --rm -ti -v $(_makefile_dir):/app  --name ##APPNAME## -p 4000:4000 ##APPNAME##

help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

dockerbuild:
	docker build --rm -t ##APPNAME## .

deps.get: dockerbuild
	$(DOCKER_RUN) "mix deps.get"

phx.server: dockerbuild  ## Run a phoenix server
	$(DOCKER_RUN) mix phx.server

bash: dockerbuild ## Run a bash shell inside a container environment
	$(DOCKER_RUN) bash
