#!/usr/bin/env bash
# ansible-lint dengan versi dikunci di dalam container: sama persis di laptop dan di CI.
set -euo pipefail
cd "$(dirname "$0")/.."
docker run --rm -v "$PWD":/repo -w /repo python:3.13-slim sh -ec '
  pip install -q --root-user-action=ignore --disable-pip-version-check ansible-lint==26.11.0
  ansible-galaxy collection install -r ansible/requirements.yml >/dev/null
  ansible-lint --profile production ansible/
'
