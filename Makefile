APPDIR = $(dir $(APP))
APPNAME = $(notdir $(APP))


help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

newapp:  valid-app ## Create a new phoenix project. Make sure to pass APP=/path/to/app
	mkdir -p $(APPDIR)
	docker build --rm -t phoenix0 .
	docker run --rm -ti --user $$(id -u):$$(id -g) -v $(realpath $(APPDIR)):/app phoenix0 "echo y | mix phx.new $(APPNAME) $(PHXNEW_ARGS)"
	sed "s/##APPNAME##/$(APPNAME)/g" < Dockerfile.app > $(APP)/Dockerfile
	sed "s/##APPNAME##/$(APPNAME)/g" < Makefile.app > $(APP)/Makefile

valid-app:
	@: $(if $(APP),,$(error Please set the APP variable to point to the desired directory path of the new project))
