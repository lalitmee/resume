#!/usr/bin/env bash
set -euo pipefail

track="${1:-current}"
if [[ "$track" != current ]]; then
  printf 'Usage: %s [current]\n' "$0" >&2
  exit 2
fi

root="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
docker build --tag lalit-resume-tex:local "$root"
mkdir -p "$root/dist"
docker run --rm --user "$(id -u):$(id -g)" \
  --mount "type=bind,source=$root,target=/workspace" \
  --workdir /workspace \
  lalit-resume-tex:local \
  -xelatex -interaction=nonstopmode -halt-on-error -outdir=dist resume.tex
