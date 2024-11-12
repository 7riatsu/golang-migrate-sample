# https://hub.docker.com/r/migrate/migrate
FROM migrate/migrate

WORKDIR /migrations
ENTRYPOINT ["migrate"]
