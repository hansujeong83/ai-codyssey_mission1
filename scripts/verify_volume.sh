#!/usr/bin/env bash
set -euo pipefail
VOLUME=codyssey-mission1-data
docker volume create "$VOLUME" >/dev/null
docker rm -f codyssey-volume-a codyssey-volume-b >/dev/null 2>&1 || true
docker run -d --name codyssey-volume-a -v "$VOLUME":/data ubuntu:24.04 sleep infinity
docker exec codyssey-volume-a sh -c 'echo "volume-persistence-ok" > /data/proof.txt'
docker rm -f codyssey-volume-a >/dev/null
docker run -d --name codyssey-volume-b -v "$VOLUME":/data ubuntu:24.04 sleep infinity
RESULT=$(docker exec codyssey-volume-b cat /data/proof.txt)
printf 'Persisted value: %s\n' "$RESULT"
test "$RESULT" = "volume-persistence-ok"
docker rm -f codyssey-volume-b >/dev/null
echo "PASS: data survived container removal."
