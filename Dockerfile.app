FROM elixir:1.10

WORKDIR /app

# Put mix dependencies inside the mounted folder
RUN apt-get update && \
       apt-get install -y inotify-tools postgresql-client && \
       apt-get autoclean

RUN mix local.hex --force
RUN mix local.rebar --force

ADD . /app
ENTRYPOINT ["/bin/bash", "-c"]
