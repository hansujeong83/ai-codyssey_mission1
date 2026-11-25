#!/usr/bin/env bash
set -u
echo "=== Codyssey Mission 1 environment check ==="
echo "[OS]"; uname -a
echo "[Shell]"; printf 'SHELL=%s\n' "${SHELL:-unknown}"
echo "[Python]"; python3 --version 2>&1 || true
echo "[Git]"; git --version 2>&1 || true
echo "[Docker CLI]"; docker --version 2>&1 || true
echo "[Docker daemon]"
if docker info >/dev/null 2>&1; then
  echo "Docker daemon: READY"
else
  echo "Docker daemon: NOT READY (start Docker Desktop / approved runtime)"
fi
echo "[WSL hint]"; grep -qi microsoft /proc/version 2>/dev/null && echo "Running inside WSL" || echo "Not detected as WSL"
