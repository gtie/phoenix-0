version: "3"
services:
  db:
    image: postgres:11-alpine
    environment:
      - POSTGRES_HOST_AUTH_METHOD=trust
      - POSTGRES_DB=##APPNAME##_dev
  web:
    build: .
    command: mix phx.server
    volumes:
      - .:/app
    ports:
      - "4000:4000"
    environment:
      - PGHOST=db
    depends_on:
      - db
