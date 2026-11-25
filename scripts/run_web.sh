#!/usr/bin/env bash
set -euo pipefail
docker build -t codyssey-mission1-web:1.0 .
docker rm -f codyssey-mission1-web >/dev/null 2>&1 || true
docker run -d --name codyssey-mission1-web -p 8080:80 codyssey-mission1-web:1.0
echo "Open http://localhost:8080"
docker ps --filter name=codyssey-mission1-web
