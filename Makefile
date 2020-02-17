APPDIR = $(dir $(APP))
APPNAME = $(notdir $(APP))


help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

newapp:  valid-app ## Create a new phoenix project. Make sure to pass APP=/path/to/app
	mkdir -p $(APPDIR)
	docker build --rm -t phoenix0 .
	# Run a container to create the basic project structure
	docker run --rm -ti --user $$(id -u):$$(id -g) -v $(realpath $(APPDIR)):/app phoenix0 "echo y | mix phx.new $(APPNAME) $(PHXNEW_ARGS)"
	# Do configuration replacements
	sed "s/##APPNAME##/$(APPNAME)/g" < Dockerfile.app > $(APP)/Dockerfile
	sed "s/##APPNAME##/$(APPNAME)/g" < Makefile.app > $(APP)/Makefile
	sed "s/##APPNAME##/$(APPNAME)/g" < docker-compose.yml.app > $(APP)/docker-compose.yml
	sed -ir 's/password: ".*"/password: ""/g' $(APP)/config/dev.exs
	sed -ir 's/hostname: ".*"/host: "db"/g' $(APP)/config/dev.exs
	# Do project init
	cd $(APP) && docker-compose run web mix deps.get
	cd $(APP) && docker-compose run web mix ecto.create
	cd $(APP) && docker-compose run web bash -c 'cd assets && npm install'

valid-app:
	@: $(if $(APP),,$(error Please set the APP variable to point to the desired directory path of the new project))
