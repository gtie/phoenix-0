FROM elixir:1.10

WORKDIR /app
# Send "mix" dependcies to ephemeral location
ENV HOME=/tmp

RUN mix local.hex --force
RUN mix archive.install hex phx_new --force
ENTRYPOINT ["/bin/bash", "-c"]
